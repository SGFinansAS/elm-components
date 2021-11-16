module Nordea.Components.Card exposing (..)

import Css exposing (Style, auto, backgroundColor, border3, borderRadius, borderStyle, fontSize, height, left, margin, none, padding4, rem, solid, textAlign, width)
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes exposing (css)
import Nordea.Html exposing (styleIf)
import Nordea.Resources.Colors as Colors


type alias CardProperties =
    { title : String
    , hasShadow : Bool
    }


type Card msg
    = Card CardProperties


init : String -> Card msg
init title =
    Card
        { title = title
        , hasShadow = False
        }


view : List (Html msg) -> Card msg -> Html msg
view children (Card config) =
    let
        cardStyle =
            [ borderRadius (rem 0.5)
            , backgroundColor Colors.white
            , Css.boxShadow4 (rem 0) (rem 0.25) (rem 2.5) Colors.grayLight
                |> styleIf config.hasShadow
            ]
    in
    Html.div
        [ css
            cardStyle
        ]
        [ cardTitle config.title
        , separationLine
        , cardContentContainer
            children
        ]


cardTitle : String -> Html msg
cardTitle title =
    Html.div
        [ css
            [ cardPadding
            , fontSize (rem 1.125)
            ]
        ]
        [ Html.text title
        ]


cardContentContainer : List (Html msg) -> Html msg
cardContentContainer children =
    Html.div
        [ css
            [ cardPadding
            , textAlign left
            ]
        ]
        children


separationLine : Html msg
separationLine =
    Html.hr
        [ css
            [ width auto
            , borderStyle none
            , height (rem 0.0625)
            , backgroundColor Colors.grayCool
            , margin (rem 0)
            ]
        ]
        []


cardPadding : Style
cardPadding =
    padding4 (rem 2) (rem 2) (rem 1) (rem 2)


withShadow : Card msg -> Card msg
withShadow (Card config) =
    Card { config | hasShadow = True }
