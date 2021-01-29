module Nordea.Components.NumberInput exposing
    ( TextInput
    , init
    , view
    , withMax
    , withMin
    , withOnInput
    , withPlaceholder
    , withStep
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
        , minWidth
        , none
        , outline
        , padding2
        , rem
        , solid
        )
import Html.Styled exposing (Attribute, Html, input, styled)
import Html.Styled.Attributes as Attributes exposing (placeholder, step, type_, value)
import Html.Styled.Events exposing (onInput)
import Nordea.Resources.Colors as Colors
import Nordea.Util.List as List



-- CONFIG


type alias Config msg =
    { value : String
    , min : Maybe Float
    , max : Maybe Float
    , step : Maybe Float
    , placeholder : Maybe String
    , onInput : Maybe (String -> msg)
    }


type TextInput msg
    = NumberInput (Config msg)


init : String -> TextInput msg
init value =
    NumberInput
        { value = value
        , min = Nothing
        , max = Nothing
        , step = Nothing
        , placeholder = Nothing
        , onInput = Nothing
        }


withMin : Float -> TextInput msg -> TextInput msg
withMin min (NumberInput config) =
    NumberInput { config | min = Just min }


withMax : Float -> TextInput msg -> TextInput msg
withMax max (NumberInput config) =
    NumberInput { config | max = Just max }


withStep : Float -> TextInput msg -> TextInput msg
withStep step (NumberInput config) =
    NumberInput { config | step = Just step }


withPlaceholder : String -> TextInput msg -> TextInput msg
withPlaceholder placeholder (NumberInput config) =
    NumberInput { config | placeholder = Just placeholder }


withOnInput : (String -> msg) -> TextInput msg -> TextInput msg
withOnInput onInput (NumberInput config) =
    NumberInput { config | onInput = Just onInput }



-- VIEW


view : List (Attribute msg) -> TextInput msg -> Html msg
view attributes (NumberInput config) =
    styled input
        styles
        (getAttributes config ++ attributes)
        []


getAttributes : Config msg -> List (Attribute msg)
getAttributes config =
    List.filterMaybe
        [ Just "number" |> Maybe.map type_
        , Just config.value |> Maybe.map value
        , config.min |> Maybe.map String.fromFloat |> Maybe.map Attributes.min
        , config.max |> Maybe.map String.fromFloat |> Maybe.map Attributes.max
        , config.step |> Maybe.map String.fromFloat |> Maybe.map step
        , config.placeholder |> Maybe.map placeholder
        , config.onInput |> Maybe.map onInput
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
    , minWidth (em 18.75)
    , disabled
        [ backgroundColor Colors.grayWarm
        ]
    , focus
        [ outline none
        , borderColor Colors.blueNordea
        ]
    ]
