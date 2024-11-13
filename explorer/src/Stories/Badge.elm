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
                    [ Badge.Number 4 Nothing
                        |> Badge.view [] [ Icons.pdf [ css [ width (rem 5) |> Css.important ] ] ]
                    ]
          , {}
          )
        , ( "Not showing"
          , \_ ->
                Html.div [ css [ displayFlex ] ]
                    [ Badge.Number 0 Nothing
                        |> Badge.view [] [ Icons.pdf [ css [ width (rem 5) |> Css.important ] ] ]
                    ]
          , {}
          )
        , ( "Specific number top placement"
          , \_ ->
                Html.div [ css [ displayFlex ] ]
                    [ Badge.NumberTopPlacement 4
                        |> Badge.view [] [ Icons.pdf [ css [ width (rem 5) |> Css.important ] ] ]
                    ]
          , {}
          )
        , ( "Number no icon"
          , \_ ->
                Html.div [ css [ displayFlex ] ]
                    [ Badge.Number 4 Nothing |> Badge.view [] [] ]
          , {}
          )
        , ( "Number with max char count"
          , \_ ->
                Html.div [ css [ displayFlex ] ]
                    [ Badge.Number 110 (Just 2) |> Badge.view [] [] ]
          , {}
          )
        , ( "Generic"
          , \_ ->
                Html.div [ css [ displayFlex ] ]
                    [ Badge.Generic
                        |> Badge.view [] [ Icons.calendar [ css [ width (rem 2) |> Css.important ] ] ]
                    ]
          , {}
          )
        , ( "Generic no icon"
          , \_ ->
                Html.div [ css [ displayFlex ] ]
                    [ Badge.Generic |> Badge.view [] [] ]
          , {}
          )
        ]
