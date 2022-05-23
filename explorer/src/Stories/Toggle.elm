module Stories.Toggle exposing (stories)

import Config exposing (Config, Msg(..))
import Html.Styled exposing (div)
import Html.Styled.Attributes exposing (disabled)
import Nordea.Components.Toggle as Toggle
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI Config Msg {}
stories =
    styledStoriesOf
        "Toggle"
        [ ( "Toggle"
          , \model ->
                div []
                    [ Toggle.view []
                        { name = "Hey"
                        , onCheck = \_ -> ToggleToggle
                        , isChecked = model.customModel.isToggled
                        }
                    ]
          , {}
          )
        , ( "Toggle (Disabled)"
          , \model ->
                div []
                    [ Toggle.view [ disabled True ]
                        { name = "Hey"
                        , onCheck = \_ -> ToggleToggle
                        , isChecked = model.customModel.isToggled
                        }
                    ]
          , {}
          )
        ]
