module Stories.FeatureBox exposing (stories)

import Html.Styled as Html
import Config exposing (Msg(..))
import Nordea.Components.FeatureBox as FeatureBox
import Nordea.Components.Button as Button
import Nordea.Resources.Icons as Icons
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)

stories : UI a Msg {}
stories = 
    styledStoriesOf
        "FeatureBox"
        [ ( "FeatureBox"
          , \_ ->
                FeatureBox.init True NoOp  "New feature" "Place tolltip message here thats is over 2 lines max"
                    |> FeatureBox.withIcon Icons.confetti2
                    |> FeatureBox.withButton 
                        (Button.primary
                            |> Button.view [] [ Html.text "Click me" ]
                        )
                    |> FeatureBox.view 
                    
          , {}
          )

          
        ]
        