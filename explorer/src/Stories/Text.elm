module Stories.Text exposing (stories)

import Css exposing (column, displayFlex, flexDirection, marginBottom, rem)
import Css.Global exposing (children, everything)
import Html.Styled as Html exposing (text)
import Html.Styled.Attributes exposing (css)
import Nordea.Components.Text as Text exposing (Variant(..))
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI a b {}
stories =
    styledStoriesOf
        "Text"
        [ ( "Headlines"
          , \_ ->
                Html.div [ css [ children [ everything [ marginBottom (rem 2) |> Css.important ] ] ] ]
                    [ Text.headlineOne
                        |> Text.view [] [ text "Headline one" ]
                    , Text.headlineOne
                        |> Text.withHtmlTag Html.p
                        |> Text.view [] [ text "Headline one as paragraph" ]
                    , Text.headlineTwo
                        |> Text.view [] [ text "Headline two" ]
                    , Text.headlineThree
                        |> Text.view [] [ text "Headline three" ]
                    , Text.headlineThree
                        |> Text.withHtmlTag Html.h1
                        |> Text.view [] [ text "Headline three as <h1>" ]
                    , Text.headlineFourLight
                        |> Text.view [] [ text "Headline four light" ]
                    , Text.headlineFourHeavy
                        |> Text.view [] [ text "Headline four heavy" ]
                    ]
          , {}
          )
        , ( "Title"
          , \_ ->
                Html.div [ css [ displayFlex, flexDirection column, children [ everything [ marginBottom (rem 1) ] ] ] ]
                    [ Text.titleLight
                        |> Text.view [] [ text "Title light" ]
                    , Text.titleLight
                        |> Text.withHtmlTag Html.h2
                        |> Text.view [] [ text "Title light as <h2>" ]
                    , Text.titleHeavy
                        |> Text.view [] [ text "Title heavy" ]
                    ]
          , {}
          )
        , ( "Bodytext"
          , \_ ->
                Html.div [ css [ displayFlex, flexDirection column, children [ everything [ marginBottom (rem 1) ] ] ] ]
                    [ Text.bodyTextLight
                        |> Text.view [] [ text "Bodytext light" ]
                    , Text.bodyTextHeavy
                        |> Text.view [] [ text "Bodytext heavy" ]
                    , Text.bodyTextSmall
                        |> Text.view [] [ text "Bodytext small" ]
                    ]
          , {}
          )
        , ( "Text"
          , \_ ->
                Html.div [ css [ displayFlex, flexDirection column, children [ everything [ marginBottom (rem 1) ] ] ] ]
                    [ Text.textLight
                        |> Text.view [] [ text "Text light" ]
                    , Text.textHeavy
                        |> Text.view [] [ text "Text heavy" ]
                    , Text.textSmallLight
                        |> Text.view [] [ text "Text small light" ]
                    , Text.textSmallHeavy
                        |> Text.view [] [ text "Text small heavy" ]
                    , Text.textTinyLight
                        |> Text.view [] [ text "Text tiny light" ]
                    , Text.textTinyHeavy
                        |> Text.view [] [ text "Text tiny heavy" ]
                    ]
          , {}
          )
        ]
