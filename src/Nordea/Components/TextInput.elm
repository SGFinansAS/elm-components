module Nordea.Components.TextInput exposing
    ( TextInput
    , init
    , view
    , withOnInput
    , withPlaceholder
    , withError
    )

import Css exposing (Style, backgroundColor, border3, borderBox, borderColor, borderRadius, boxSizing, disabled, em, focus, fontSize, height, none, outline, padding2, pct, rem, solid, width)
import Html.Styled exposing (Attribute, Html, input, styled)
import Html.Styled.Attributes exposing (placeholder, value)
import Html.Styled.Events exposing (onInput)
import Maybe.Extra as Maybe
import Nordea.Resources.Colors as Colors



-- CONFIG


type alias Config msg =
    { value : String
    , onInput : Maybe (String -> msg)
    , placeholder : Maybe String
    , error : Maybe Bool
    }


type TextInput msg
    = TextInput (Config msg)


init : String -> TextInput msg
init value =
    TextInput
        { value = value
        , onInput = Nothing
        , placeholder = Nothing
        , error = Nothing
        }


withOnInput : (String -> msg) -> TextInput msg -> TextInput msg
withOnInput onInput (TextInput config) =
    TextInput { config | onInput = Just onInput }


withPlaceholder : String -> TextInput msg -> TextInput msg
withPlaceholder placeholder (TextInput config) =
    TextInput { config | placeholder = Just placeholder }

withError : Bool -> TextInput msg -> TextInput msg
withError condition (TextInput config) =
    TextInput { config | error = Just condition }



-- VIEW


view : List (Attribute msg) -> TextInput msg -> Html msg
view attributes (TextInput config) =
    styled input
        (getStyles config)
        (getAttributes config ++ attributes)
        []


getAttributes : Config msg -> List (Attribute msg)
getAttributes config =
    Maybe.values
        [ Just config.value |> Maybe.map value
        , config.onInput |> Maybe.map onInput
        , config.placeholder |> Maybe.map placeholder
        ]

-- STYLES
getStyles : Config msg -> List Style
getStyles config =
    let
        borderColorNormal =
            Colors.grayMedium
        borderColorStyle =
            case config.error of
                Just error ->
                    if error then Colors.redDark
                    else borderColorNormal

                Nothing ->
                    borderColorNormal

    in
    [ fontSize (rem 1)
        , height (em 2.5)
        , padding2 (em 0.75) (em 0.75)
        , borderRadius (em 0.125)
        , border3 (em 0.0625) solid borderColorStyle
        , boxSizing borderBox
        , width (pct 100)
        , disabled
            [ backgroundColor Colors.grayWarm
            ]
        , focus
            [ outline none
            , borderColor Colors.blueNordea
            ]
        ]

