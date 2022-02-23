module Stories.Table exposing (stories)

import Css
    exposing
        ( center
        , flex
        , int
        , rem
        , textAlign
        , width
        )
import Html.Styled as Html
import Html.Styled.Attributes exposing (css)
import Nordea.Components.Table as Table
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI a b {}
stories =
    styledStoriesOf
        "Table"
        [ ( "Default"
          , \_ ->
                Table.view [ css [ width (rem 60) ] ]
                    [ Table.thead []
                        [ Table.tr []
                            [ Table.th [ css [ flex (int 1) ] ] [ Html.text "Text" ]
                            , Table.th [ css [ flex (int 1) ] ] [ Html.text "Text" ]
                            , Table.th [ css [ flex (int 1) ] ] [ Html.text "Text" ]
                            , Table.th [ css [ flex (int 1) ] ] [ Html.text "Text" ]
                            , Table.th [ css [ flex (int 1) ] ] [ Html.text "Text" ]
                            ]
                        ]
                    , Table.tbody []
                        [ Table.tr []
                            [ Table.td [ css [ flex (int 1), textAlign center ] ] [ Html.text "Text" ]
                            , Table.td [ css [ flex (int 1), textAlign center ] ] [ Html.text "Text" ]
                            , Table.td [ css [ flex (int 1), textAlign center ] ] [ Html.text "Text" ]
                            , Table.td [ css [ flex (int 1), textAlign center ] ] [ Html.text "Text" ]
                            , Table.td [ css [ flex (int 1), textAlign center ] ] [ Html.text "Text" ]
                            ]
                        , Table.tr []
                            [ Table.td [ css [ flex (int 1), textAlign center ] ] [ Html.text "Text" ]
                            , Table.td [ css [ flex (int 1), textAlign center ] ] [ Html.text "Text" ]
                            , Table.td [ css [ flex (int 1), textAlign center ] ] [ Html.text "Text" ]
                            , Table.td [ css [ flex (int 1), textAlign center ] ] [ Html.text "Text" ]
                            , Table.td [ css [ flex (int 1), textAlign center ] ] [ Html.text "Text" ]
                            ]
                        , Table.tr []
                            [ Table.td [ css [ flex (int 1), textAlign center ] ] [ Html.text "Text" ]
                            , Table.td [ css [ flex (int 1), textAlign center ] ] [ Html.text "Text" ]
                            , Table.td [ css [ flex (int 1), textAlign center ] ] [ Html.text "Text" ]
                            , Table.td [ css [ flex (int 1), textAlign center ] ] [ Html.text "Text" ]
                            , Table.td [ css [ flex (int 1), textAlign center ] ] [ Html.text "Text" ]
                            ]
                        , Table.tr []
                            [ Table.td [ css [ flex (int 1), textAlign center ] ] [ Html.text "Text" ]
                            , Table.td [ css [ flex (int 1), textAlign center ] ] [ Html.text "Text" ]
                            , Table.td [ css [ flex (int 1), textAlign center ] ] [ Html.text "Text" ]
                            , Table.td [ css [ flex (int 1), textAlign center ] ] [ Html.text "Text" ]
                            , Table.td [ css [ flex (int 1), textAlign center ] ] [ Html.text "Text" ]
                            ]
                        ]
                    ]
          , {}
          )
        ]
