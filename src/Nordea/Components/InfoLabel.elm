module Nordea.Components.InfoLabel exposing
    ( InfoLabel
    , Msg
    , init
    , openableView
    , update
    , view
    , warning
    , withIsOpen
    , withText
    , withTitle
    )

import Css
    exposing
        ( backgroundColor
        , borderRadius
        , column
        , displayFlex
        , fitContent
        , flexDirection
        , height
        , hidden
        , marginBottom
        , marginRight
        , marginTop
        , maxWidth
        , overflow
        , padding
        , property
        , rem
        , row
        , width
        )
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events as Events
import Json.Decode as Decode
import Nordea.Components.FlatLink as FlatLink
import Nordea.Components.Text as Text
import Nordea.Html
import Nordea.Resources.Colors as Colors
import Nordea.Resources.I18N exposing (Translation)
import Nordea.Resources.Icons as Icon
import Nordea.Themes as Themes


type ButtonName
    = ReadMore (Translation -> String)
    | Close (Translation -> String)
    | Custom String


type InfoLabel
    = InfoLabel Config


type Msg
    = OpenText


type alias Config =
    { text : List String
    , open : Bool
    , title : Maybe String
    }


init : InfoLabel
init =
    InfoLabel
        { text = []
        , open = False
        , title = Nothing
        }


withText : List String -> InfoLabel -> InfoLabel
withText textList (InfoLabel config) =
    InfoLabel { config | text = textList }


withTitle : String -> InfoLabel -> InfoLabel
withTitle title (InfoLabel config) =
    InfoLabel { config | title = Just title }


withIsOpen : Bool -> InfoLabel -> InfoLabel
withIsOpen open (InfoLabel config) =
    InfoLabel { config | open = not open }


update : Msg -> InfoLabel -> InfoLabel
update msg (InfoLabel config) =
    case msg of
        OpenText ->
            InfoLabel { config | open = not config.open }


view : List (Attribute msg) -> List (Html msg) -> Html msg
view attrs children =
    Html.div
        (infoLabelContainerStyle :: css [ Themes.backgroundColor Themes.SecondaryColor Colors.blueCloud ] :: attrs)
        [ Icon.info [ css [ width (rem 1.5), height (rem 1.5), marginRight (rem 0.5) ] ]
        , Text.bodyTextSmall
            |> Text.view [] children
        ]


warning : List (Attribute msg) -> List (Html msg) -> Html msg
warning attrs children =
    Html.div
        (infoLabelContainerStyle :: css [ backgroundColor Colors.yellow ] :: attrs)
        [ Icon.info [ css [ width (rem 1.5), height (rem 1.5), marginRight (rem 0.5) ] ]
        , Text.bodyTextSmall
            |> Text.view [] children
        ]


openableView : (Translation -> String) -> List (Attribute Msg) -> Html Msg -> InfoLabel -> Html Msg
openableView language attrs children (InfoLabel config) =
    let
        iconButton =
            let
                toI18NString buttonName =
                    buttonName
                        |> Maybe.map
                            (\name ->
                                case name of
                                    ReadMore translate ->
                                        translate strings.readMore

                                    Close translate ->
                                        translate strings.close

                                    Custom string ->
                                        string
                            )
            in
            if config.open then
                [ Text.bodyTextHeavy
                    |> Text.view [] [ Html.text (Just (Close language) |> toI18NString |> Maybe.withDefault "Close") ]
                , Icon.rightIcon (Icon.chevronUp [])
                ]

            else
                [ Text.bodyTextHeavy
                    |> Text.view [] [ Html.text (Just (ReadMore language) |> toI18NString |> Maybe.withDefault "Read more") ]
                , Icon.rightIcon (Icon.chevronDown [])
                ]

        style =
            if config.open || charCount config.text < 345 then
                css []

            else
                css
                    [ overflow hidden
                    , property "display" "-webkit-box"
                    , property "-webkit-box-orient" "vertical"
                    , property "-webkit-line-clamp" "2"
                    ]
    in
    Html.div
        (css
            [ Themes.backgroundColor Themes.SecondaryColor Colors.blueCloud
            , displayFlex
            , flexDirection row
            , padding (rem 0.75)
            , borderRadius (rem 0.5)
            , maxWidth fitContent
            ]
            :: attrs
        )
        [ Icon.info [ css [ width (rem 1.5), height (rem 1.5), marginRight (rem 0.5) ] ]
        , Html.div [ css [ displayFlex, flexDirection column ] ]
            [ Text.bodyTextHeavy
                |> Text.view [ css [ marginBottom (rem 0.5) ] ] [ Html.text (config.title |> Maybe.withDefault "") ]
            , Html.div [ style ]
                (config.text |> List.map (\str -> Text.bodyTextSmall |> Text.withHtmlTag Html.p |> Text.view [ css [ marginBottom (rem 1) ] ] [ Html.text str ]))
            , if config.open then
                children

              else
                Nordea.Html.nothing
            , if charCount config.text > 345 then
                FlatLink.mini
                    |> FlatLink.view
                        [ css [ marginTop (rem 0.5) ]
                        , onMouseDownSelect OpenText
                        ]
                        iconButton

              else
                Nordea.Html.nothing
            ]
        ]


infoLabelContainerStyle : Attribute msg
infoLabelContainerStyle =
    css
        [ displayFlex
        , flexDirection row
        , padding (rem 0.75)
        , borderRadius (rem 0.5)
        , maxWidth fitContent
        ]


onMouseDownSelect : msg -> Html.Attribute msg
onMouseDownSelect msg =
    Events.custom "mousedown" (Decode.succeed { message = msg, stopPropagation = True, preventDefault = True })


strings : { readMore : Translation, close : Translation }
strings =
    { readMore =
        { no = "Les mer"
        , se = "Läs mer"
        , dk = "Læs mere"
        , en = "Read more"
        }
    , close =
        { no = "Lukk"
        , se = "Stänga"
        , dk = "Tæt"
        , en = "Close"
        }
    }


charCount : List String -> Int
charCount list =
    List.map String.length list |> List.foldl (+) 0
