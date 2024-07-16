module Nordea.Components.Chat exposing (Appearance(..), OptionalConfig(..), chatHistoryView, init, view)

import Css
    exposing
        ( alignSelf
        , auto
        , border3
        , borderRadius4
        , color
        , flexEnd
        , justifyContent
        , marginBottom
        , marginRight
        , maxHeight
        , overflow
        , padding
        , paddingRight
        , px
        , rem
        , solid
        , spaceBetween
        , width
        )
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes exposing (css)
import Nordea.Components.Card as Card
import Nordea.Components.Text as Text
import Nordea.Css exposing (gap)
import Nordea.Html as Html exposing (showIf)
import Nordea.Resources.Colors as Colors
import Nordea.Resources.I18N exposing (Translation)
import Nordea.Resources.Illustrations as Illustrations
import Nordea.Themes as Themes


type alias Config =
    { translate : Translation -> String
    , appearance : Appearance
    }


type alias MessageViewConfig =
    { sendFrom : String
    , sendAt : String
    , sender : String
    , message : String
    , isUserMessage : Bool
    }


type Appearance
    = Small
    | Standard


type OptionalConfig
    = Appearance Appearance


type Chat
    = Chat Config


init : (Translation -> String) -> Chat
init translate =
    Chat
        { translate = translate
        , appearance = Standard
        }


view : List OptionalConfig -> List (Attribute msg) -> List (Html msg) -> List (Html msg) -> Chat -> Html msg
view optionals attrs history content (Chat config) =
    let
        appearance =
            optionals
                |> List.head
                |> Maybe.map (\(Appearance app) -> app)
                |> Maybe.withDefault Standard

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
                            |> Text.view [ css [ Themes.color Colors.deepBlue, alignSelf flexEnd ] ] [ strings.title |> config.translate |> Html.text ]
                        ]

                Small ->
                    Html.row [ css [ marginBottom (rem 0.5) ] ]
                        [ Illustrations.messageInstructionalStar [ css [ width (rem 1.5), marginRight (rem 0.5) ] ]
                        , Text.textTinyHeavy
                            |> Text.view [ css [ Themes.color Colors.deepBlue, alignSelf flexEnd ] ] [ strings.title |> config.translate |> Html.text ]
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
                [ css [ gapStyle, maxHeight (px 500), overflow auto, paddingRight (rem 0.3125) ]
                ]
                history
                |> showIf (not (List.isEmpty history))
    in
    Card.init
        |> Card.view (css appearanceSpecificStyles :: attrs)
            [ headerView
            , messageHistoryView
            , Html.column [ css [ gap (rem 0.5) ] ] content |> showIf (not (List.isEmpty content))
            ]


chatHistoryView : List (Attribute msg) -> MessageViewConfig -> Html msg
chatHistoryView attrs { sendFrom, sendAt, sender, message, isUserMessage } =
    let
        messageStyles =
            if isUserMessage then
                [ borderRadius4 (rem 0.5) (rem 0.5) (rem 0) (rem 0.5)
                , Themes.backgroundColor Colors.coolGray
                ]

            else
                [ borderRadius4 (rem 0.5) (rem 0.5) (rem 0.5) (rem 0)
                , Themes.color Colors.white
                , Themes.backgroundColor Colors.nordeaBlue
                ]

        messageLabel text =
            Text.textTinyLight
                |> Text.view [ css [ color Colors.darkGray ] ] [ Html.text text ]
    in
    Html.column (css [ gap (rem 0.25) ] :: attrs)
        [ Html.row [ css [ justifyContent spaceBetween ] ]
            [ messageLabel sendFrom
            , messageLabel sendAt
            ]
        , Text.textTinyHeavy
            |> Text.view [] [ Html.text sender ]
        , Text.textSmallLight
            |> Text.view
                [ css (padding (rem 0.625) :: messageStyles) ]
                [ Html.text message ]
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
