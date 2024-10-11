module Stories.Card exposing (stories)

import Config exposing (Config, Msg(..))
import Css exposing (alignItems, center, displayFlex, marginBottom, rem, width)
import Html.Styled as Html
import Html.Styled.Attributes exposing (css)
import Nordea.Components.Card as Card
import Nordea.Css exposing (gap)
import Nordea.Html as Html
import Nordea.Resources.Icons as Icons
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI Config Msg {}
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
        , ( "With custom header content"
          , \_ ->
                Card.init
                    |> Card.withShadow
                    |> Card.view []
                        [ Card.header []
                            [ Card.title [] [ Html.text "Card title" ]
                            , Html.text "Custom header content"
                            ]
                        , Html.text "Card content"
                        ]
          , {}
          )
        , ( "With footer"
          , \_ ->
                Card.init
                    |> Card.withTitle "Card title"
                    |> Card.withShadow
                    |> Card.view []
                        [ Html.text "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
                        , Card.footer [] [ Html.text "Some footer content" ]
                        ]
          , {}
          )
        , ( "With title and infobox"
          , \_ ->
                Card.init
                    |> Card.withTitle "Card title"
                    |> Card.withShadow
                    |> Card.view []
                        [ Card.infoBox [ css [ gap (rem 1) ] ]
                            [ Html.row [ css [ alignItems center, gap (rem 0.5) ] ]
                                [ Icons.filledCheckmark [ css [ width (rem 1.5) ] ]
                                , Html.text "Some completed task"
                                ]
                            , Html.row [ css [ alignItems center, gap (rem 0.5) ] ]
                                [ Icons.unfilledMark [ css [ width (rem 1.5) ] ]
                                , Html.text "Some not completed task"
                                ]
                            ]
                        ]
          , {}
          )
        , ( "Collapsible with string title"
          , \model ->
                Card.init
                    |> Card.withTitle "Title"
                    |> Card.isCollapsible (Just { emphasisedText = Html.nothing, isOpen = model.customModel.isCardOpen, onClick = ToggleOpenCard })
                    |> Card.withShadow
                    |> Card.view []
                        [ Card.infoBox [ css [ gap (rem 1) ] ]
                            [ Html.row [ css [ alignItems center, gap (rem 0.5) ] ]
                                [ Icons.filledCheckmark [ css [ width (rem 1.5) ] ]
                                , Html.text "Some completed task"
                                ]
                            , Html.row [ css [ alignItems center, gap (rem 0.5) ] ]
                                [ Icons.unfilledMark [ css [ width (rem 1.5) ] ]
                                , Html.text "Some not completed task"
                                ]
                            ]
                        ]
          , {}
          )
        , ( "Collapsible with html title"
          , \model ->
                Card.init
                    |> Card.withHtmlTitle (Html.div [ css [ displayFlex, gap (rem 1), alignItems center ] ] [ Icons.user [ css [ width (rem 1.5) ] ], Html.text "Title with icon" ])
                    |> Card.isCollapsible (Just { emphasisedText = Html.nothing, isOpen = model.customModel.isCardOpen, onClick = ToggleOpenCard })
                    |> Card.withShadow
                    |> Card.view []
                        [ Card.infoBox [ css [ gap (rem 1) ] ]
                            [ Html.row [ css [ alignItems center, gap (rem 0.5) ] ]
                                [ Icons.filledCheckmark [ css [ width (rem 1.5) ] ]
                                , Html.text "Some completed task"
                                ]
                            , Html.row [ css [ alignItems center, gap (rem 0.5) ] ]
                                [ Icons.unfilledMark [ css [ width (rem 1.5) ] ]
                                , Html.text "Some not completed task"
                                ]
                            ]
                        ]
          , {}
          )
        ]
