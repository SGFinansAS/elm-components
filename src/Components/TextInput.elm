module Components.TextInput exposing
    ( TextInput
    , init
    , view
    , withOnInput
    , withPlaceholder
    )

import Css
    exposing
        ( Style
        , backgroundColor
        , border3
        , borderBox
        , borderColor
        , borderRadius
        , boxSizing
        , disabled
        , em
        , focus
        , fontSize
        , height
        , none
        , outline
        , padding2
        , rem
        , solid
        )
import Html.Styled exposing (Attribute, Html, input, styled)
import Html.Styled.Attributes exposing (placeholder, value)
import Html.Styled.Events exposing (onInput)
import Resources.Colors as Colors
import Util.List as List



-- CONFIG


type alias Config msg =
    { value : String
    , onInput : Maybe (String -> msg)
    , placeholder : Maybe String
    }


type TextInput msg
    = TextInput (Config msg)


init : String -> TextInput msg
init value =
    TextInput
        { value = value
        , onInput = Nothing
        , placeholder = Nothing
        }


withOnInput : (String -> msg) -> TextInput msg -> TextInput msg
withOnInput onInput (TextInput config) =
    TextInput { config | onInput = Just onInput }


withPlaceholder : String -> TextInput msg -> TextInput msg
withPlaceholder placeholder (TextInput config) =
    TextInput { config | placeholder = Just placeholder }



-- VIEW


view : List (Attribute msg) -> TextInput msg -> Html msg
view attributes (TextInput config) =
    styled input
        styles
        (getAttributes config ++ attributes)
        []


getAttributes : Config msg -> List (Attribute msg)
getAttributes config =
    List.filterMaybe
        [ Just config.value |> Maybe.map value
        , config.onInput |> Maybe.map onInput
        , config.placeholder |> Maybe.map placeholder
        ]



-- STYLES


styles : List Style
styles =
    [ fontSize (rem 1)
    , height (em 2.5)
    , padding2 (em 0.75) (em 0.75)
    , borderRadius (em 0.125)
    , border3 (em 0.0625) solid Colors.grayMedium
    , boxSizing borderBox
    , disabled
        [ backgroundColor Colors.grayWarm
        ]
    , focus
        [ outline none
        , borderColor Colors.blueNordea
        ]
    ]
