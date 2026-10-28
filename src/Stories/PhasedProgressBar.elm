module Stories.PhasedProgressBar exposing (stories)

import Html.Styled.Attributes exposing (disabled)
import Nordea.Components.PhasedProgressBar as PhasedProgressBar
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI a b {}
stories =
    styledStoriesOf
        "PhasedProgressBar"
        [ ( "Default"
          , \_ ->
                PhasedProgressBar.view
                    { phaseOne = { amount = 10000, label = "Limit used" }
                    , phaseTwo = { amount = 3000, label = "Under establishment" }
                    , phaseThree = { amount = 4000, label = "Limit remaining" }
                    , formatter = String.fromFloat
                    }
                    []
          , {}
          )
        , ( "Disabled"
          , \_ ->
                PhasedProgressBar.view
                    { phaseOne = { amount = 10000, label = "Limit used" }
                    , phaseTwo = { amount = 3000, label = "Under establishment" }
                    , phaseThree = { amount = 4000, label = "Limit remaining" }
                    , formatter = String.fromFloat
                    }
                    [ disabled True ]
          , {}
          )
        ]
