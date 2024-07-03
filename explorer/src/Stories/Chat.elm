module Stories.Chat exposing (stories)

import Config exposing (Msg(..))
import Css exposing (maxWidth, rem)
import Html.Styled as Html
import Html.Styled.Attributes exposing (css)
import Nordea.Components.Chat as Chat exposing (OptionalConfig(..))
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)

stories : UI a Msg {}
stories =
    styledStoriesOf
        "Chat"
        [ ( "Standard"
          , \_ ->
                Html.div [ css [ maxWidth (rem 30)  ] ]
                    [ Chat.init .no "" "Write message to case worker" NoOp
                        |> Chat.view []
                             []
                             [ Chat.chatHistoryView []
                                 { sendFrom = "Nordea Finance"
                                 , sendAt = "30.05.2024, kl. 12:26"
                                 , sender = "Line"
                                 , message = "I forbindelse med deres søknad om finansiering gjennom oss ønsker vi innsikt i deres 2023-tall. Kan du oversende disse? Resultat- og balanserapport."
                                 , isUserMessage = False
                                 }
                             , Chat.chatHistoryView []
                                 { sendFrom = "PartnerHub"
                                 , sendAt = "30.05.2024, kl. 13:54"
                                 , sender = "Thomas Olsen"
                                 , message = "Har lagt ved resultatrapport og balanserepport pr. 31.11.2023. Vi har ikke fått tilbake rapportene for des. 2023 fra regnskap firma."
                                 , isUserMessage = True
                                 }
                             ]
                    ]
          , {}
          )
        , ( "Small"
          , \_ ->
                Html.div [ css [ maxWidth (rem 25) ] ]
                    [ Chat.init .no "Write message to case worker" "" NoOp
                      |> Chat.view [ Chat.Appearance Chat.Small ]
                           []
                           [ Chat.chatHistoryView []
                               { sendFrom = "Nordea Finance"
                               , sendAt = "30.05.2024, kl. 12:26"
                               , sender = "Line"
                               , message = "I forbindelse med deres søknad om finansiering gjennom oss ønsker vi innsikt i deres 2023-tall. Kan du oversende disse? Resultat- og balanserapport."
                               , isUserMessage = True
                               }
                           , Chat.chatHistoryView []
                               { sendFrom = "PartnerHub"
                               , sendAt = "30.05.2024, kl. 13:54"
                               , sender = "Thomas Olsen"
                               , message = "Har lagt ved resultatrapport og balanserepport pr. 31.11.2023. Vi har ikke fått tilbake rapportene for des. 2023 fra regnskap firma."
                               , isUserMessage = False
                               }
                           ]
                    ]
          , {}
          )
        ]
