module Stories.AccordionMenu exposing (..)

import Config exposing (Config, Msg(..))
import Css exposing (cursor, fontSize, listStyle, marginRight, marginTop, middle, none, pointer, rem, verticalAlign, width)
import Html.Styled exposing (div, li, span, text, ul)
import Html.Styled.Attributes exposing (css)
import Nordea.Components.AccordionMenu as AccordionMenu exposing (..)
import Nordea.Resources.Icons as Icons
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI Config Msg {}
stories =
    styledStoriesOf
        "AccordionMenu"
        [ ( "Default"
          , \model ->
                AccordionMenu.view
                    [ Status Closed ]
                    []
                    [ AccordionMenu.header [] [ text "Kontrakt e-signert 10.10.22" ]
                    , AccordionMenu.content []
                        [ ul []
                            [ li [] [ text "Undertegner identifisert 09.10.22" ]
                            , li [] [ text "E-signering utloper snart 08.10.22" ]
                            , li [] [ text "E-signering sendt 07.10.22" ]
                            ]
                        ]
                    ]
          , {}
          )
        , ( "Styled"
          , \model ->
                AccordionMenu.view
                    [ Status Closed ]
                    []
                    [ AccordionMenu.header [ css [ cursor pointer ] ] [ Icons.filledCheckmark [ css [ verticalAlign middle, width (rem 2), marginRight (rem 0.5) ] ], text "Kontrakt e-signert 10.10.22" ]
                    , AccordionMenu.content [ css [ fontSize (rem 0.9) ] ]
                        [ ul [ css [ listStyle none ] ]
                            [ li [ css [ marginTop (rem 0.5) ] ] [ Icons.filledInfo [ css [ verticalAlign middle, width (rem 2), marginRight (rem 0.5) ] ], text "Undertegner identifisert 09.10.22" ]
                            , li [ css [ marginTop (rem 0.5) ] ] [ Icons.dismiss [ css [ verticalAlign middle, width (rem 2), marginRight (rem 0.5) ] ], text "E-signering utloper snart 08.10.22" ]
                            , li [ css [ marginTop (rem 0.5) ] ] [ Icons.filledWarning [ css [ verticalAlign middle, width (rem 2), marginRight (rem 0.5) ] ], text "E-signering sendt 07.10.22" ]
                            ]
                        ]
                    ]
          , {}
          )
        ]
