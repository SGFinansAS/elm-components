module Stories.Status exposing (stories)

import Nordea.Components.Status as Status
import Nordea.Resources.Colors as Color
import UIExplorer exposing (UI)
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
          , \_ -> Status.partiallyFilled "Control prerequisites" Color.yellowStatus 60.0 []
          , {}
          )
        ]
