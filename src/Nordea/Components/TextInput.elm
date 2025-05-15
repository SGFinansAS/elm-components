module Nordea.Components.TextInput exposing
    ( TextInput
    , init
    , view
    , withClearInput
    , withCurrency
    , withError
    , withId
    , withInputAttrs
    , withMaxLength
    , withOnBlur
    , withOnEnterPress
    , withOnInput
    , withPattern
    , withPlaceholder
    , withSearchIcon
    , withSmallSize
    )

import Css
    exposing
        ( absolute
        , backgroundColor
        , border3
        , borderBox
        , borderRadius
        , boxSizing
        , color
        , cursor
        , disabled
        , displayFlex
        , focus
        , fontSize
        , height
        , left
        , none
        , num
        , opacity
        , outline
        , padding2
        , padding4
        , paddingLeft
        , paddingRight
        , pct
        , pointer
        , pointerEvents
        , position
        , relative
        , rem
        , right
        , solid
        , top
        , transform
        , translateY
        , width
        )
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Html
    exposing
        ( attribute
        , css
        , maxlength
        , pattern
        , placeholder
        , tabindex
        , value
        )
import Html.Styled.Events exposing (onBlur, onClick, onInput)
import Maybe.Extra as Maybe
import Nordea.Components.Text as Text
import Nordea.Html as Html exposing (showIf, styleIf)
import Nordea.Html.Events as Events
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Icons as Icons
import Nordea.Themes as Themes



-- CONFIG


type alias Config msg =
    { value : String
    , onInput : Maybe (String -> msg)
    , placeholder : Maybe String
    , showError : Bool
    , maxLength : Maybe Int
    , pattern : Maybe String
    , hasSearchIcon : Bool
    , hasClearIcon : Bool
    , onBlur : Maybe msg
    , onEnterPress : Maybe msg
    , currency : Maybe String
    , size : Size
    , id : Maybe String
    , inputAttrs : List (Attribute msg)
    }


type Size
    = Small
    | Standard


type TextInput msg
    = TextInput (Config msg)


init : String -> TextInput msg
init value =
    TextInput
        { value = value
        , onInput = Nothing
        , placeholder = Nothing
        , showError = False
        , maxLength = Nothing
        , pattern = Nothing
        , hasSearchIcon = False
        , hasClearIcon = False
        , onBlur = Nothing
        , onEnterPress = Nothing
        , currency = Nothing
        , size = Standard
        , id = Nothing
        , inputAttrs = []
        }


withOnInput : (String -> msg) -> TextInput msg -> TextInput msg
withOnInput onInput (TextInput config) =
    TextInput { config | onInput = Just onInput }


withPlaceholder : String -> TextInput msg -> TextInput msg
withPlaceholder placeholder (TextInput config) =
    TextInput { config | placeholder = Just placeholder }


withMaxLength : Int -> TextInput msg -> TextInput msg
withMaxLength maxLength (TextInput config) =
    TextInput { config | maxLength = Just maxLength }


withPattern : String -> TextInput msg -> TextInput msg
withPattern pattern (TextInput config) =
    TextInput { config | pattern = Just pattern }


withError : Bool -> TextInput msg -> TextInput msg
withError condition (TextInput config) =
    TextInput { config | showError = condition }


withSearchIcon : Bool -> TextInput msg -> TextInput msg
withSearchIcon condition (TextInput config) =
    TextInput { config | hasSearchIcon = condition }


withOnBlur : msg -> TextInput msg -> TextInput msg
withOnBlur msg (TextInput config) =
    TextInput { config | onBlur = Just msg }


withOnEnterPress : msg -> TextInput msg -> TextInput msg
withOnEnterPress msg (TextInput config) =
    TextInput { config | onEnterPress = Just msg }


withCurrency : String -> TextInput msg -> TextInput msg
withCurrency currency (TextInput config) =
    TextInput { config | currency = Just currency }


withClearInput : TextInput msg -> TextInput msg
withClearInput (TextInput config) =
    TextInput
        { config
            | hasClearIcon = True
        }


withSmallSize : TextInput msg -> TextInput msg
withSmallSize (TextInput config) =
    TextInput { config | size = Small }


withId : String -> TextInput msg -> TextInput msg
withId id (TextInput config) =
    TextInput { config | id = Just id }


withInputAttrs : List (Attribute msg) -> TextInput msg -> TextInput msg
withInputAttrs attrs (TextInput config) =
    TextInput { config | inputAttrs = attrs }



