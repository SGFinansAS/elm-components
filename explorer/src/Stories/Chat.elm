module Stories.Chat exposing (stories)

import Css exposing (maxWidth, rem)
import Html.Styled as Html
import Html.Styled.Attributes exposing (css)
import Nordea.Components.Chat as Chat
import Nordea.Components.Text as Text
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI a b {}
stories =
    styledStoriesOf
        "Chat"
        [ ( "Standard"
          , \_ ->
                Html.div [ css [ maxWidth (rem 30) ] ]
                    [ Chat.init .no
                        |> Chat.view []
                            []
                            (List.range 0 100
                                |> List.concatMap
                                    (\_ ->
                                        [ Chat.chatHistoryView []
                                            { sentFrom = "Nordea Finance"
                                            , sentAt = "30.05.2024, kl. 12:26"
                                            , sender = "Line"
                                            , message = "I forbindelse med deres søknad om finansiering gjennom oss ønsker vi innsikt i deres 2023-tall. Kan du oversende disse? Resultat- og balanserapport."
                                            , isUserMessage = False
                                            }
                                        , Chat.chatHistoryView []
                                            { sentFrom = "PartnerHub"
                                            , sentAt = "30.05.2024, kl. 13:54"
                                            , sender = "Thomas Olsen"
                                            , message = "Har lagt ved resultatrapport og balanserepport pr. 31.11.2023. Vi har ikke fått tilbake rapportene for des. 2023 fra regnskap firma."
                                            , isUserMessage = True
                                            }
                                        ]
                                    )
                            )
                            [ Text.textSmallLight |> Text.view [] [ Html.text "Some chat content" ]
                            ]
                    ]
          , {}
          )
        , ( "Small"
          , \_ ->
                Html.div [ css [ maxWidth (rem 25) ] ]
                    [ Chat.init .no
                        |> Chat.view []
                            []
                            (List.range 0 100
                                |> List.concatMap
                                    (\_ ->
                                        [ Chat.chatHistoryView []
                                            { sentFrom = "Nordea Finance"
                                            , sentAt = "30.05.2024, kl. 12:26"
                                            , sender = "Line"
                                            , message = "I forbindelse med deres søknad om finansiering gjennom oss ønsker vi innsikt i deres 2023-tall. Kan du oversende disse? Resultat- og balanserapport."
                                            , isUserMessage = False
                                            }
                                        , Chat.chatHistoryView []
                                            { sentFrom = "PartnerHub"
                                            , sentAt = "30.05.2024, kl. 13:54"
                                            , sender = "Thomas Olsen"
                                            , message = "Har lagt ved resultatrapport og balanserepport pr. 31.11.2023. Vi har ikke fått tilbake rapportene for des. 2023 fra regnskap firma."
                                            , isUserMessage = True
                                            }
                                        ]
                                    )
                            )
                            [ Text.textSmallLight |> Text.view [] [ Html.text "Some chat content" ]
                            ]
                    ]
          , {}
          )
        ]
