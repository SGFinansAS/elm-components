module Stories.Table exposing (stories)

import Html.Styled as Html
import Nordea.Components.Table as Table
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI a b {}
stories =
    styledStoriesOf
        "Table"
        [ ( "Default"
          , \_ ->
                Table.view []
                    [ Table.thead []
                        [ Table.tr []
                            [ Table.th [] [ Html.text "Referansenummer" ]
                            , Table.th [] [ Html.text "Reg/serienummer" ]
                            , Table.th [] [ Html.text "Kundenavn" ]
                            , Table.th [] [ Html.text "Merke / Modell" ]
                            , Table.th [] [ Html.text "Status" ]
                            ]
                        ]
                    , Table.tbody []
                        [ Table.tr []
                            [ Table.td [] [ Html.text "1345937" ]
                            , Table.td [] [ Html.text "AB3377" ]
                            , Table.td [] [ Html.text "Davi Turbo AS" ]
                            , Table.td [] [ Html.text "Best BMW'en" ]
                            , Table.td [] [ Html.text "Innvilget" ]
                            ]
                        , Table.tr []
                            [ Table.td [] [ Html.text "1345937" ]
                            , Table.td [] [ Html.text "AB3377" ]
                            , Table.td [] [ Html.text "Davi Turbo AS" ]
                            , Table.td [] [ Html.text "Best BMW'en" ]
                            , Table.td [] [ Html.text "Innvilget" ]
                            ]
                        , Table.tr []
                            [ Table.td [] [ Html.text "1345937" ]
                            , Table.td [] [ Html.text "AB3377" ]
                            , Table.td [] [ Html.text "Davi Turbo AS" ]
                            , Table.td [] [ Html.text "Best BMW'en" ]
                            , Table.td [] [ Html.text "Innvilget" ]
                            ]
                        , Table.tr []
                            [ Table.td [] [ Html.text "1345937" ]
                            , Table.td [] [ Html.text "AB3377" ]
                            , Table.td [] [ Html.text "Davi Turbo AS" ]
                            , Table.td [] [ Html.text "Best BMW'en" ]
                            , Table.td [] [ Html.text "Innvilget" ]
                            ]
                        ]
                    ]
          , {}
          )
        ]
