module Nordea.Components.Card exposing (..)

import Css exposing (Style, auto, backgroundColor, border3, borderBottom3, borderRadius, borderStyle, fontSize, height, left, margin, none, padding4, rem, solid, textAlign, width)
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes exposing (css)
import Nordea.Html exposing (styleIf, viewMaybe)
import Nordea.Resources.Colors as Colors


type alias CardProperties =
    { title : Maybe String
    , hasShadow : Bool
    }


type Card msg
    = Card CardProperties


init : Card msg
init =
    Card
        { title = Nothing
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
        [ config.title |> viewMaybe (\title -> cardTitle title)
        , cardContentContainer
            children
        ]


cardTitle : String -> Html msg
cardTitle title =
    Html.div
        [ css
            [ cardPadding
            , fontSize (rem 1.125)
            , borderBottom3 (rem 0.0625) solid Colors.grayCool
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


cardPadding : Style
cardPadding =
    padding4 (rem 2) (rem 2) (rem 1) (rem 2)


withTitle : String -> Card msg -> Card msg
withTitle title (Card config) =
    Card { config | title = Just title }


withShadow : Card msg -> Card msg
withShadow (Card config) =
    Card { config | hasShadow = True }
