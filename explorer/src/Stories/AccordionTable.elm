module Stories.AccordionTable exposing (stories)

import Config exposing (Config, Msg)
import Css exposing (marginBottom, marginLeft, maxWidth, px, rem)
import Html.Styled exposing (div, text)
import Html.Styled.Attributes exposing (css)
import Nordea.Components.AccordionTableHeader as Header
import Nordea.Components.AccordionTableRow as Row
import Nordea.Components.Text as Text
import Nordea.Css exposing (displayGrid, gridColumn, gridTemplateColumns)
import Set
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI Config Msg {}
stories =
    styledStoriesOf
        "AccordionTable"
        [ ( "Default"
          , \config ->
                div [ css [ displayGrid, gridTemplateColumns "1fr auto", maxWidth (px 800) ] ]
                    [ Header.init
                        |> Header.view
                            [ css [ gridColumn "1/-1" ] ]
                            [ Text.bodyTextLight |> Text.view [] [ text "Table header" ] ]
                    , Row.init (Set.member 0 config.customModel.openAccordionTableRows) (Config.AccordionTableMsg 0)
                        |> Row.withSummary [] [ Text.textLight |> Text.view [] [ text "Summary" ] ]
                        |> Row.withDetails [] [ Text.bodyTextLight |> Text.view [] [ text "Details" ] ]
                        |> Row.view []
                    , Row.init (Set.member 1 config.customModel.openAccordionTableRows) (Config.AccordionTableMsg 1)
                        |> Row.withSummary [] [ Text.textLight |> Text.view [] [ text "Summary 2" ] ]
                        |> Row.withDetails [] [ Text.bodyTextLight |> Text.view [] [ text "Details 2" ] ]
                        |> Row.view []
                    ]
          , {}
          )
        , ( "Multiple columns"
          , \config ->
                div [ css [ displayGrid, gridTemplateColumns "repeat(3, 1fr) auto", maxWidth (px 800) ] ]
                    [ Header.init
                        |> Header.view
                            [ css [ marginBottom (rem 1) ] ]
                            [ Text.bodyTextLight |> Text.view [] [ text "Table header" ] ]
                    , Text.textLight |> Text.view [ css [ marginLeft (rem 1) ] ] [ text "Name" ]
                    , Text.textLight |> Text.view [] [ text "Occupation" ]
                    , Text.textLight |> Text.view [] [ text "Age" ]
                    , Row.init (Set.member 0 config.customModel.openAccordionTableRows) (Config.AccordionTableMsg 0)
                        |> Row.withSummary []
                            [ Text.textLight |> Text.view [] [ text "Johnny" ]
                            , Text.textLight |> Text.view [] [ text "Carpenter" ]
                            , Text.textLight |> Text.view [] [ text "34" ]
                            ]
                        |> Row.withDetails [] [ Text.bodyTextLight |> Text.view [] [ text "Details" ] ]
                        |> Row.view []
                    , Row.init (Set.member 1 config.customModel.openAccordionTableRows) (Config.AccordionTableMsg 1)
                        |> Row.withSummary []
                            [ Text.textLight |> Text.view [] [ text "Maximilian" ]
                            , Text.textLight |> Text.view [] [ text "Musician" ]
                            , Text.textLight |> Text.view [] [ text "23" ]
                            ]
                        |> Row.withDetails [] [ Text.bodyTextLight |> Text.view [] [ text "Details 2" ] ]
                        |> Row.view []
                    ]
          , {}
          )
        , ( "Small"
          , \config ->
                div [ css [ displayGrid, gridTemplateColumns "1fr auto", maxWidth (px 600) ] ]
                    [ Header.init
                        |> Header.withSmallSize
                        |> Header.view
                            [ css [ gridColumn "1/-1" ] ]
                            [ Text.bodyTextSmall |> Text.view [] [ text "Table header" ] ]
                    , Row.init (Set.member 0 config.customModel.openAccordionTableRows) (Config.AccordionTableMsg 0)
                        |> Row.withSmallSize
                        |> Row.withSummary [] [ Text.textSmallLight |> Text.view [] [ text "Summary" ] ]
                        |> Row.withDetails [] [ Text.bodyTextSmall |> Text.view [] [ text "Details" ] ]
                        |> Row.view []
                    ]
          , {}
          )
        ]
