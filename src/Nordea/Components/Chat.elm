module Nordea.Components.Chat exposing
    ( Appearance(..)
    , OptionalConfig(..)
    , chatHistoryView
    , darkPinkBubbleTag
    , init
    , lightBlueBubbleTag
    , sakuraBubbleTag
    , view
    )

import CaseDialogue.Icons as Icons
import Css
    exposing
        ( alignItems
        , alignSelf
        , auto
        , backgroundColor
        , border3
        , borderBottom3
        , borderColor
        , borderRadius
        , borderRadius4
        , borderTop3
        , borderWidth
        , breakWord
        , center
        , color
        , column
        , columnReverse
        , cursor
        , display
        , displayFlex
        , ellipsis
        , flexDirection
        , flexEnd
        , flexGrow
        , fontStyle
        , height
        , hidden
        , hover
        , inlineBlock
        , italic
        , justifyContent
        , listStyle
        , listStyleType
        , margin
        , marginBottom
        , marginLeft
        , marginRight
        , marginTop
        , maxHeight
        , minWidth
        , noWrap
        , none
        , num
        , outline
        , overflow
        , overflowWrap
        , padding
        , padding2
        , padding4
        , paddingRight
        , pointer
        , position
        , pseudoClass
        , relative
        , rem
        , row
        , solid
        , textOverflow
        , whiteSpace
        , width
        )
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attrs exposing (attribute, css, id, tabindex)
import Html.Styled.Events exposing (onClick)
import List
import Maybe.Extra as Maybe
import Nordea.Components.Button as Button
import Nordea.Components.Card as Card
import Nordea.Components.Text as Text
import Nordea.Components.Tooltip as Tooltip
import Nordea.Css exposing (gap)
import Nordea.Html as Html exposing (showIf, viewMaybe)
import Nordea.Resources.Colors as Colors
import Nordea.Resources.I18N exposing (Translation)
import Nordea.Resources.Illustrations as Illustrations
import Nordea.Themes as Themes
import Nordea.Utils.List as List


type alias Config =
    { translate : Translation -> String
    , appearance : Appearance
    , uniqueId : String
    }


type alias MessageViewConfig msg =
    { translate : Translation -> String
    , sentFrom : Maybe String
    , sentTo : Maybe (Html msg)
    , sentAt : String
    , sender : String
    , message : List (Html msg)
    , isIncomingMessage : Bool
    , readReceipt : Maybe String
    , deletedAt : Maybe String
    , editView : Maybe (Html msg)
    , contextMenu :
        Maybe
            { onClickOpen : msg
            , isOpen : Bool
            , items : List { onClick : msg, label : String }
            }
    }


type Appearance
    = Small
    | Standard


type alias CollapsibleConfig msg =
    { emphasisedText : Maybe (Html msg), isOpen : Bool, onClick : msg }


type OptionalConfig msg
    = Appearance Appearance
    | Title (Html msg)
    | Collapsible (CollapsibleConfig msg)


type Chat
    = Chat Config


init : { uniqueId : String, translate : Translation -> String } -> Chat
init { uniqueId, translate } =
    Chat
        { translate = translate
        , appearance = Standard
        , uniqueId = uniqueId
        }


