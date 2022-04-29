module Nordea.Components.Card exposing (..)

import Css
    exposing
        ( auto
        , backgroundColor
        , border3
        , borderRadius
        , borderStyle
        , column
        , displayFlex
        , flexDirection
        , fontSize
        , height
        , left
        , margin2
        , none
        , padding
        , rem
        , solid
        , textAlign
        , width
        )
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes exposing (css)
import Nordea.Components.Text as Text
import Nordea.Html as Html exposing (styleIf, viewMaybe)
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


view : List (Attribute msg) -> List (Html msg) -> Card msg -> Html msg
view attrs children (Card config) =
    let
        cardStyle =
            [ borderRadius (rem 0.5)
            , padding (rem 1.5)
            , textAlign left
            , displayFlex
            , flexDirection column
            , backgroundColor Colors.white
            , Css.boxShadow4 (rem 0) (rem 0.25) (rem 2.5) Colors.grayLight
                |> styleIf config.hasShadow
            ]
    in
    Html.div
        (css cardStyle
            :: attrs
        )
        ((config.title |> viewMaybe (\title -> cardTitle title))
            :: children
        )


cardTitle : String -> Html msg
cardTitle title =
    Html.div
        [ css
            [ fontSize (rem 1.125)
            ]
        ]
        [ Text.bodyTextHeavy
            |> Text.view [] [ Html.text title ]
        , Html.hr
            [ css
                [ width auto
                , borderStyle none
                , height (rem 0.0625)
                , backgroundColor Colors.grayCool
                , margin2 (rem 1) (rem -1.5)
                ]
            ]
            []
        ]


infoBox : List (Attribute msg) -> List (Html msg) -> Html msg
infoBox attrs content =
    Html.column
        ([ css
            [ borderRadius (rem 0.5)
            , border3 (rem 0.0625) solid Colors.grayLight
            , padding (rem 1)
            ]
         ]
            ++ attrs
        )
        content


withTitle : String -> Card msg -> Card msg
withTitle title (Card config) =
    Card { config | title = Just title }


withShadow : Card msg -> Card msg
withShadow (Card config) =
    Card { config | hasShadow = True }
