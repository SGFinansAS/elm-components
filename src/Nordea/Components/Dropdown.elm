module Nordea.Components.Dropdown exposing
    ( Dropdown
    , init
    , simple
    , standard
    , view
    , withAriaLabel
    , withHasError
    , withPlaceholder
    , withSelectedValue
    , withSmallSize
    )

import Css
    exposing
        ( absolute
        , backgroundColor
        , border3
        , borderColor
        , borderRadius
        , borderStyle
        , color
        , cursor
        , ellipsis
        , focus
        , fontSize
        , height
        , inherit
        , lineHeight
        , none
        , outline
        , padding4
        , pct
        , pointer
        , pointerEvents
        , position
        , property
        , relative
        , rem
        , right
        , solid
        , textOverflow
        , top
        , transform
        , translateY
        , transparent
        , width
        )
import Css.Global exposing (withAttribute)
import Dict
import Html.Styled as Html exposing (Attribute, Html, div, option)
import Html.Styled.Attributes as Attrs exposing (css, disabled, selected, value)
import Html.Styled.Events as Events exposing (targetValue)
import Json.Decode as Decode
import List.Extra as List
import Maybe.Extra as Maybe
import Nordea.Html exposing (attrEmpty, styleIf, viewMaybe)
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Icons as Icon
import Nordea.Themes as Themes


type Variant
    = Standard
    | Simple


type Size
    = StandardSize
    | SmallSize


type alias Option a =
    { value : a
    , text : String
    , group : Maybe String
    , isDisabled : Bool
    }


type alias DropdownProperties a msg =
    { placeholder : Maybe String
    , onInput : a -> msg
    , options : List (Option a)
    , optionToString : a -> String
    , selectedValue : Maybe a
    , hasError : Bool
    , ariaLabel : Maybe String
    , variant : Variant
    , size : Size
    , fallbackGroupLabel : String
    }


type Dropdown a msg
    = Dropdown (DropdownProperties a msg)


simple : List { value : a, text : String } -> (a -> String) -> (a -> msg) -> Dropdown a msg
simple options optionToString onInput =
    let
        ops =
            options
                |> List.map
                    (\o ->
                        { value = o.value
                        , text = o.text
                        , group = Nothing
                        , isDisabled = False
                        }
                    )

        (Dropdown config) =
            init ops optionToString onInput
    in
    Dropdown { config | variant = Simple }


standard : List { value : a, text : String } -> (a -> String) -> (a -> msg) -> Dropdown a msg
standard options optionToString onInput =
    let
        ops =
            options
                |> List.map
                    (\o ->
                        { value = o.value
                        , text = o.text
                        , group = Nothing
                        , isDisabled = False
                        }
                    )

        (Dropdown config) =
            init ops optionToString onInput
    in
    Dropdown { config | variant = Standard }


init : List (Option a) -> (a -> String) -> (a -> msg) -> Dropdown a msg
init options optionToString onInput =
    Dropdown
        { placeholder = Nothing
        , onInput = onInput
        , options = options
        , optionToString = optionToString
        , selectedValue = Nothing
        , hasError = False
        , variant = Standard
        , size = StandardSize
        , ariaLabel = Nothing
        , fallbackGroupLabel = ""
        }


