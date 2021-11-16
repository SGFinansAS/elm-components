module Stories.Card exposing (..)

import Html.Styled as Html
import Nordea.Components.Card as Card
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI a b {}
stories =
    styledStoriesOf
        "Card"
        [ ( "Default"
          , \_ ->
                Card.init "Card title"
                    |> Card.view [ Html.text "Card content" ]
          , {}
          )
        , ( "With shadow"
          , \_ ->
                Card.init "Card title"
                    |> Card.withShadow
                    |> Card.view [ Html.text "Card content" ]
          , {}
          )
        ]
