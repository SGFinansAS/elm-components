module Nordea.Components.ProgressBarStepper exposing (init, view)

import Css
    exposing
        ( alignItems
        , center
        , color
        , column
        , displayFlex
        , flexDirection
        , height
        , marginRight
        , rem
        , width
        )
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes exposing (css)
import List.Extra as List
import Nordea.Components.ProgressBar as ProgressBar
import Nordea.Components.Text as Text
import Nordea.Html exposing (viewMaybe)
import Nordea.Resources.Colors as Colors
import Nordea.Resources.I18N exposing (Translation)


type alias ViewConfig =
    { steps : List String
    , currentStep : Int
    , nextLabel : Translation -> String
    }


init : { r | steps : b, currentStep : c, nextLabel : d } -> { steps : b, currentStep : c, nextLabel : d }
init { steps, currentStep, nextLabel } =
    { steps = steps
    , currentStep = currentStep
    , nextLabel = nextLabel
    }


view : List (Attribute msg) -> ViewConfig -> Html msg
view attrs { steps, currentStep, nextLabel } =
    let
        centerLabel =
            Text.textLight
                |> Text.view [] [ Html.text (String.fromInt currentStep ++ "/" ++ String.fromInt (List.length steps)) ]
    in
    Html.div (css [ displayFlex, alignItems center ] :: attrs)
        [ ProgressBar.init
            { progress = (toFloat currentStep / toFloat (List.length steps)) * 100
            , isCompleted = False
            }
            |> ProgressBar.withStrokeWidth 12
            |> ProgressBar.withUnfilledStrokeColor Colors.cloudBlue
            |> ProgressBar.withCustomCenterLabel centerLabel
            |> ProgressBar.view
                [ css
                    [ marginRight (rem 1)
                    , width (rem 3.5) |> Css.important
                    , height (rem 3.5) |> Css.important
                    ]
                ]
        , Html.div [ css [ displayFlex, flexDirection column ] ]
            [ steps
                |> List.getAt (currentStep - 1)
                |> viewMaybe (\step -> Text.textLight |> Text.view [] [ Html.text step ])
            , steps
                |> List.getAt currentStep
                |> viewMaybe
                    (\step ->
                        Text.textTiny
                            |> Text.view
                                [ css [ color Colors.darkGray ] ]
                                [ Html.text (nextLabel strings.next ++ step) ]
                    )
            ]
        ]


strings : { next : Translation }
strings =
    { next =
        { no = "Neste: "
        , se = "Nästa: "
        , dk = "Næste: "
        , en = "Next: "
        }
    }
