module Nordea.Components.FileDownload exposing
    ( FileDownload
    , Status(..)
    , init
    , view
    , withDownloadStatus
    )

import Css
    exposing
        ( alignItems
        , auto
        , border3
        , borderRadius
        , center
        , cursor
        , displayFlex
        , flexBasis
        , flexShrink
        , lineHeight
        , marginBottom
        , marginLeft
        , marginRight
        , middle
        , num
        , padding
        , pct
        , pointer
        , pseudoClass
        , rem
        , solid
        , textDecoration
        , underline
        , verticalAlign
        , width
        )
import Css.Global as Css exposing (children, everything)
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes exposing (css)
import Nordea.Components.Spinner as Spinner
import Nordea.Components.Text as Text
import Nordea.Html as Layout
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Icons as Icon
import Nordea.Themes as Themes


type alias Translation =
    { no : String, se : String, dk : String, en : String }


type alias Translate =
    Translation -> String


type FileDownload
    = FileDownload Config


type alias Config =
    { label : String
    , subtitle : String
    , translate : Translate
    , downloadStatus : Status
    }


type Status
    = NotAsked
    | Loading
    | Success


init : Translate -> String -> String -> FileDownload
init translate label subtitle =
    FileDownload
        { label = label
        , subtitle = subtitle
        , translate = translate
        , downloadStatus = NotAsked
        }


view : List (Attribute msg) -> FileDownload -> Html msg
view attrs (FileDownload config) =
    let
        downloadIconStatus =
            case config.downloadStatus of
                Success ->
                    Icon.downloaded [ css [ flexShrink (num 0), width (rem 1.1), marginLeft (rem 0.5) ] ]

                Loading ->
                    Spinner.custom [ css [ flexShrink (num 0), width (rem 0.875), marginLeft (rem 0.5) ] ]

                NotAsked ->
                    Icon.download [ css [ flexShrink (num 0), width (rem 0.875), marginLeft (rem 0.5) ] ]
    in
    Html.a
        (css
            [ displayFlex
            , alignItems center
            , borderRadius (rem 0.5)
            , border3 (rem 0.0625) solid Colors.mediumGray
            , padding (rem 1)
            , pseudoClass "not(:last-child)" [ marginBottom (rem 0.5) |> Css.important ]
            , flexBasis (pct 100)
            , cursor pointer
            ]
            :: attrs
        )
        [ Layout.column []
            [ Text.textLight
                |> Text.view [ css [ marginRight (rem 0.5), lineHeight (rem 1.5) ] ] [ Html.text config.label ]
            , Text.textTinyLight
                |> Text.view [ css [ marginRight (rem 0.5), lineHeight (rem 1.5) ] ] [ Html.text config.subtitle ]
            ]
        , Text.textSmallLight
            |> Text.view
                [ css
                    [ lineHeight (rem 1.5)
                    , Themes.color Colors.deepBlue
                    , textDecoration underline
                    , marginLeft auto
                    , children [ everything [ verticalAlign middle ] ]
                    ]
                ]
                [ Html.text (config.translate strings.download), downloadIconStatus ]
        ]


withDownloadStatus : Status -> FileDownload -> FileDownload
withDownloadStatus downloadStatus (FileDownload config) =
    FileDownload { config | downloadStatus = downloadStatus }


strings =
    { download =
        { no = "Last ned"
        , se = "Ladda ner"
        , dk = "Download"
        , en = "Download"
        }
    }
