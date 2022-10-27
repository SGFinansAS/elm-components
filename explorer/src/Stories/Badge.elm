module Stories.Badge exposing (stories)

import Css exposing (displayFlex, rem, width)
import Html.Styled as Html
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
                Html.div [ css [ displayFlex ] ]
                    [ Html.text "It's a badge!"
                    , Badge.Number 4
                        |> Badge.view [] [ Icons.pdf [ css [ width (rem 5) |> Css.important ] ] ]
                    ]
          , {}
          )
        , ( "Not showing"
          , \_ ->
                Html.div [ css [ displayFlex ] ]
                    [ Badge.Number 0
                        |> Badge.view [] [ Icons.pdf [ css [ width (rem 5) |> Css.important ] ] ]
                    ]
          , {}
          )
        , ( "Generic"
          , \_ ->
                Html.div [ css [ displayFlex ] ]
                    [ Badge.Generic
                        |> Badge.view [] [ Icons.pdf [ css [ width (rem 5) |> Css.important ] ] ]
                    ]
          , {}
          )
        ]
