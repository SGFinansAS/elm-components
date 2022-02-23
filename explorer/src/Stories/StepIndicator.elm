module Stories.StepIndicator exposing (stories)

import Nordea.Components.StepIndicator as StepIndicator
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI a b {}
stories =
    styledStoriesOf
        "StepIndicator"
        [ ( "5 steps, current 1"
          , \_ ->
                StepIndicator.init [ "Step name", "Step name", "Step name", "Step name", "Step name" ] 1
                    |> StepIndicator.view
          , {}
          )
        , ( "5 steps, current 3"
          , \_ ->
                StepIndicator.init [ "Step longlongname", "Step name", "Step longlonglong name", "Step name", "Step name" ] 3
                    |> StepIndicator.view
          , {}
          )
        , ( "5 steps, current 5"
          , \_ ->
                StepIndicator.init [ "Step name", "Step name", "Step name", "Step name", "Step name" ] 5
                    |> StepIndicator.view
          , {}
          )
        ]
