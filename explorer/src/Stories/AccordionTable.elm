module Stories.AccordionTable exposing (stories)

import Config exposing (Config, Msg)
import Css exposing (color, marginBottom, marginLeft, maxWidth, px, rem)
import Html.Styled exposing (div, text)
import Html.Styled.Attributes exposing (css)
import Nordea.Components.AccordionTableHeader as AccordionTableHeader
import Nordea.Components.AccordionTableRow as AccordionTableRow
import Nordea.Components.Text as Text
import Nordea.Css exposing (displayGrid, gridColumn, gridTemplateColumns)
import Nordea.Resources.Colors as Colors
import Set exposing (Set)
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)



stories : UI Config Msg {}
stories =
    styledStoriesOf
        "AccordionTable"
        [ ( "Default"
          , \config ->
                div [ css [ displayGrid, gridTemplateColumns "1fr auto", maxWidth (px 800) ] ]
                    [ AccordionTableHeader.init
                        |> AccordionTableHeader.view
                            [ css [ gridColumn "1/-1" ] ]
                            [ Text.bodyTextLight |> Text.view [] [ text "Table header" ] ]
                    , AccordionTableRow.init (Set.member 0 config.customModel.openAccordionTableRows) (Config.AccordionTableMsg 0)
                        |> AccordionTableRow.withSummary [] [ Text.textLight |> Text.view [] [ text "Summary" ] ]
                        |> AccordionTableRow.withDetails [] [ Text.bodyTextLight |> Text.view [] [ text "Details" ] ]
                        |> AccordionTableRow.view []
                    , AccordionTableRow.init (Set.member 1 config.customModel.openAccordionTableRows) (Config.AccordionTableMsg 1)
                        |> AccordionTableRow.withSummary [] [ Text.textLight |> Text.view [] [ text "Summary 2" ] ]
                        |> AccordionTableRow.withDetails [] [ Text.bodyTextLight |> Text.view [] [ text "Details 2" ] ]
                        |> AccordionTableRow.view []
                    ]
          , {}
          )
        , ( "Multiple columns"
          , \config ->
                div [ css [ displayGrid, gridTemplateColumns "repeat(3, 1fr) auto", maxWidth (px 800) ] ]
                    [ AccordionTableHeader.init
                        |> AccordionTableHeader.view
                            [ css [ marginBottom (rem 1) ] ]
                            [ Text.bodyTextLight |> Text.view [] [ text "Table header" ] ]
                    , Text.textLight |> Text.view [ css [ marginLeft (rem 1) ] ] [ text "Name" ]
                    , Text.textLight |> Text.view [] [ text "Occupation" ]
                    , Text.textLight |> Text.view [] [ text "Age" ]
                    , AccordionTableRow.init (Set.member 0 config.customModel.openAccordionTableRows) (Config.AccordionTableMsg 0)
                        |> AccordionTableRow.withSummary []
                            [ Text.textLight |> Text.view [] [ text "Johnny" ]
                            , Text.textLight |> Text.view [] [ text "Carpenter" ]
                            , Text.textLight |> Text.view [] [ text "34" ]
                            ]
                        |> AccordionTableRow.withDetails [] [ Text.bodyTextLight |> Text.view [] [ text "Details" ] ]
                        |> AccordionTableRow.view []
                    , AccordionTableRow.init (Set.member 1 config.customModel.openAccordionTableRows) (Config.AccordionTableMsg 1)
                        |> AccordionTableRow.withSummary []
                            [ Text.textLight |> Text.view [] [ text "Maximilian" ]
                            , Text.textLight |> Text.view [] [ text "Musician" ]
                            , Text.textLight |> Text.view [] [ text "23" ]
                            ]
                        |> AccordionTableRow.withDetails [] [ Text.bodyTextLight |> Text.view [] [ text "Details 2" ] ]
                        |> AccordionTableRow.view []
                    ]
          , {}
          )
        , ( "Small"
          , \config ->
                div [ css [ displayGrid, gridTemplateColumns "1fr auto", maxWidth (px 600) ] ]
                    [ AccordionTableHeader.init
                        |> AccordionTableHeader.withSmallSize
                        |> AccordionTableHeader.view
                            [ css [ gridColumn "1/-1" ] ]
                            [ Text.bodyTextSmall |> Text.view [] [ text "Table header" ] ]
                    , AccordionTableRow.init (Set.member 0 config.customModel.openAccordionTableRows) (Config.AccordionTableMsg 0)
                        |> AccordionTableRow.withSmallSize
                        |> AccordionTableRow.withSummary [] [ Text.textSmallLight |> Text.view [] [ text "Summary" ] ]
                        |> AccordionTableRow.withDetails [] [ Text.bodyTextSmall |> Text.view [] [ text "Details" ] ]
                        |> AccordionTableRow.view []
                    ]
          , {}
          )
        ]