view : List (OptionalConfig msg) -> List (Attribute msg) -> List (Html msg) -> List (Html msg) -> Chat -> Html msg
view optionals attrs history content (Chat config) =
    let
        { appearance, title, collapsibleProps } =
            optionals
                |> List.foldl
                    (\e acc ->
                        case e of
                            Appearance app ->
                                { acc | appearance = app }

                            Title title_ ->
                                { acc | title = title_ }

                            Collapsible props ->
                                { acc | collapsibleProps = Just props }
                    )
                    { appearance = Standard
                    , title =
                        Text.textHeavy
                            |> Text.withHtmlTag Html.h2
                            |> Text.view [ css [ Themes.color Colors.deepBlue, alignSelf flexEnd ] ]
                                [ strings.title |> config.translate |> Html.text ]
                    , collapsibleProps = Nothing
                    }

        smallAppearanceSpecificStyles =
            Css.batch
                [ padding (rem 1) |> Css.important
                , border3 (rem 0.094) solid Colors.mediumGray
                ]

        headerView =
            case appearance of
                Standard ->
                    Html.row [ id config.uniqueId, css [ flexGrow (num 1) ] ]
                        [ Illustrations.messageInstructionalStar [ attribute "aria-hidden" "true", css [ width (rem 2), marginRight (rem 0.5) ] ]
                        , title
                        ]

                Small ->
                    Html.row [ id config.uniqueId, css [ marginBottom (rem 1) |> Css.important |> Html.styleIf (Maybe.isNothing collapsibleProps), flexGrow (num 1) ] ]
                        [ Illustrations.messageInstructionalStar [ attribute "aria-hidden" "true", css [ width (rem 1.5), marginRight (rem 0.5) ] ]
                        , title
                        ]

        messageHistoryView =
            Html.column
                [ attribute "role" "none"
                , css
                    [ maxHeight (rem 15)
                    , overflow auto
                    , Css.property "scrollbar-width" "thin"
                    , paddingRight (rem 0.3125)
                    , flexDirection columnReverse |> Css.important
                    , marginTop (rem -0.5) |> Html.styleIf (Maybe.isJust collapsibleProps && appearance == Small)
                    ]
                ]
                [ Html.ol
                    [ css
                        [ listStyleType none
                        , displayFlex
                        , flexDirection column
                        , padding (rem 0)
                        , margin (rem 0)
                        , gap (rem 1)
                        ]
                    ]
                    history
                ]
                |> showIf (List.isNotEmpty history)
    in
    Card.init
        |> Card.withHtmlTitle headerView
        |> Card.isCollapsible collapsibleProps
        |> Card.view
            (attribute "aria-labelledby" config.uniqueId
                :: css [ smallAppearanceSpecificStyles |> Html.styleIf (appearance == Small) ]
                :: attrs
            )
            [ messageHistoryView
            , Html.column [ css [ gap (rem 0.5), marginTop (rem 1) ] ] content
                |> showIf (List.isNotEmpty content)
            ]


chatHistoryView : List (Attribute msg) -> MessageViewConfig msg -> Html msg
chatHistoryView attrs { translate, sentFrom, sentTo, sentAt, sender, message, isIncomingMessage, readReceipt, deletedAt, editView, contextMenu } =
    let
        messageStyles =
            if isIncomingMessage then
                Css.batch
                    [ borderRadius4 (rem 1) (rem 1) (rem 1) (rem 0)
                    , Themes.backgroundColor Colors.cloudBlue
                    ]

            else
                Css.batch
                    [ borderRadius4 (rem 1) (rem 1) (rem 0) (rem 1)
                    , Themes.backgroundColor Colors.coolGray
                    ]
    in
    if deletedAt /= Nothing then
        Html.li attrs
            [ Html.article [ css [ displayFlex, alignItems center, justifyContent center ] ]
                [ Text.textSmallLight
                    |> Text.withHtmlTag Html.p
                    |> Text.view
                        [ css
                            [ overflow hidden
                            , overflowWrap breakWord
                            , fontStyle italic
                            , Css.property "hyphens" "auto"
                            ]
                        ]
                        [ Html.text (sender ++ " " ++ translate strings.deletedAMessage) ]
                ]
            ]

    else
        Html.li attrs
            [ Html.article [ css [ displayFlex, flexDirection column, messageStyles, padding (rem 0.625), gap (rem 0.625) ] ]
                [ Html.header [ css [ displayFlex, flexDirection row, alignItems center ] ]
                    [ Text.textTinyHeavy |> Text.view [ css [ color Colors.darkestGray ] ] [ Html.text sender ]
                    , sentFrom
                        |> Html.viewMaybe
                            (\sentFrom_ -> Text.textTinyLight |> Text.view [ css [ color Colors.darkestGray, marginLeft (rem 0.25) ] ] [ Html.text ("(" ++ sentFrom_ ++ ")") ])
                    , sentTo
                        |> Maybe.withDefault Html.nothing
                    ]
                , case editView of
                    Just editView_ ->
                        editView_

                    Nothing ->
                        Text.textSmallLight
                            |> Text.withHtmlTag Html.p
                            |> Text.view
                                [ css
                                    [ overflow hidden
                                    , overflowWrap breakWord
                                    , Css.property "hyphens" "auto"
                                    ]
                                ]
                                message
                , Html.footer [ css [ displayFlex ] ]
                    [ Html.div []
                        [ Text.textTinyLight
                            |> Text.view [ css [ color Colors.nordeaGray, whiteSpace noWrap ] ] [ Html.text sentAt ]
                        , readReceipt
                            |> Html.viewMaybe
                                (\r ->
                                    Text.textTinyLight
                                        |> Text.view [ css [ color Colors.nordeaGray, whiteSpace noWrap ] ] [ Html.text r ]
                                )
                            |> showIf (not isIncomingMessage)
                        ]
                    , contextMenu
                        |> viewMaybe
                            (\{ onClickOpen, isOpen, items } ->
                                Tooltip.init
                                    |> Tooltip.withPlacement Tooltip.LeftTop
                                    |> Tooltip.withVisibility
                                        (if isOpen then
                                            Tooltip.Show

                                         else
                                            Tooltip.Hidden
                                        )
                                    |> Tooltip.withContent (\_ -> contextMenuView [ css [ marginBottom (rem 0.25) ] ] items)
                                    |> Tooltip.view [ css [ position relative, marginLeft auto ] ]
                                        [ Button.circular
                                            |> Button.withSmallSize
                                            |> Button.view
                                                [ onClick onClickOpen
                                                , css
                                                    [ alignSelf flexEnd
                                                    , backgroundColor Colors.transparent
                                                    , borderWidth (rem 0) |> Css.important
                                                    , hover [ backgroundColor Colors.mediumGray |> Css.important ]
                                                    ]
                                                ]
                                                [ Icons.kebab [ css [ minWidth (rem 0.2125) ] ] ]
                                        ]
                            )
                    ]
                ]
            ]


