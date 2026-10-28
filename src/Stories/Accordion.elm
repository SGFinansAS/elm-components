module Stories.Accordion exposing (stories)

import Config exposing (Config, Msg(..))
import Html.Styled as Html
import Nordea.Components.Accordion as Accordion
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI Config Msg {}
stories =
    styledStoriesOf
        "Accordion"
        [ ( "Default"
          , \model ->
                model.customModel.accordion
                    |> Accordion.view
                    |> Html.map AccordionMsg
          , {}
          )
        ]
