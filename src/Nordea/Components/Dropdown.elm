module Nordea.Components.Dropdown exposing
    ( Dropdown
    , init
    , initWithOptionProperties
    , optionInit
    , optionIsDisabled
    , simple
    , standard
    , view
    , withHasError
    , withPlaceholder
    , withSelectedValue
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
        , focus
        , fontSize
        , height
        , inherit
        , lineHeight
        , none
        , outline
        , padding4
        , paddingRight
        , pct
        , pointer
        , pointerEvents
        , position
        , property
        , relative
        , rem
        , right
        , solid
        , top
        , transform
        , translateY
        , transparent
        , width
        )
import Css.Global exposing (withAttribute)
import Dict
import Html.Styled as Html exposing (Attribute, Html, div, option, text)
import Html.Styled.Attributes as Attrs exposing (css, disabled, selected, value)
import Html.Styled.Events as Events exposing (targetValue)
import Json.Decode as Decode
import Nordea.Html exposing (styleIf, viewMaybe)
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Icons as Icon
import Nordea.Themes as Themes


type Variant
    = Standard
    | Simple


type alias Option a =
    { value : a
    , text : String
    , isDisabled : Bool
    }


optionInit : { value : a, text : String } -> Option a
optionInit { value, text } =
    { value = value
    , text = text
    , isDisabled = False
    }


optionIsDisabled : Bool -> Option a -> Option a
optionIsDisabled isDisabled option =
    { option | isDisabled = isDisabled }


type alias DropdownProperties a msg =
    { placeholder : Maybe String
    , onInput : a -> msg
    , options : List (Option a)
    , optionToString : a -> String
    , selectedValue : Maybe a
    , hasError : Bool
    , variant : Variant
    }


type Dropdown a msg
    = Dropdown (DropdownProperties a msg)


simple : List { value : a, text : String } -> (a -> String) -> (a -> msg) -> Dropdown a msg
simple options optionToString onInput =
    let
        (Dropdown config) =
            init options optionToString onInput
    in
    Dropdown { config | variant = Simple }


standard : List { value : a, text : String } -> (a -> String) -> (a -> msg) -> Dropdown a msg
standard options optionToString onInput =
    let
        (Dropdown config) =
            init options optionToString onInput
    in
    Dropdown { config | variant = Standard }


init : List { value : a, text : String } -> (a -> String) -> (a -> msg) -> Dropdown a msg
init options optionToString onInput =
    initWithOptionProperties (List.map optionInit options) optionToString onInput


initWithOptionProperties : List (Option a) -> (a -> String) -> (a -> msg) -> Dropdown a msg
initWithOptionProperties options optionToString onInput =
    Dropdown
        { placeholder = Nothing
        , onInput = onInput
        , options = options
        , optionToString = optionToString
        , selectedValue = Nothing
        , hasError = False
        , variant = Standard
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

        options =
            config.options
                |> List.map
                    (\dropDownOption ->
                        option
                            [ dropDownOption.value |> config.optionToString |> value
                            , selected (config.selectedValue == Just dropDownOption.value)
                            , disabled dropDownOption.isDisabled
                            , css [ color Colors.black ]
                            ]
                            [ Html.text dropDownOption.text ]
                    )

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

        iconChevron =
            let
                standardIcon =
                    Icon.chevronDownFilled
                        [ css
                            [ position absolute
                            , top (pct 50)
                            , transform (translateY (pct -50))
                            , right (rem 0.3125)
                            , pointerEvents none
                            , color Colors.coolGray
                            ]
                        ]
            in
            case config.variant of
                Standard ->
                    standardIcon

                Simple ->
                    Icon.chevronDown
                        [ css
                            [ position absolute
                            , top (pct 50)
                            , transform (translateY (pct -50))
                            , right (rem 0.75)
                            , width (rem 1.125) |> Css.important
                            , height (rem 1.125)
                            , pointerEvents none
                            , color inherit
                            ]
                        ]
    in
    div
        (css [ position relative ] :: attrs)
        [ Html.select
            [ Events.on "change" decoder
            , Attrs.disabled isDisabled
            , css
                [ height (rem 2.5)
                , width (pct 100)
                , property "appearance" "none"
                , property "-moz-appearance" "none"
                , property "-webkit-appearance" "none"
                , backgroundColor transparent
                , padding4 (rem 0.5) (rem 2) (rem 0.5) (rem 1)
                , paddingRight (rem 3) |> styleIf (config.variant /= Simple)
                , if config.variant /= Simple || config.hasError then
                    border3 (rem 0.0625) solid Colors.mediumGray

                  else
                    borderStyle none
                , borderColor Colors.darkRed |> styleIf config.hasError
                , borderRadius (rem 0.25)
                , focus
                    [ Css.property "box-shadow" ("1rem 0rem 0rem 0.0625rem " ++ Themes.colorVariable Colors.nordeaBlue)
                    , outline none
                    ]
                , fontSize (rem 1.0)
                , lineHeight (rem 1.4)
                , color inherit
                , withAttribute "disabled" [ color Colors.nordeaGray, backgroundColor Colors.coolGray ]
                , cursor pointer
                ]
            ]
            (placeholder :: options)
        , iconChevron
        ]


withSelectedValue : Maybe a -> Dropdown a msg -> Dropdown a msg
withSelectedValue selectedValue (Dropdown config) =
    Dropdown { config | selectedValue = selectedValue }


withPlaceholder : String -> Dropdown a msg -> Dropdown a msg
withPlaceholder placeholder (Dropdown config) =
    Dropdown { config | placeholder = Just placeholder }


withHasError : Bool -> Dropdown a msg -> Dropdown a msg
withHasError hasError (Dropdown config) =
    Dropdown { config | hasError = hasError }
