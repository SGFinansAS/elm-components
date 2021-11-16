module Stories.FeatureBox exposing (stories)

import Config exposing (Msg(..))
import Nordea.Components.FeatureBox as FeatureBox
import Nordea.Resources.Icons as Icons
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)

stories : UI a Msg {}
stories = 
    styledStoriesOf
        "FeatureBox"
        [ ( "FeatureBox"
          , \_ ->
                FeatureBox.init True NoOp  "New feature" "Description for new feature"
                    |> FeatureBox.view 
                    
          , {}
          )

          
        ]
        