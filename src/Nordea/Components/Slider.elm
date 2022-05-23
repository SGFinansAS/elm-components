module Nordea.Components.Slider exposing (..)

-- CONFIG

import Css exposing (Style, alignItems, backgroundColor, borderRadius, center, color, column, cursor, displayFlex, flex, flexDirection, flexGrow, height, hex, int, linearGradient, linearGradient2, margin2, marginBottom, marginTop, pct, pointer, property, pseudoElement, px, rem, row, toRight, transparent, width)
import Html.Styled as Html exposing (Attribute, Html, div, input, label)
import Html.Styled.Attributes exposing (css, for, name, type_)
import Html.Styled.Events exposing (onInput)
import Nordea.Components.NumberInput as NumberInput
import Nordea.Components.Text as NordeaText
import Nordea.Resources.Colors as Colors


type alias Config msg =
    { value : String
    , min : Float
    , max : Float
    , step : Maybe Float
    , onInput : String -> msg
    , showError : Bool
    , isDisabled : Bool
    , labelString : String
    , description : String
    }


type Slider msg
    = Slider (Config msg)


init : String -> Float -> Float -> String -> String -> (String -> msg) -> Slider msg
init value min max labelString description onInput =
    Slider
        { value = value
        , min = min
        , max = max
        , step = Nothing
        , onInput = onInput
        , showError = False
        , isDisabled = False
        , labelString = labelString
        , description = description
        }



-- VIEW


view : List (Attribute msg) -> Slider msg -> Html msg
view attributes (Slider config) =
    div ([] ++ attributes)
        [ div [ css [ displayFlex, flexDirection row, marginBottom (rem 1), alignItems center ] ]
            [ label [ for "rangeInput", css [ displayFlex, flexDirection column, flex (int 3) ] ]
                [ NordeaText.textSmallLight
                    |> NordeaText.view [] [ Html.text config.labelString ]
                , NordeaText.textTinyLight
                    |> NordeaText.view [ css [ color Colors.grayNordea ] ] [ Html.text config.description ]
                ]
            , NumberInput.init config.value
                |> NumberInput.withMin config.min
                |> NumberInput.withMax config.max
                |> NumberInput.withStep (config.step |> Maybe.withDefault 1)
                |> NumberInput.withOnInput config.onInput
                |> NumberInput.withError ((config.value |> String.toFloat |> Maybe.withDefault 1) > config.max || (config.value |> String.toFloat |> Maybe.withDefault 1) < config.min)
                |> NumberInput.view [ name "rangeInput", css [ flex (int 1) ] ]
            ]
        , input
            [ name "rangeInput"
            , type_ "range"
            , Html.Styled.Attributes.value config.value
            , Html.Styled.Attributes.min (config.min |> String.fromFloat)
            , Html.Styled.Attributes.max (config.max |> String.fromFloat)
            , Html.Styled.Attributes.step (config.step |> Maybe.map String.fromFloat |> Maybe.withDefault "1")
            , config.onInput |> onInput
            , css [ sliderStyle (Slider config) ]
            ]
            []
        ]


sliderStyle : Slider msg -> Style
sliderStyle (Slider config) =
    Css.batch
        [ width (pct 100)
        , property "-webkit-appearance" "none"
        , cursor pointer
        , margin2 (px 8) (px 0)

        -- Webkit
        , pseudoElement "-webkit-slider-runnable-track"
            [ width (pct 100)
            , height (px 4)
            , property "background-color" "transparent"
            ]
        , pseudoElement "-webkit-slider-thumb"
            [ property "-webkit-appearance" "none"
            , width (px 20)
            , height (px 20)
            , borderRadius (pct 100)
            , backgroundColor (hex "#00005E")
            , marginTop (px -8.5)
            ]

        -- Mozilla
        , pseudoElement "-moz-range-track"
            [ width (pct 100)
            , height (px 4)
            , backgroundColor transparent
            ]
        , pseudoElement "-moz-range-thumb"
            [ width (px 20)
            , height (px 20)
            , borderRadius (pct 100)
            , backgroundColor (hex "#00005E")
            , marginTop (px -8.5)
            ]
        , adjustSlider (Slider config)
        ]


adjustSlider : Slider msg -> Style
adjustSlider (Slider config) =
    let
        visibleWidth =
            ((((config.value |> String.toFloat |> Maybe.withDefault 0) - config.min) * 100) / (config.max - config.min)) |> String.fromFloat

        cloudBlue =
            "#DCEDFF"

        nordeaBlue =
            "#0000A0"

        gradientValue =
            "linear-gradient(to right," ++ nordeaBlue ++ " 0% " ++ visibleWidth ++ "%, " ++ cloudBlue ++ " " ++ visibleWidth ++ "%" ++ " 100% )"
    in
    Css.batch
        [ property "background" gradientValue
        ]
