module Nordea.Components.Chat exposing (Appearance(..), OptionalConfig(..), chatHistoryView, init, view)

import Css
    exposing
        ( alignSelf
        , border3
        , borderRadius4
        , color
        , flexEnd
        , fontSize
        , justifyContent
        , marginBottom
        , marginRight
        , marginTop
        , padding
        , rem
        , solid
        , spaceBetween
        , width
        )
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events exposing (onClick)
import Nordea.Components.Button as Button
import Nordea.Components.Card as Card
import Nordea.Components.Text as Text
import Nordea.Components.TextArea as TextArea
import Nordea.Css exposing (gap)
import Nordea.Html as Html
import Nordea.Resources.Colors as Colors
import Nordea.Resources.I18N exposing (Translation)
import Nordea.Resources.Illustrations as Illustrations
import Nordea.Themes as Themes


type alias Config msg =
    { translate : Translation -> String
    , appearance : Appearance
    , placeholder : String
    , inputMessage : String
    , onSend : msg
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


type Chat msg
    = Chat (Config msg)


init : (Translation -> String) -> String -> String -> msg -> Chat msg
init translate inputMessage placeholder onSend =
    Chat
        { translate = translate
        , appearance = Standard
        , placeholder = placeholder
        , inputMessage = inputMessage
        , onSend = onSend
        }


view : List OptionalConfig -> List (Attribute msg) -> List (Html msg) -> Chat msg -> Html msg
view optionals attrs content (Chat config) =
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

        inputView =
            let
                ( fontSizeStyle, primaryButton ) =
                    case appearance of
                        Standard ->
                            ( fontSize (rem 0.875) |> Css.important, Button.primary )

                        Small ->
                            ( fontSize (rem 0.75) |> Css.important, Button.primary |> Button.withSmallSize )
            in
            Html.column []
                [ TextArea.init config.inputMessage
                    |> TextArea.withPlaceholder config.placeholder
                    |> TextArea.view [ css [ fontSizeStyle ] ]
                , primaryButton
                    |> Button.view [ onClick config.onSend, css [ alignSelf flexEnd, marginTop (rem 0.5) ] ] [ strings.send |> config.translate |> Html.text ]
                ]

        messageHistoryView =
            Html.column
                [ case appearance of
                    Standard ->
                        css [ gap (rem 1) ]

                    Small ->
                        css [ gap (rem 0.5) ]
                ]
                content
    in
    Card.init
        |> Card.view (css appearanceSpecificStyles :: attrs)
            [ headerView
            , messageHistoryView
            , inputView
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
        , se = "Message"
        , dk = "Message"
        , en = "Message"
        }
    , send =
        { no = "Send"
        , se = "Send"
        , dk = "Send"
        , en = "Send"
        }
    }