view : List (Attribute msg) -> Dropdown a msg -> Html msg
view attrs (Dropdown config) =
    let
        placeholder =
            config.placeholder
                |> viewMaybe
                    (\placeholderText ->
                        option
                            [ value "", disabled True, selected True, Attrs.hidden True ]
                            [ Html.text placeholderText ]
                    )

        optsToView opts =
            opts
                |> List.map
                    (\o ->
                        option
                            [ o.value |> config.optionToString |> value
                            , selected (config.selectedValue == Just o.value)
                            , disabled o.isDisabled
                            , css [ color Colors.black ]
                            ]
                            [ Html.text o.text ]
                    )

        anyGroups =
            config.options |> List.any (.group >> Maybe.isJust)

        options =
            if anyGroups then
                config.options
                    |> List.gatherEqualsBy .group
                    |> List.map (\( head, tail ) -> ( head.group, head :: tail ))
                    |> List.map
                        (\( group, elems ) ->
                            case group of
                                Just g ->
                                    Html.optgroup [ Attrs.attribute "label" g ]
                                        (optsToView elems)

                                Nothing ->
                                    Html.optgroup [ Attrs.attribute "label" config.fallbackGroupLabel ]
                                        (optsToView elems)
                        )

            else
                optsToView config.options

        optionsDict =
            config.options
                |> List.map (\opt -> ( config.optionToString opt.value, opt.value ))
                |> Dict.fromList

        decoder =
            targetValue
                |> Decode.andThen
                    (\val ->
                        case Dict.get val optionsDict of
                            Nothing ->
                                Decode.fail ""

                            Just tag ->
                                Decode.succeed tag
                    )
                |> Decode.map config.onInput

        isDisabled =
            List.member (Attrs.disabled True) attrs

        cursorValue =
            if isDisabled then
                Css.default

            else
                pointer

        iconChevron =
            case ( config.variant, config.size ) of
                ( Standard, StandardSize ) ->
                    Icon.chevronDownFilled
                        [ Attrs.attribute "aria-hidden" "true"
                        , css
                            [ position absolute
                            , top (pct 50)
                            , transform (translateY (pct -50))
                            , right (rem 0.3125)
                            , pointerEvents none
                            , color Colors.coolGray
                            ]
                        ]

                ( Standard, SmallSize ) ->
                    Icon.chevronDownFilledSmall
                        [ Attrs.attribute "aria-hidden" "true"
                        , css
                            [ position absolute
                            , top (pct 50)
                            , transform (translateY (pct -50))
                            , right (rem 0.3125)
                            , pointerEvents none
                            , color Colors.coolGray
                            ]
                        ]

                ( Simple, _ ) ->
                    Icon.chevronDownBolded
                        [ Attrs.attribute "aria-hidden" "true"
                        , css
                            [ position absolute
                            , top (pct 50)
                            , transform (translateY (pct -50))
                            , right (rem 0.75)
                            , width (rem 0.75) |> Css.important
                            , height (rem 0.75)
                            , pointerEvents none
                            , color inherit
                            ]
                        ]

        ( sizeSpecificHeight, sizeSpecificStyling ) =
            case config.size of
                StandardSize ->
                    ( height (rem 2.5), [ height (pct 100), fontSize (rem 1), padding4 (rem 0.25) (rem 2.5) (rem 0.25) (rem 0.75), lineHeight (rem 1.4) ] )

                SmallSize ->
                    ( height (rem 1.6), [ height (pct 100), fontSize (rem 0.75), padding4 (rem 0.25) (rem 0.25) (rem 0.25) (rem 0.5), lineHeight (rem 1) ] )
    in
    div
        (Attrs.attribute "role" "none" :: css [ position relative, sizeSpecificHeight ] :: attrs)
        [ Html.select
            [ Events.on "change" decoder
            , Attrs.disabled isDisabled
            , case config.ariaLabel of
                Just l ->
                    Attrs.attribute "aria-label" l

                Nothing ->
                    attrEmpty
            , css
                ([ width (pct 100)
                 , property "appearance" "none"
                 , property "-moz-appearance" "none"
                 , property "-webkit-appearance" "none"
                 , backgroundColor transparent
                 , if config.variant /= Simple || config.hasError then
                    border3 (rem 0.0625) solid Colors.mediumGray

                   else
                    borderStyle none
                 , borderColor Colors.darkRed |> styleIf config.hasError
                 , borderRadius (rem 0.25)
                 , focus
                    [ Css.property "box-shadow" ("0rem 0rem 0rem 0.0625rem " ++ Themes.colorVariable Colors.nordeaBlue)
                    , outline none
                    ]
                 , color inherit
                 , withAttribute "disabled" [ color Colors.nordeaGray, backgroundColor Colors.coolGray ]
                 , cursor cursorValue
                 , textOverflow ellipsis |> styleIf (config.variant == Simple)
                 ]
                    ++ sizeSpecificStyling
                )
            ]
            (placeholder :: options)
        , iconChevron
        ]


withSmallSize : Dropdown a msg -> Dropdown a msg
withSmallSize (Dropdown config) =
    Dropdown { config | size = SmallSize }


withSelectedValue : Maybe a -> Dropdown a msg -> Dropdown a msg
withSelectedValue selectedValue (Dropdown config) =
    Dropdown { config | selectedValue = selectedValue }


withPlaceholder : String -> Dropdown a msg -> Dropdown a msg
withPlaceholder placeholder (Dropdown config) =
    Dropdown { config | placeholder = Just placeholder }


withHasError : Bool -> Dropdown a msg -> Dropdown a msg
withHasError hasError (Dropdown config) =
    Dropdown { config | hasError = hasError }


withAriaLabel : String -> Dropdown a msg -> Dropdown a msg
withAriaLabel label (Dropdown config) =
    Dropdown { config | ariaLabel = Just label }