bubbleTag attrs body =
    Text.textTinyLight
        |> Text.view
            (css
                [ display inlineBlock
                , borderRadius (rem 1.25)
                , padding2 (rem 0.125) (rem 0.5)
                , textOverflow ellipsis
                , overflow hidden
                , whiteSpace noWrap
                , marginLeft auto
                ]
                :: attrs
            )
            body


lightBlueBubbleTag attrs body =
    bubbleTag (css [ backgroundColor Colors.lightBlue ] :: attrs) body


sakuraBubbleTag attrs body =
    bubbleTag (css [ backgroundColor Colors.sakura ] :: attrs) body


darkPinkBubbleTag attrs body =
    bubbleTag (css [ backgroundColor Colors.yellow ] :: attrs) body


contextMenuView attrs menuItems =
    Html.ul
        (Attrs.attribute "role" "menu"
            :: css
                [ listStyle none
                , backgroundColor Colors.white
                , border3 (rem 0.0625) solid Colors.mediumGray
                , borderRadius (rem 0.25)
                , marginTop (rem 0.5)
                , width (rem 13)
                , padding (rem 0) |> Css.important
                ]
            :: attrs
        )
        (menuItems |> List.map contextMenuItem)


contextMenuItem item =
    Html.li
        [ css
            [ displayFlex
            , flexDirection row
            , listStyleType none
            , cursor pointer
            , alignItems center
            , height (rem 2)
            , padding4 (rem 0) (rem 0.5) (rem 0) (rem 0.5)
            , pseudoClass "focus-within"
                [ Themes.backgroundColor Colors.cloudBlue
                , borderBottom3 (rem 0.1) solid Colors.mediumGray
                , borderTop3 (rem 0.1) solid Colors.mediumGray
                , outline none
                , borderColor Colors.mediumGray
                ]
            , hover [ backgroundColor Colors.coolGray ]
            ]
        , tabindex 0
        , Attrs.attribute "role" "menuitem"
        , onClick item.onClick
        ]
        [ Text.textSmallLight
            |> Text.view [] [ Html.text item.label ]
        ]



-- TRANSLATIONS


strings =
    { title =
        { en = "Message"
        , no = "Melding"
        , se = "Meddelande"
        , dk = "Message"
        }
    , deletedAMessage =
        { en = "deleted a message"
        , no = "slettet en melding"
        , se = "raderat ett meddelande"
        , dk = "slettet en besked"
        }
    }
