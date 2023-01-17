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
        [ ( "Standard"
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
        , ( "Small"
          , \_ ->
                Table.view [ css [ width (rem 60) ] ]
                    [ Table.theadSmall []
                        [ Table.tr []
                            [ Table.th [ css [ flex (int 1) ] ] [ Html.text "Text" ]
                            , Table.th [ css [ flex (int 1) ] ] [ Html.text "Text" ]
                            , Table.th [ css [ flex (int 1) ] ] [ Html.text "Text" ]
                            , Table.th [ css [ flex (int 1) ] ] [ Html.text "Text" ]
                            , Table.th [ css [ flex (int 1) ] ] [ Html.text "Text" ]
                            ]
                        ]
                    , Table.tbodySmall []
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
        , ( "Extra Small"
          , \_ ->
                Table.view [ css [ width (rem 60) ] ]
                    [ Table.theadWithVariant []
                        [ Table.tr [] (List.repeat 5 (Table.th [ css [ flex (int 1) ] ] [ Html.text "Text" ]))
                        ]
                        Table.ExtraSmall
                    , Table.tbodyWithVariant []
                        (List.repeat 5 (Table.tr []
                            (List.repeat 5 (Table.td [ css [ flex (int 1), textAlign center ] ] [ Html.text "Text" ]))
                        ))
                        Table.ExtraSmall
                    ]
          , {}
          )
        ]
