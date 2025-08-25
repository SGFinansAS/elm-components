module Stories.Chat exposing (stories)

import Config exposing (Config, Msg(..))
import Css exposing (maxWidth, rem)
import Html.Styled as Html
import Html.Styled.Attributes exposing (css)
import Nordea.Components.Chat as Chat
import Nordea.Components.Text as Text
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI Config Msg {}
stories =
    styledStoriesOf
        "Chat"
        [ ( "Standard"
          , \_ ->
                Html.div [ css [ maxWidth (rem 30) ] ]
                    [ Chat.init { translate = .no, uniqueId = "chat" }
                        |> Chat.view []
                            []
                            (List.range 0 100
                                |> List.concatMap
                                    (\_ ->
                                        [ Chat.chatHistoryView []
                                            { translate = .no
                                            , sentFrom = "Nordea Finance"
                                            , sentAt = "30.05.2024, kl. 12:26"
                                            , sender = Just "Line"
                                            , message = "[REDACTED]"
                                            , isIncomingMessage = False
                                            , readReceipt = Just "Lest i går kl. 14:36"
                                            , messageChipText = Just "Intern melding"
                                            , deletedAt = Just "i går kl. 14:36"
                                            }
                                        , Chat.chatHistoryView []
                                            { translate = .no
                                            , sentFrom = "Nordea Finance"
                                            , sentAt = "30.05.2024, kl. 12:26"
                                            , sender = Nothing
                                            , message = "I forbindelse med deres søknad om finansiering gjennom oss ønsker vi innsikt i deres 2023-tall. Kan du oversende disse? Resultat- og balanserapport."
                                            , isIncomingMessage = False
                                            , readReceipt = Just "Lest i går kl. 14:36"
                                            , messageChipText = Nothing
                                            , deletedAt = Nothing
                                            }
                                        , Chat.chatHistoryView []
                                            { translate = .no
                                            , sentFrom = "PartnerHub"
                                            , sentAt = "30.05.2024, kl. 13:54"
                                            , sender = Just "Thomas Olsen"
                                            , message = "Har lagt ved resultatrapport og balanserepport pr. 31.11.2023. Vi har ikke fått tilbake rapportene for des. 2023 fra regnskap firma."
                                            , isIncomingMessage = True
                                            , readReceipt = Nothing
                                            , messageChipText = Nothing
                                            , deletedAt = Nothing
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
          , \model ->
                Html.div [ css [ maxWidth (rem 25) ] ]
                    [ Chat.init { translate = .no, uniqueId = "chat" }
                        |> Chat.view
                            [ Chat.Appearance Chat.Small
                            , Chat.Collapsible
                                { emphasisedText = Nothing
                                , isOpen = model.customModel.isCardOpen
                                , onClick = ToggleOpenCard
                                }
                            ]
                            []
                            (List.range 0 100
                                |> List.concatMap
                                    (\_ ->
                                        [ Chat.chatHistoryView []
                                            { translate = .no
                                            , sentFrom = "Nordea Finance"
                                            , sentAt = "30.05.2024, kl. 12:26"
                                            , sender = Just "Line"
                                            , message = "[REDACTED]"
                                            , isIncomingMessage = False
                                            , readReceipt = Just "Lest i går kl. 14:36"
                                            , messageChipText = Just "Intern melding"
                                            , deletedAt = Just "i går kl. 14:36"
                                            }
                                        , Chat.chatHistoryView []
                                            { translate = .no
                                            , sentFrom = "Nordea Finance"
                                            , sentAt = "30.05.2024, kl. 12:26"
                                            , sender = Just "Line"
                                            , message = "I forbindelse med deres søknad om finansiering gjennom oss ønsker vi innsikt i deres 2023-tall. Kan du oversende disse? Resultat- og balanserapport."
                                            , isIncomingMessage = False
                                            , readReceipt = Just "Lest i går kl. 14:36"
                                            , messageChipText = Just "Intern melding"
                                            , deletedAt = Nothing
                                            }
                                        , Chat.chatHistoryView []
                                            { translate = .no
                                            , sentFrom = "Nordea Finance Equipment AS - Long company name"
                                            , sentAt = "30.05.2024, kl. 13:54"
                                            , sender = Just "Thomas Olsen"
                                            , message = "Har lagt ved resultatrapport og balanserepport pr. 31.11.2023. Vi har ikke fått tilbake rapportene for des. 2023 fra regnskap firma."
                                            , isIncomingMessage = True
                                            , readReceipt = Nothing
                                            , messageChipText = Nothing
                                            , deletedAt = Nothing
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
