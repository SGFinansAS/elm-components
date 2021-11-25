module Nordea.Components.Card exposing (..)

import Css exposing (Style, backgroundColor, borderBottom3, borderRadius, column, displayFlex, flexDirection, fontSize, left, padding, padding4, rem, solid, textAlign)
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes exposing (css)
import Maybe.Extra as Maybe
import Nordea.Components.Text as Text
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


view : List (Attribute msg) -> List (Html msg) -> Card msg -> Html msg
view attrs children (Card config) =
    let
        cardStyle =
            [ displayFlex
            , flexDirection column
            , borderRadius (rem 0.5)
            , backgroundColor Colors.white
            , Css.boxShadow4 (rem 0) (rem 0.25) (rem 2.5) Colors.grayLight
                |> styleIf config.hasShadow
            ]
    in
    Html.div
        (css cardStyle
            :: attrs
        )
        [ config.title |> viewMaybe (\title -> cardTitle title)
        , cardContentContainer
            []
            (Maybe.isJust config.title)
            children
        ]


cardTitle : String -> Html msg
cardTitle title =
    Html.div
        [ css
            [ padding4 (rem 2) (rem 2) (rem 1) (rem 2)
            , fontSize (rem 1.125)
            , borderBottom3 (rem 0.0625) solid Colors.grayCool
            ]
        ]
        [ Text.bodyTextHeavy
            |> Text.view [] [ Html.text title ]
        ]


cardContentContainer : List (Attribute msg) -> Bool -> List (Html msg) -> Html msg
cardContentContainer attrs hasTitle children =
    Html.div
        (css
            [ if hasTitle then
                padding4 (rem 1) (rem 2) (rem 2) (rem 2)

              else
                padding (rem 2)
            , textAlign left
            ]
            :: attrs
        )
        children


withTitle : String -> Card msg -> Card msg
withTitle title (Card config) =
    Card { config | title = Just title }


withShadow : Card msg -> Card msg
withShadow (Card config) =
    Card { config | hasShadow = True }
