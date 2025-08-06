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
import Html.Styled.Attributes exposing (attribute, css)
import List.Extra as List
import Nordea.Components.ProgressBar as ProgressBar
import Nordea.Components.Text as Text
import Nordea.Html exposing (viewMaybe)
import Nordea.Resources.Colors as Colors
import Nordea.Resources.I18N exposing (Translation)


type alias ViewConfig =
    { steps : List String
    , currentStep : Int
    , translate : Translation -> String
    }


init : { r | steps : b, currentStep : c, translate : d } -> { steps : b, currentStep : c, translate : d }
init { steps, currentStep, translate } =
    { steps = steps
    , currentStep = currentStep
    , translate = translate
    }


view : List (Attribute msg) -> ViewConfig -> Html msg
view attrs { steps, currentStep, translate } =
    let
        centerLabel =
            Text.textLight
                |> Text.view [] [ Html.text (String.fromInt currentStep ++ "/" ++ String.fromInt (List.length steps)) ]
    in
    Html.div
        (css [ displayFlex, alignItems center ]
            :: attrs
        )
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
                , attribute "aria-label"
                    (translate strings.step
                        ++ " "
                        ++ String.fromInt currentStep
                        ++ " "
                        ++ translate strings.of_
                        ++ " "
                        ++ String.fromInt (List.length steps)
                    )
                ]
        , Html.div
            [ css [ displayFlex, flexDirection column ] ]
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
                                [ Html.text (translate strings.next ++ step) ]
                    )
            ]
        ]


strings =
    { next =
        { no = "Neste: "
        , se = "Nästa: "
        , dk = "Næste: "
        , en = "Next: "
        }
    , step =
        { no = "Steg"
        , se = "Steg"
        , dk = "Trin"
        , en = "Step"
        }
    , of_ =
        { no = "av"
        , se = "av"
        , dk = "af"
        , en = "of"
        }
    }
