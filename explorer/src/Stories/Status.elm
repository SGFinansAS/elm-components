module Stories.Status exposing (..)

import Nordea.Components.Status as Status
import Nordea.Resources.Colors as Color
import UIExplorer exposing (Config, UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI a b {}
stories =
    styledStoriesOf
        "Status"
        [ ( "Green"
          , \_ -> Status.green "Status" []
          , {}
          )
        , ( "Red"
          , \_ -> Status.red "Status" []
          , {}
          )
        , ( "Gray"
          , \_ -> Status.gray "Status" []
          , {}
          )
        , ( "Yellow"
          , \_ -> Status.yellow "Status" []
          , {}
          )
        , ( "Blue"
          , \_ -> Status.blue "Status" []
          , {}
          )
        , ( "Mixed"
          , \_ -> Status.twoColors "Control prerequisites" Color.yellowStatus (Color.yellow |> Color.withAlpha 0.4) 60.0 []
          , {}
          )
        ]
