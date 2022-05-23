module Nordea.Components.TextInput exposing
    ( TextInput
    , init
    , view
    , withCurrency
    , withError
    , withMaxLength
    , withOnBlur
    , withOnEnterPress
    , withOnInput
    , withPattern
    , withPlaceholder
    , withSearchIcon
    , withSmallSize
    )

import Css exposing (Style, absolute, backgroundColor, border3, borderBox, borderRadius, boxSizing, color, disabled, displayFlex, focus, fontSize, height, left, none, num, opacity, outline, padding2, paddingLeft, pct, pointerEvents, position, relative, rem, right, solid, top, transform, translateY, width)
import Html.Styled as Html exposing (Attribute, Html, input, styled)
import Html.Styled.Attributes exposing (css, maxlength, pattern, placeholder, value)
import Html.Styled.Events exposing (keyCode, on, onBlur, onInput)
import Json.Decode as Json
import Maybe.Extra as Maybe
import Nordea.Components.Text as Text
import Nordea.Css as NordeaCss
import Nordea.Html exposing (styleIf)
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
    , onBlur : Maybe msg
    , onEnterPress : Maybe msg
    , size : Size
    , currency : Maybe String
    }


type Size
    = Small
    | Large


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
        , onBlur = Nothing
        , onEnterPress = Nothing
        , size = Large
        , currency = Nothing
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


withSmallSize : TextInput msg -> TextInput msg
withSmallSize (TextInput config) =
    TextInput { config | size = Small }


withCurrency : String -> TextInput msg -> TextInput msg
withCurrency currency (TextInput config) =
    TextInput { config | currency = Just currency }


onEnterPress : msg -> Attribute msg
onEnterPress msg =
    let
        isEnter code =
            if code == 13 then
                Json.succeed msg

            else
                Json.fail "not ENTER"
    in
    on "keydown" (Json.andThen isEnter keyCode)



-- VIEW


view : List (Attribute msg) -> TextInput msg -> Html msg
view attributes (TextInput config) =
    if config.hasSearchIcon then
        let
            iconColor =
                if config.showError then
                    Colors.redDark

                else
                    Colors.blueNordea
        in
        Html.div
            (css [ displayFlex, position relative ]
                :: attributes
            )
            [ Icons.search
                [ css
                    [ width (rem 1)
                    , height (rem 1)
                    , opacity (num 0.5)
                    , position absolute
                    , color iconColor
                    , left (rem 0.7)
                    , top (pct 50)
                    , transform (translateY (pct -50))
                    , pointerEvents none
                    ]
                ]
            , styled input
                (getStyles config)
                (getAttributes config)
                []
            , viewCurrency config
            ]

    else
        Html.div
            (css [ displayFlex, position relative ]
                :: attributes
            )
            [ styled input
                (getStyles config)
                (getAttributes config ++ attributes)
                []
            , viewCurrency config
            ]


viewCurrency : Config msg -> Html msg
viewCurrency config =
    let
        currency =
            config.currency |> Maybe.withDefault "" |> String.slice 0 3 |> String.toUpper
    in
    Html.div
        [ css
            [ position absolute
            , right (rem 0.7)
            , top (pct 30)
            ]
        ]
        [ Text.textHeavy
            |> Text.view [] [ Html.text currency ]
        ]


getAttributes : Config msg -> List (Attribute msg)
getAttributes config =
    Maybe.values
        [ Just config.value |> Maybe.map value
        , config.onInput |> Maybe.map onInput
        , config.placeholder |> Maybe.map placeholder
        , config.maxLength |> Maybe.map maxlength
        , config.pattern |> Maybe.map pattern
        , config.onBlur |> Maybe.map onBlur
        , config.onEnterPress |> Maybe.map onEnterPress
        ]



-- STYLES


getStyles : Config msg -> List Style
getStyles config =
    let
        borderColorStyle =
            if config.showError then
                Colors.redDark

            else
                Colors.grayMedium
    in
    [ fontSize (rem 1)
    , height
        (case config.size of
            Small ->
                NordeaCss.smallInputHeight

            Large ->
                NordeaCss.standardInputHeight
        )
    , padding2 (rem 0.75) (rem 0.75)
    , borderRadius (rem 0.25)
    , border3 (rem 0.0625) solid borderColorStyle |> Css.important
    , boxSizing borderBox
    , width (pct 100)
    , disabled [ backgroundColor Colors.grayWarm ]
    , paddingLeft (rem 2) |> styleIf config.hasSearchIcon
    , focus
        [ outline none
        , Themes.borderColor Themes.PrimaryColorLight Colors.blueNordea
        ]
    ]
