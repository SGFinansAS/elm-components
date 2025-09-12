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
                            [ Chat.chatHistoryView []
                                { translate = .no
                                , sentFrom = Just "Nordea Finance"
                                , sentTo = Just (Chat.darkPinkBubbleTag [] [ Html.text "Intern melding" ])
                                , sentAt = "30.05.2024, kl. 12:26"
                                , sender = "Line"
                                , message = Html.text "[REDACTED]"
                                , isIncomingMessage = False
                                , readReceipt = Just "i går kl. 14:36"
                                , deletedAt = Just "i går kl. 14:36"
                                }
                            , Chat.chatHistoryView []
                                { translate = .no
                                , sentFrom = Nothing
                                , sentTo = Just (Chat.darkPinkBubbleTag [] [ Html.text "Intern melding" ])
                                , sentAt = "30.05.2024, kl. 12:26"
                                , sender = "Nordea Finance"
                                , message = Html.text "I forbindelse med deres søknad om finansiering gjennom oss ønsker vi innsikt i deres 2023-tall. Kan du oversende disse? Resultat- og balanserapport."
                                , isIncomingMessage = False
                                , readReceipt = Just "i går kl. 14:36"
                                , deletedAt = Nothing
                                }
                            , Chat.chatHistoryView []
                                { translate = .no
                                , sentFrom = Just "PartnerHub"
                                , sentTo = Nothing
                                , sentAt = "30.05.2024, kl. 13:54"
                                , sender = "Thomas Olsen"
                                , message = Html.text "Har lagt ved resultatrapport og balanserepport pr. 31.11.2023. Vi har ikke fått tilbake rapportene for des. 2023 fra regnskap firma."
                                , isIncomingMessage = True
                                , readReceipt = Nothing
                                , deletedAt = Nothing
                                }
                            ]
                            [ Text.textSmallLight |> Text.view [] [ Html.text "Some chat content" ] ]
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
                            [ Chat.chatHistoryView []
                                { translate = .no
                                , sentFrom = Just "Nordea Finance"
                                , sentTo = Just (Chat.darkPinkBubbleTag [] [ Html.text "Intern melding" ])
                                , sentAt = "30.05.2024, kl. 12:26"
                                , sender = "Line"
                                , message = Html.text "[REDACTED]"
                                , isIncomingMessage = False
                                , readReceipt = Just "i går kl. 14:36"
                                , deletedAt = Just "i går kl. 14:36"
                                }
                            , Chat.chatHistoryView []
                                { translate = .no
                                , sentFrom = Nothing
                                , sentTo = Just (Chat.darkPinkBubbleTag [] [ Html.text "Intern melding" ])
                                , sentAt = "30.05.2024, kl. 12:26"
                                , sender = "Nordea Finance"
                                , message = Html.text "I forbindelse med deres søknad om finansiering gjennom oss ønsker vi innsikt i deres 2023-tall. Kan du oversende disse? Resultat- og balanserapport."
                                , isIncomingMessage = False
                                , readReceipt = Just "i går kl. 14:36"
                                , deletedAt = Nothing
                                }
                            , Chat.chatHistoryView []
                                { translate = .no
                                , sentFrom = Just "PartnerHub"
                                , sentTo = Nothing
                                , sentAt = "30.05.2024, kl. 13:54"
                                , sender = "Thomas Olsen"
                                , message = Html.text "Har lagt ved resultatrapport og balanserepport pr. 31.11.2023. Vi har ikke fått tilbake rapportene for des. 2023 fra regnskap firma."
                                , isIncomingMessage = True
                                , readReceipt = Nothing
                                , deletedAt = Nothing
                                }
                            ]
                            [ Text.textSmallLight |> Text.view [] [ Html.text "Some chat content" ] ]
                    ]
          , {}
          )
        ]
