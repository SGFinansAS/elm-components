module Stories.AccordionMenu exposing (..)

import Config exposing (Config, Msg(..))
import Css exposing (rem, width)
import Html.Styled exposing (div)
import Html.Styled.Attributes exposing (css)
import Nordea.Components.AccordionMenu as AccordionMenu
import Nordea.Resources.Icons as Icons
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI Config Msg {}
stories =
    styledStoriesOf
        "AccordionMenu"
        [ ( "Multiple"
          , \model ->
                AccordionMenu.init model.customModel.accordionMenuIsOpen ToggleAccordionMenu
                    |> AccordionMenu.withItem
                        { icon = Icons.filledCheckmark [ css [ width (rem 2) ] ]
                        , text = "Kontrakt e-signert 10.10.22"
                        }
                    |> AccordionMenu.withItem
                        { icon = Icons.filledInfo [ css [ width (rem 2) ] ]
                        , text = "Undertegner identifisert 09.10.22"
                        }
                    |> AccordionMenu.withItem
                        { icon = Icons.dismiss [ css [ width (rem 2) ] ]
                        , text = "E-signering utloper snart 08.10.22"
                        }
                    |> AccordionMenu.withItem
                        { icon = Icons.filledWarning [ css [ width (rem 2) ] ]
                        , text = "E-signering sendt 07.10.22"
                        }
                    |> AccordionMenu.view
          , {}
          )
        , ( "Single"
          , \model ->
                AccordionMenu.init model.customModel.accordionMenuIsOpen ToggleAccordionMenu
                    |> AccordionMenu.withItem
                        { icon = Icons.filledCheckmark [ css [ width (rem 2) ] ]
                        , text = "Kontrakt e-signert 10.10.22"
                        }
                    |> AccordionMenu.view
          , {}
          )
        ]
