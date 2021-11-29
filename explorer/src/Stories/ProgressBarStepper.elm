module Stories.ProgressBarStepper exposing (stories)

import Config exposing (Msg(..))
import Css exposing (column, displayFlex, flexDirection, marginBottom, rem)
import Css.Global exposing (children, everything)
import Html.Styled as Html exposing (text)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events exposing (onClick)
import Nordea.Components.ProgressBarStepper as ProgressBarStepper
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI a b {}
stories =
    styledStoriesOf
        "ProgressBarStepper"
        [ ( "Default"
          , \_ ->
                ProgressBarStepper.init { steps = [ "Step 1", "Step 2", "Step 3", "Step 4", "Step 5" ], currentStep = 2, nextLabel = .no }
                    |> ProgressBarStepper.view []
          , {}
          )
        ]
