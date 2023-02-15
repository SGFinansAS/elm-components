module Stories.AccordionMenu exposing (..)

import Config exposing (Config, Msg(..))
import Css exposing (cursor, fontSize, listStyle, marginRight, marginTop, middle, none, padding, paddingLeft, pointer, rem, verticalAlign, width)
import Css.Global exposing (children, typeSelector)
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
          , \_ ->
                AccordionMenu.view
                    { isOpen = True }
                    []
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
        , ( "Nested"
          , \_ ->
                AccordionMenu.view
                    { isOpen = True }
                    []
                    []
                    [ AccordionMenu.header [] [ text "Parent Accordion " ]
                    , AccordionMenu.content [ css [ paddingLeft (rem 2) ] ]
                        [ text "Description"
                        , AccordionMenu.view
                            { isOpen = True }
                            []
                            []
                            [ AccordionMenu.header [] [ text "Child Accordion" ]
                            , AccordionMenu.content []
                                [ ul []
                                    [ li [] [ text "Undertegner identifisert 09.10.22" ]
                                    , li [] [ text "E-signering utloper snart 08.10.22" ]
                                    , li [] [ text "E-signering sendt 07.10.22" ]
                                    ]
                                ]
                            ]
                        ]
                    ]
          , {}
          )
        , ( "Styled"
          , \_ ->
                AccordionMenu.view
                    { isOpen = True }
                    []
                    []
                    [ AccordionMenu.header [ css [ cursor pointer ] ] [ Icons.filledCheckmark [ css [ verticalAlign middle, width (rem 2), marginRight (rem 0.5) ] ], text "Kontrakt e-signert 10.10.22" ]
                    , AccordionMenu.content [ css [ fontSize (rem 0.9) ] ]
                        [ ul [ css [ padding (rem 0), listStyle none, children [ typeSelector "li" [ marginTop (rem 0.5) ] ] ] ]
                            [ li [] [ Icons.filledInfo [ css [ verticalAlign middle, width (rem 2), marginRight (rem 0.5) ] ], text "Undertegner identifisert 09.10.22" ]
                            , li [] [ Icons.dismiss [ css [ verticalAlign middle, width (rem 2), marginRight (rem 0.5) ] ], text "E-signering utloper snart 08.10.22" ]
                            , li [] [ Icons.filledWarning [ css [ verticalAlign middle, width (rem 2), marginRight (rem 0.5) ] ], text "E-signering sendt 07.10.22" ]
                            ]
                        ]
                    ]
          , {}
          )
        ]
