module Nordea.Components.InfoPanel exposing (InfoPanelContent, view, viewLabelInfoBlock)

import Css exposing (int, pseudoClass, rem)
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attributes
import Json.Decode exposing (index)
import Nordea.Components.Text as Text
import Nordea.Html exposing (attrIf, styleIf)
import Nordea.Resources.Colors as Colors


type alias InfoPanelContent =
    { label : String
    , info : String
    }


view : List InfoPanelContent -> Html msg
view panelInfoList =
    Html.dl
        [ Attributes.css
            [ Css.backgroundColor (Colors.coolGray |> Colors.withAlpha 0.5)
            , Css.boxSizing Css.borderBox
            , Css.borderRadius (rem 0.5)
            , Css.border3 (rem 0.0625) Css.solid Colors.mediumGray
            ]
        ]
        (panelInfoList |> List.indexedMap (\i panelInfo -> viewLabelInfoBlock panelInfo i))


viewLabelInfoBlock : InfoPanelContent -> Int -> Html msg
viewLabelInfoBlock infoPanelContent index =
    Html.div
        [ Attributes.css
            [ Css.padding2 (rem 0.75) (rem 0.5)
            , pseudoClass "not(:last-child)" [ Css.borderBottom3 (rem 0.0625) Css.solid Colors.mediumGray ]
            ]
        ]
        [ Text.textSmallLight |> Text.withHtmlTag Html.dt |> Text.view [] [ Html.text infoPanelContent.label ]
        , Text.bodyTextSmall
            |> Text.withHtmlTag Html.dd
            |> Text.view [ Attributes.css [ Css.fontWeight (int 500), Css.fontSize (rem 1.125) ] |> attrIf (index == 0) ]
                [ Html.text infoPanelContent.info ]
        ]
