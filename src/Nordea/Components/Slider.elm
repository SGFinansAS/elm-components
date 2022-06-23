module Nordea.Components.Slider exposing
    ( Slider
    , init
    , view
    , withError
    , withShowInterval
    , withShowNumberInput
    , withStep
    )

import Css
    exposing
        ( Style
        , alignItems
        , center
        , color
        , column
        , displayFlex
        , flex
        , flexDirection
        , int
        , marginBottom
        , rem
        , row
        )
import Html.Styled as Html exposing (Attribute, Html, div, label)
import Html.Styled.Attributes exposing (css, for, name)
import Nordea.Components.NumberInput as NumberInput
import Nordea.Components.Range as Range
import Nordea.Components.Text as NordeaText
import Nordea.Html exposing (showIf)
import Nordea.Resources.Colors as Colors



-- CONFIG


type alias Config msg =
    { value : Float
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


init : Float -> Float -> Float -> String -> String -> (String -> msg) -> Slider msg
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
    div ([] ++ attributes)
        [ div [ css [ displayFlex, flexDirection row, marginBottom (rem 1), alignItems center ] ]
            [ label [ for "rangeInput", css [ displayFlex, flexDirection column, flex (int 3) ] ]
                [ NordeaText.textSmallLight
                    |> NordeaText.view [] [ Html.text config.labelString ]
                , NordeaText.textTinyLight
                    |> NordeaText.view [ css [ color Colors.grayNordea ] ] [ Html.text config.description ]
                ]
            , showIf config.showNumberInput
                (NumberInput.init (config.value |> String.fromFloat)
                    |> NumberInput.withMin config.min
                    |> NumberInput.withMax config.max
                    |> NumberInput.withStep (config.step |> Maybe.withDefault 1)
                    |> NumberInput.withOnInput config.onInput
                    |> NumberInput.withError (config.value > config.max || config.value < config.min)
                    |> NumberInput.view [ name "rangeInput", css [ flex (int 1) ] ]
                )
            ]
        , Range.init config.value config.min config.max config.onInput
            |> Range.withShowInterval config.showInterval
            |> Range.view []
        ]
