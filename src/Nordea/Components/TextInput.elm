module Nordea.Components.TextInput exposing
    ( TextInput
    , init
    , view
    , withClearInput
    , withCurrency
    , withError
    , withMaxLength
    , withOnBlur
    , withOnEnterPress
    , withOnInput
    , withPattern
    , withPlaceholder
    , withSearchIcon
    )

import Css
    exposing
        ( Style
        , absolute
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
        , paddingLeft
        , paddingRight
        , pct
        , pointer
        , pointerEvents
        , position
        , property
        , pseudoElement
        , relative
        , rem
        , right
        , solid
        , top
        , transform
        , translateY
        , width
        )
import Css.Global exposing (withAttribute)
import Html.Styled as Html exposing (Attribute, Html, input, styled)
import Html.Styled.Attributes as Html exposing (css, maxlength, pattern, placeholder, value)
import Html.Styled.Events exposing (keyCode, on, onBlur, onInput)
import Json.Decode as Json
import Maybe.Extra as Maybe
import Nordea.Components.Text as Text
import Nordea.Html as Html exposing (styleIf)
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
    }


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
    let
        viewSearchIcon =
            if config.hasSearchIcon then
                Icons.search
                    [ css
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

            else
                Html.nothing
    in
    Html.div
        (css [ displayFlex, position relative ] :: attributes)
        [ viewSearchIcon
        , styled input
            (getStyles config)
            (getAttributes config ++ attributes)
            []
        , viewCurrency config
        ]


viewCurrency : Config msg -> Html msg
viewCurrency config =
    config.currency
        |> Html.viewMaybe
            (\currency ->
                Text.textHeavy
                    |> Text.view
                        [ css
                            [ position absolute
                            , right (rem 0.7)
                            , top (pct 30)
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
    let
        clearIconAttr =
            if config.hasClearIcon then
                [ Html.attribute "type" "search" ]

            else
                []
    in
    Maybe.values
        [ config.value |> value |> Just
        , config.onInput |> Maybe.map onInput
        , config.placeholder |> Maybe.map placeholder
        , config.maxLength |> Maybe.map maxlength
        , config.pattern |> Maybe.map pattern
        , config.onBlur |> Maybe.map onBlur
        , config.onEnterPress |> Maybe.map onEnterPress
        ]
        ++ clearIconAttr



-- STYLES


getStyles : Config msg -> List Style
getStyles config =
    let
        borderColorStyle =
            if config.showError then
                Colors.darkRed

            else
                Colors.mediumGray

        clearIcon =
            if config.hasClearIcon then
                [ withAttribute "type=\"search\""
                    [ pseudoElement
                        "-webkit-search-cancel-button"
                        [ property "-webkit-appearance" "none"
                        , height (rem 1.75)
                        , width (rem 1.75)
                        , cursor pointer
                        , position absolute
                        , right (rem 0)
                        , property "background-image" "url('data:image/svg+xml,<svg width=\"28\" height=\"28\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M21 12C21 7.02944 16.9706 3 12 3C7.02944 3 3 7.02944 3 12C3 16.9706 7.02944 21 12 21C16.9706 21 21 16.9706 21 12ZM13.005 12L15.51 14.505C15.8008 14.7975 15.8008 15.27 15.51 15.5625C15.3692 15.7045 15.1775 15.7843 14.9775 15.7843C14.7775 15.7843 14.5858 15.7045 14.445 15.5625L11.9475 13.0575L9.4425 15.5625C9.3028 15.7011 9.11425 15.7792 8.9175 15.78C8.71815 15.7812 8.52654 15.7029 8.385 15.5625C8.09421 15.27 8.09421 14.7975 8.385 14.505L10.8825 12L8.385 9.495C8.13017 9.19743 8.1473 8.75385 8.42433 8.47683C8.70135 8.1998 9.14493 8.18267 9.4425 8.4375L11.9475 10.9425L14.445 8.4375C14.5858 8.29552 14.7775 8.21565 14.9775 8.21565C15.1775 8.21565 15.3692 8.29552 15.51 8.4375C15.8008 8.73003 15.8008 9.20247 15.51 9.495L13.005 12Z\" fill=\"%23C9C7C7\"></path></svg>')"
                        , property "background-repeat" "no-repeat"
                        ]
                    ]
                ]

            else
                []
    in
    [ fontSize (rem 1)
    , height (rem 2.5)
    , padding2 (rem 0) (rem 0.75)
    , borderRadius (rem 0.25)
    , border3 (rem 0.0625) solid borderColorStyle
    , boxSizing borderBox
    , width (pct 100)
    , disabled [ backgroundColor Colors.grayWarm ]
    , paddingLeft (rem 2) |> styleIf config.hasSearchIcon
    , paddingRight (rem 3)
        |> styleIf
            ((config.value |> String.isEmpty |> not)
                && config.hasClearIcon
            )
    , focus
        [ outline none
        , Themes.borderColor Colors.nordeaBlue
        ]
    ]
        ++ clearIcon
