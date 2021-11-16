module Stories.CoachMark exposing (stories)

import Config exposing (Config, Msg(..))
import Nordea.Components.CoachMark as CoachMark
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI Config Msg {}
stories =
    styledStoriesOf
        "CoachMark"
        [ ( "Default"
          , \_ ->
                CoachMark.init
                    |> CoachMark.withTitle "New"
                    |> CoachMark.withBodyText "Place tooltip message here thats is over 2 lines max"
                    |> CoachMark.withSteps 1 3
                    |> CoachMark.withArrow CoachMark.Bottom
                    |> CoachMark.view []
          , {}
          )
        ]
