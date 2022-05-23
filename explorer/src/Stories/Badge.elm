module Stories.Badge exposing (stories)

import Css exposing (rem, width)
import Html.Styled.Attributes exposing (css)
import Nordea.Components.Badge as Badge
import Nordea.Resources.Icons as Icons
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI a b {}
stories =
    styledStoriesOf
        "Badge"
        [ ( "Specific number"
          , \_ ->
                Badge.Number 4
                    |> Badge.view [] [ Icons.pdf [ css [ width (rem 5) |> Css.important ] ] ]
          , {}
          )
        , ( "Generic"
          , \_ ->
                Badge.Generic
                    |> Badge.view [] [ Icons.pdf [ css [ width (rem 5) |> Css.important ] ] ]
          , {}
          )
        ]
