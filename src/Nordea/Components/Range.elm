module Nordea.Components.Range exposing
    ( Config
    , Range
    , init
    , view
    , withShowInterval
    )

-- CONFIG

import Css exposing (Style, backgroundColor, borderRadius, cursor, displayFlex, flexDirection, height, justifyContent, listStyle, margin2, marginTop, none, padding, pct, pointer, property, pseudoElement, rem, row, spaceBetween, transparent, width)
import Html.Styled as Html exposing (Attribute, Html, div, input, li, ol)
import Html.Styled.Attributes as Attrs exposing (css, name, step, type_, value)
import Html.Styled.Events as Events exposing (targetValue)
import Json.Decode as Decode
import Nordea.Html exposing (showIf)
import Nordea.Resources.Colors as Colors
import Nordea.Themes as Themes


type alias Config msg =
    { value : Float
    , min : Float
    , max : Float
    , step : Maybe Float
    , onInput : Float -> msg
    , showInterval : Bool
    }


type Range msg
    = Range (Config msg)


init : Float -> Float -> Float -> (Float -> msg) -> Range msg
init value min max onInput =
    Range
        { value = value
        , min = min
        , max = max
        , step = Nothing
        , onInput = onInput
        , showInterval = False
        }


withShowInterval : Bool -> Range msg -> Range msg
withShowInterval value (Range config) =
    Range { config | showInterval = value }



-- VIEW


view : List (Attribute msg) -> Range msg -> Html msg
view attributes (Range config) =
    let
        decoder =
            targetValue
                |> Decode.andThen
                    (\val ->
                        case val |> String.toFloat of
                            Nothing ->
                                Decode.fail "1"

                            Just tag ->
                                Decode.succeed tag
                    )
                |> Decode.map config.onInput
    in
    div attributes
        [ input
            [ name "rangeInput"
            , type_ "range"
            , value (config.value |> String.fromFloat)
            , Attrs.min (config.min |> String.fromFloat)
            , Attrs.max (config.max |> String.fromFloat)
            , step (config.step |> Maybe.map String.fromFloat |> Maybe.withDefault "1")
            , Events.on "input" decoder
            , css [ sliderStyle (Range config) ]
            ]
            []
        , ol
            [ css
                [ displayFlex
                , flexDirection row
                , justifyContent spaceBetween
                , margin2 (rem 1) (rem 0.25)
                , listStyle none
                , padding (rem 0)
                ]
            ]
            (List.range (config.min |> ceiling) (config.max |> ceiling)
                |> List.map (\number -> li [] [ Html.text (String.fromInt number) ])
            )
            |> showIf config.showInterval
        ]


sliderStyle : Range msg -> Style
sliderStyle (Range config) =
    Css.batch
        [ width (pct 100)
        , property "-webkit-appearance" "none"
        , cursor pointer

        -- Webkit
        , pseudoElement "-webkit-slider-runnable-track"
            [ width (pct 100)
            , height (rem 0.25)
            , property "background-color" "transparent"
            ]
        , pseudoElement "-webkit-slider-thumb"
            [ property "-webkit-appearance" "none"
            , width (rem 1.5)
            , height (rem 1.5)
            , borderRadius (pct 100)
            , Themes.backgroundColor Colors.deepBlue
            , marginTop (rem -0.625)
            ]

        -- Mozilla
        , pseudoElement "-moz-range-track"
            [ width (pct 100)
            , height (rem 0.25)
            , backgroundColor transparent
            ]
        , pseudoElement "-moz-range-thumb"
            [ width (rem 1.5)
            , height (rem 1.5)
            , borderRadius (pct 100)
            , Themes.backgroundColor Colors.deepBlue
            , marginTop (rem -0.625)
            ]
        , adjustSlider (Range config)
        ]


adjustSlider : Range msg -> Style
adjustSlider (Range config) =
    let
        visibleWidth =
            (((config.value - config.min) * 100) / (config.max - config.min)) |> String.fromFloat

        cloudBlue =
            Themes.colorVariable Colors.cloudBlue

        nordeaBlue =
            Themes.colorVariable Colors.nordeaBlue

        gradientValue =
            "linear-gradient(to right," ++ nordeaBlue ++ " 0% " ++ visibleWidth ++ "%, " ++ cloudBlue ++ " " ++ visibleWidth ++ "%" ++ " 100% )"
    in
    property "background" gradientValue
