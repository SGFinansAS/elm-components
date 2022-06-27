module Nordea.Components.Slider exposing
    ( Slider
    , init
    , view
    , withError
    , withShowInterval
    , withShowNumberInput
    , withStep
    )

import Css exposing (border, color, column, displayFlex, flex, flexDirection, int, margin, marginBottom, padding, rem)
import Html.Styled as Html
    exposing
        ( Attribute
        , Html
        , div
        , fieldset
        , label
        , legend
        )
import Html.Styled.Attributes exposing (css)
import Nordea.Components.NumberInput as NumberInput
import Nordea.Components.Range as Range
import Nordea.Components.Text as NordeaText
import Nordea.Html exposing (showIf)
import Nordea.Resources.Colors as Colors



-- CONFIG


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
    , showInterval : Bool
    , showNumberInput : Bool
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
        , showInterval = False
        , showNumberInput = False
        }


withStep : Float -> Slider msg -> Slider msg
withStep step (Slider config) =
    Slider { config | step = Just step }


withError : Bool -> Slider msg -> Slider msg
withError condition (Slider config) =
    Slider { config | showError = condition }


withShowInterval : Bool -> Slider msg -> Slider msg
withShowInterval value (Slider config) =
    Slider { config | showInterval = value }


withShowNumberInput : Bool -> Slider msg -> Slider msg
withShowNumberInput value (Slider config) =
    Slider { config | showNumberInput = value }



-- VIEW


view : List (Attribute msg) -> Slider msg -> Html msg
view attributes (Slider config) =
    fieldset
        ([ css
            [ displayFlex
            , flexDirection column
            , border (rem 0)
            , padding (rem 0)
            , margin (rem 0)
            ]
         ]
            ++ attributes
        )
        [ div [ css [ displayFlex, marginBottom (rem 0.5) ] ]
            [ legend [ css [ flex (int 3) ] ]
                [ NordeaText.textSmallLight
                    |> NordeaText.view [] [ Html.text config.labelString ]
                , NordeaText.textTinyLight
                    |> NordeaText.view [ css [ color Colors.grayNordea ] ] [ Html.text config.description ]
                ]
            , label [ css [ flex (int 1) ] ]
                [ showIf config.showNumberInput
                    (NumberInput.init config.value
                        |> NumberInput.withMin config.min
                        |> NumberInput.withMax config.max
                        |> NumberInput.withStep (config.step |> Maybe.withDefault 1)
                        |> NumberInput.withOnInput config.onInput
                        |> NumberInput.withError config.showError
                        |> NumberInput.view []
                    )
                ]
            ]
        , label [ css [ flex (int 1) ] ]
            [ Range.init (config.value |> String.toFloat |> Maybe.withDefault 0) config.min config.max (String.fromFloat >> config.onInput)
                |> Range.withShowInterval config.showInterval
                |> Range.view []
            ]
        ]
