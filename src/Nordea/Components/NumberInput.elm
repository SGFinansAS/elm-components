module Nordea.Components.NumberInput exposing
    ( NumberInput
    , init
    , view
    , withDisabled
    , withError
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
        , em
        , focus
        , fontSize
        , height
        , important
        , none
        , outline
        , padding2
        , pct
        , property
        , rem
        , solid
        , unset
        , width
        )
import Html.Styled exposing (Attribute, Html, input, styled)
import Html.Styled.Attributes as Attributes exposing (placeholder, step, type_, value)
import Html.Styled.Events exposing (onInput)
import Maybe.Extra as Maybe
import Nordea.Resources.Colors as Colors



-- CONFIG


type alias Config msg =
    { value : String
    , min : Maybe Float
    , max : Maybe Float
    , step : Maybe Float
    , placeholder : Maybe String
    , onInput : Maybe (String -> msg)
    , showError : Bool
    , disabled : Bool
    }


type NumberInput msg
    = NumberInput (Config msg)


init : String -> NumberInput msg
init value =
    NumberInput
        { value = value
        , min = Nothing
        , max = Nothing
        , step = Nothing
        , placeholder = Nothing
        , onInput = Nothing
        , showError = False
        , disabled = False
        }


withMin : Float -> NumberInput msg -> NumberInput msg
withMin min (NumberInput config) =
    NumberInput { config | min = Just min }


withMax : Float -> NumberInput msg -> NumberInput msg
withMax max (NumberInput config) =
    NumberInput { config | max = Just max }


withStep : Float -> NumberInput msg -> NumberInput msg
withStep step (NumberInput config) =
    NumberInput { config | step = Just step }


withPlaceholder : String -> NumberInput msg -> NumberInput msg
withPlaceholder placeholder (NumberInput config) =
    NumberInput { config | placeholder = Just placeholder }


withOnInput : (String -> msg) -> NumberInput msg -> NumberInput msg
withOnInput onInput (NumberInput config) =
    NumberInput { config | onInput = Just onInput }


withError : Bool -> NumberInput msg -> NumberInput msg
withError condition (NumberInput config) =
    NumberInput { config | showError = condition }


withDisabled : Bool -> NumberInput msg -> NumberInput msg
withDisabled condition (NumberInput config) =
    NumberInput { config | disabled = condition }



-- VIEW


view : List (Attribute msg) -> NumberInput msg -> Html msg
view attributes (NumberInput config) =
    styled input
        (getStyles config)
        (getAttributes config ++ attributes)
        []


getAttributes : Config msg -> List (Attribute msg)
getAttributes config =
    Maybe.values
        [ Just "number" |> Maybe.map type_
        , Just config.value |> Maybe.map value
        , config.min |> Maybe.map String.fromFloat |> Maybe.map Attributes.min
        , config.max |> Maybe.map String.fromFloat |> Maybe.map Attributes.max
        , config.step |> Maybe.map String.fromFloat |> Maybe.map step
        , config.placeholder |> Maybe.map placeholder
        , config.onInput |> Maybe.map onInput
        , Just config.disabled |> Maybe.map Attributes.disabled
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
    -- Need to override Main.css styling
    List.map (\style -> important <| style)
        [ fontSize (rem 0.8)
        , height (em 2)
        , padding2 (em 0.65) (em 0.65)
        , borderRadius (em 0.125)
        , border3 (em 0.0625) solid borderColorStyle
        , boxSizing borderBox
        , width (pct 70)
        , Css.disabled
            [ backgroundColor Colors.grayWarm
            ]
        , focus
            [ outline none
            , borderColor Colors.blueNordea
            ]
        ]
