module Nordea.Components.Chat exposing (Appearance(..), OptionalConfig(..), chatHistoryView, init, view)

import Css
    exposing
        ( alignSelf
        , auto
        , border3
        , borderRadius4
        , breakWord
        , color
        , columnReverse
        , ellipsis
        , flexDirection
        , flexEnd
        , hidden
        , justifyContent
        , marginBottom
        , marginLeft
        , marginRight
        , maxHeight
        , noWrap
        , overflow
        , overflowWrap
        , padding
        , paddingRight
        , rem
        , solid
        , spaceBetween
        , textOverflow
        , whiteSpace
        , width
        )
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes exposing (css)
import List
import Nordea.Components.Card as Card
import Nordea.Components.Tag as Tag
import Nordea.Components.Text as Text
import Nordea.Css exposing (gap)
import Nordea.Html as Html exposing (showIf)
import Nordea.Resources.Colors as Colors
import Nordea.Resources.I18N exposing (Translation)
import Nordea.Resources.Illustrations as Illustrations
import Nordea.Themes as Themes
import Nordea.Utils.List as List


type alias Config =
    { translate : Translation -> String
    , appearance : Appearance
    }


type alias MessageViewConfig =
    { sentFrom : String
    , sentAt : String
    , sender : Maybe String
    , message : String
    , isIncomingMessage : Bool
    , readReceipt : Maybe String
    }


type Appearance
    = Small
    | Standard


type OptionalConfig msg
    = Appearance Appearance
    | BetaTag
    | HeaderText (Html msg)


type Chat
    = Chat Config


init : (Translation -> String) -> Chat
init translate =
    Chat
        { translate = translate
        , appearance = Standard
        }


view : List (OptionalConfig msg) -> List (Attribute msg) -> List (Html msg) -> List (Html msg) -> Chat -> Html msg
view optionals attrs history content (Chat config) =
    let
        { appearance, showBetaTag, headerText } =
            optionals
                |> List.foldl
                    (\e acc ->
                        case e of
                            Appearance app ->
                                { acc | appearance = app }

                            BetaTag ->
                                { acc | showBetaTag = True }

                            HeaderText headerText_ ->
                                { acc | headerText = headerText_ }
                    )
                    { appearance = Standard
                    , showBetaTag = False
                    , headerText = strings.title |> config.translate |> Html.text
                    }

        appearanceSpecificStyles =
            case appearance of
                Standard ->
                    [ gap (rem 1) ]

                Small ->
                    [ gap (rem 0.5)
                    , padding (rem 1) |> Css.important
                    , border3 (rem 0.094) solid Colors.mediumGray
                    ]

        headerView =
            case appearance of
                Standard ->
                    Html.row [ css [ marginBottom (rem 1) ] ]
                        [ Illustrations.messageInstructionalStar [ css [ width (rem 2), marginRight (rem 0.5) ] ]
                        , Text.bodyTextHeavy
                            |> Text.view [ css [ Themes.color Colors.deepBlue, alignSelf flexEnd ] ] [ headerText ]
                        ]

                Small ->
                    Html.row [ css [ marginBottom (rem 0.5) ] ]
                        [ Illustrations.messageInstructionalStar [ css [ width (rem 1.5), marginRight (rem 0.5) ] ]
                        , Text.textTinyHeavy
                            |> Text.view [ css [ Themes.color Colors.deepBlue, alignSelf flexEnd ] ] [ headerText ]
                        , Tag.beta [ css [ marginLeft auto ] ] |> showIf showBetaTag
                        ]

        messageHistoryView =
            let
                gapStyle =
                    case appearance of
                        Standard ->
                            gap (rem 1)

                        Small ->
                            gap (rem 0.5)
            in
            Html.column
                [ css
                    [ maxHeight (rem 15)
                    , overflow auto
                    , Css.property "scrollbar-width" "thin"
                    , paddingRight (rem 0.3125)
                    , flexDirection columnReverse |> Css.important
                    ]
                ]
                [ Html.column
                    [ css [ gapStyle ] ]
                    history
                ]
                |> showIf (List.isNotEmpty history)
    in
    Card.init
        |> Card.view (css appearanceSpecificStyles :: attrs)
            [ headerView
            , messageHistoryView
            , Html.column [ css [ gap (rem 0.5) ] ] content
                |> showIf (List.isNotEmpty content)
            ]


chatHistoryView : List (Attribute msg) -> MessageViewConfig -> Html msg
chatHistoryView attrs { sentFrom, sentAt, sender, message, isIncomingMessage, readReceipt } =
    let
        messageStyles =
            if isIncomingMessage then
                Css.batch
                    [ borderRadius4 (rem 0.5) (rem 0.5) (rem 0.5) (rem 0)
                    , Themes.color Colors.white
                    , Themes.backgroundColor Colors.nordeaBlue
                    ]

            else
                Css.batch
                    [ borderRadius4 (rem 0.5) (rem 0.5) (rem 0) (rem 0.5)
                    , Themes.backgroundColor Colors.coolGray
                    ]

        messageLabel attr text =
            Text.textTinyLight
                |> Text.view (css [ color Colors.darkGray, whiteSpace noWrap ] :: attr) [ Html.text text ]
    in
    Html.column (css [ gap (rem 0.25) ] :: attrs)
        [ Html.row [ css [ justifyContent spaceBetween ] ]
            [ messageLabel [ css [ marginRight (rem 0.25), textOverflow ellipsis, overflow hidden ] ] sentFrom
            , messageLabel [] sentAt
            ]
        , sender
            |> Maybe.map
                (\sender_ ->
                    Text.textTinyHeavy
                        |> Text.view [] [ Html.text sender_ ]
                )
            |> Maybe.withDefault Html.nothing
        , Html.column [ css [ padding (rem 0.625), gap (rem 0.625), messageStyles ] ]
            [ Text.textSmallLight
                |> Text.view
                    [ css
                        [ overflow hidden
                        , overflowWrap breakWord
                        , Css.property "hyphens" "auto"
                        ]
                    ]
                    [ Html.text message ]
            , readReceipt
                |> Maybe.map (messageLabel [])
                |> Maybe.withDefault Html.nothing
                |> showIf (not isIncomingMessage)
            ]
        ]



-- TRANSLATIONS


strings =
    { title =
        { no = "Melding"
        , se = "Meddelande"
        , dk = "Message"
        , en = "Message"
        }
    }
