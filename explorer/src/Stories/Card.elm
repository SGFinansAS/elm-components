module Stories.Card exposing (..)

import Css exposing (alignItems, center, rem, width)
import Html.Styled as Html
import Html.Styled.Attributes exposing (css)
import Nordea.Components.Card as Card
import Nordea.Html as Html
import Nordea.Resources.Icons as Icons
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI a b {}
stories =
    styledStoriesOf
        "Card"
        [ ( "Default"
          , \_ ->
                Card.init
                    |> Card.view [] [ Html.text "Card content" ]
          , {}
          )
        , ( "With shadow"
          , \_ ->
                Card.init
                    |> Card.withShadow
                    |> Card.view [] [ Html.text "Card content" ]
          , {}
          )
        , ( "With title"
          , \_ ->
                Card.init
                    |> Card.withTitle "Card title"
                    |> Card.withShadow
                    |> Card.view [] [ Html.text "Card content" ]
          , {}
          )
        , ( "With title and infobox"
          , \_ ->
                Card.init
                    |> Card.withTitle "Card title"
                    |> Card.withShadow
                    |> Card.view []
                        [ Card.infoBox [ css [ Css.property "gap" "1rem" ] ]
                            [ Html.row [ css [ alignItems center, Css.property "gap" "0.5rem" ] ]
                                [ Icons.filledCheckmark [ css [ width (rem 1.5) ] ]
                                , Html.text "Some completed task"
                                ]
                            , Html.row [ css [ alignItems center, Css.property "gap" "0.5rem" ] ]
                                [ Icons.unfilledMark [ css [ width (rem 1.5) ] ]
                                , Html.text "Some not completed task"
                                ]
                            ]
                        ]
          , {}
          )
        ]