-- VIEW


view : List (Attribute msg) -> TextInput msg -> Html msg
view attributes (TextInput config) =
    let
        viewSearchIcon =
            Icons.search
                [ attribute "aria-hidden" "true"
                , css
                    [ width (rem 1)
                    , height (rem 1)
                    , opacity (num 0.5)
                    , position absolute
                    , color
                        (if config.showError then
                            Colors.darkRed

                         else
                            Colors.nordeaBlue
                        )
                    , left (rem 0.7)
                    , top (pct 50)
                    , transform (translateY (pct -50))
                    , pointerEvents none
                    ]
                ]
                |> showIf config.hasSearchIcon

        viewClearIcon =
            let
                sizeSpecificStyling_ =
                    if config.size == Small then
                        [ width (rem 1.5), padding4 (rem 0.2) (rem 0.125) (rem 0.125) (rem 0.125) ]

                    else
                        [ width (rem 2.5), padding4 (rem 0.35) (rem 0.25) (rem 0.25) (rem 0.25) ]
            in
            Icons.roundedCross
                (Maybe.values
                    [ Just
                        (css
                            (sizeSpecificStyling_
                                ++ [ color Colors.mediumGray
                                   , position absolute
                                   , right (rem 0)
                                   , cursor pointer
                                   ]
                            )
                        )
                    , config.onInput |> Maybe.map (\onInput -> onClick (onInput ""))
                    , Just (tabindex -1)
                    , Just (attribute "aria-hidden" "true")
                    ]
                )
                |> showIf ((config.value |> String.isEmpty |> not) && config.hasClearIcon)

        borderColorStyle =
            if config.showError then
                Colors.darkRed

            else
                Colors.mediumGray

        ( sizeSpecificHeight, sizeSpecificStyling ) =
            case config.size of
                Small ->
                    ( height (rem 1.5)
                    , [ fontSize (rem 0.75)
                      , padding2 (rem 0.25) (rem 0.5)
                      , paddingRight (rem 1.5)
                            |> styleIf
                                ((config.value |> String.isEmpty |> not)
                                    && config.hasClearIcon
                                )
                      ]
                    )

                Standard ->
                    ( height (rem 2.5)
                    , [ fontSize (rem 1)
                      , padding2 (rem 0) (rem 0.75)
                      , paddingRight (rem 3)
                            |> styleIf
                                ((config.value |> String.isEmpty |> not)
                                    && config.hasClearIcon
                                )
                      ]
                    )
    in
    Html.div
        (css [ displayFlex, position relative, sizeSpecificHeight ] :: attributes)
        [ viewSearchIcon
        , Html.input
            (css
                (sizeSpecificStyling
                    ++ [ borderRadius (rem 0.25)
                       , border3 (rem 0.0625) solid borderColorStyle
                       , boxSizing borderBox
                       , width (pct 100)
                       , disabled [ backgroundColor Colors.grayWarm ]
                       , paddingLeft (rem 2) |> styleIf config.hasSearchIcon
                       , focus
                            [ outline none
                            , Themes.borderColor Colors.nordeaBlue
                            ]
                       ]
                )
                :: getAttributes config
            )
            []
        , viewCurrency config
        , viewClearIcon
        ]


viewCurrency : Config msg -> Html msg
viewCurrency config =
    let
        initText =
            case config.size of
                Standard ->
                    Text.textHeavy

                Small ->
                    Text.textTinyHeavy
    in
    config.currency
        |> Html.viewMaybe
            (\currency ->
                initText
                    |> Text.view
                        [ css
                            [ position absolute
                            , right (rem 0.7)
                            , if config.size == Small then
                                top (pct 20)

                              else
                                top (pct 30)
                            ]
                        ]
                        [ currency
                            |> String.slice 0 3
                            |> String.toUpper
                            |> Html.text
                        ]
            )


getAttributes : Config msg -> List (Attribute msg)
getAttributes config =
    Maybe.values
        [ config.value |> value |> Just
        , config.onInput |> Maybe.map onInput
        , config.placeholder |> Maybe.map placeholder
        , config.maxLength |> Maybe.map maxlength
        , config.pattern |> Maybe.map pattern
        , config.onBlur |> Maybe.map onBlur
        , config.onEnterPress |> Maybe.map Events.onEnterPress
        , config.id |> Maybe.map Html.id
        ]
        ++ config.inputAttrs
