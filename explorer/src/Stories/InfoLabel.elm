module Stories.InfoLabel exposing (stories)

import Config exposing (Config, Msg)
import Html.Styled as Html
import Nordea.Components.InfoLabel as InfoLabel
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI Config Msg {}
stories =
    styledStoriesOf
        "InfoLabel"
        [ ( "Regular infolabel"
          , \_ ->
                InfoLabel.view [] [ Html.text "This is important info." ]
          , {}
          )
        , ( "InfoLabel that is a warning"
          , \_ ->
                InfoLabel.warning [] [ Html.text "This is an important warning." ]
          , {}
          )
        ]
