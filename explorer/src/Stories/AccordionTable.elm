module Stories.AccordionTable exposing (stories)

import Config exposing (Config, Msg)
import Css exposing (color, marginLeft, marginTop, maxWidth, px, rem)
import Html.Styled exposing (div, text)
import Html.Styled.Attributes exposing (attribute, css)
import Json.Encode as Encode
import Nordea.Components.AccordionTableHeader as Header
import Nordea.Components.AccordionTableRow as Row
import Nordea.Components.Checkbox as Checkbox
import Nordea.Components.Text as Text
import Nordea.Css exposing (displayGrid, gap2, gridColumn, gridTemplateColumns)
import Nordea.Html exposing (nothing)
import Nordea.Resources.Colors as Colors
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
                        |> Header.view [] [ Text.textLight |> Text.view [] [ text "Table header" ] ]
                    , Row.init (Set.member 0 config.customModel.openAccordionTableRows) (Config.AccordionTableRowToggled 0)
                        |> Row.withSummary [] [ Text.textLight |> Text.view [] [ text "Some summary" ] ]
                        |> Row.withDetails [] [ Text.textLight |> Text.view [] [ text "Details" ] ]
                        |> Row.view []
                    , Row.init (Set.member 1 config.customModel.openAccordionTableRows) (Config.AccordionTableRowToggled 1)
                        |> Row.withSummary [] [ Text.textLight |> Text.view [] [ text "Some other summary" ] ]
                        |> Row.withDetails [] [ Text.textLight |> Text.view [] [ text "More details" ] ]
                        |> Row.view []
                    ]
          , {}
          )
        , ( "Multiple columns"
          , \config ->
                let
                    isOpen index =
                        Set.member index config.customModel.openAccordionTableRows
                in
                div [ css [ displayGrid, gridTemplateColumns "repeat(3, 1fr) auto", maxWidth (px 800) ] ]
                    [ Header.init
                        |> Header.view [] [ Text.textLight |> Text.view [] [ text "People" ] ]
                    , div [ css [ color Colors.nordeaGray, marginTop (rem 1), displayGrid, gridTemplateColumns "subgrid", gridColumn "1/-1" ] ]
                        [ Text.textLight |> Text.view [ css [ marginLeft (rem 1) ] ] [ text "Name" ]
                        , Text.textLight |> Text.view [] [ text "Occupation" ]
                        , Text.textLight |> Text.view [] [ text "Age" ]
                        ]
                    , Row.init (isOpen 0) (Config.AccordionTableRowToggled 0)
                        |> Row.withSummary []
                            [ Text.textLight |> Text.view [] [ text "Johnny" ]
                            , Text.textLight |> Text.view [] [ text "Carpenter" ]
                            , Text.textLight |> Text.view [] [ text "34" ]
                            ]
                        |> Row.withDetails [] [ Text.textLight |> Text.view [] [ text "Details about Johnny" ] ]
                        |> Row.view []
                    , Row.init (isOpen 1) (Config.AccordionTableRowToggled 1)
                        |> Row.withSummary []
                            [ Text.textLight |> Text.view [] [ text "Maximilian" ]
                            , Text.textLight |> Text.view [] [ text "Musician" ]
                            , Text.textLight |> Text.view [] [ text "23" ]
                            ]
                        |> Row.withDetails [] [ Text.textLight |> Text.view [] [ text "Details about Maximilian" ] ]
                        |> Row.view []
                    ]
          , {}
          )
        , ( "Selectable rows"
          , \config ->
                let
                    isOpen index =
                        Set.member index config.customModel.openAccordionTableRows

                    isSelected index =
                        Set.member index config.customModel.selectedAccordionTableRows

                    allSelected =
                        List.all isSelected [ 0, 1 ]

                    toAriaSelected selected =
                        attribute "aria-selected" <| (Encode.bool selected |> Encode.encode 0)
                in
                div [ css [ displayGrid, gridTemplateColumns "1fr auto auto", gap2 (rem 0) (rem 1), maxWidth (px 800) ] ]
                    [ Header.init
                        |> Header.view
                            [ css [ displayGrid, gridTemplateColumns "subgrid", gridColumn "1/-1" ], toAriaSelected allSelected ]
                            [ Text.textLight |> Text.view [] [ text "Selectable rows" ]
                            , Checkbox.init "selectable-rows" nothing (\checked -> Config.AccordionTableAllRowsChecked checked)
                                |> Checkbox.withAppearance Checkbox.Simple
                                |> Checkbox.withIsChecked allSelected
                                |> Checkbox.view []
                            ]
                    , Row.init (isOpen 0) (Config.AccordionTableRowToggled 0)
                        |> Row.withSummary []
                            [ Text.textLight |> Text.view [] [ text "Some summary" ]
                            , Checkbox.init "selectable-rows" nothing (\checked -> Config.AccordionTableRowChecked 0 checked)
                                |> Checkbox.withAppearance Checkbox.Simple
                                |> Checkbox.withIsChecked (isSelected 0)
                                |> Checkbox.view [ toAriaSelected (isSelected 0) ]
                            ]
                        |> Row.withDetails [] [ Text.textLight |> Text.view [] [ text "Details" ] ]
                        |> Row.view []
                    , Row.init (isOpen 1) (Config.AccordionTableRowToggled 1)
                        |> Row.withSummary []
                            [ Text.textLight |> Text.view [] [ text "Some other summary" ]
                            , Checkbox.init "selectable-rows" nothing (\checked -> Config.AccordionTableRowChecked 1 checked)
                                |> Checkbox.withAppearance Checkbox.Simple
                                |> Checkbox.withIsChecked (isSelected 1)
                                |> Checkbox.view [ toAriaSelected (isSelected 1) ]
                            ]
                        |> Row.withDetails [] [ Text.textLight |> Text.view [] [ text "More details" ] ]
                        |> Row.view []
                    ]
          , {}
          )
        , ( "Small"
          , \config ->
                div [ css [ displayGrid, gridTemplateColumns "1fr auto", maxWidth (px 600) ] ]
                    [ Header.init
                        |> Header.withSmallSize
                        |> Header.view [] [ Text.textSmallLight |> Text.view [] [ text "Table header" ] ]
                    , Row.init (Set.member 0 config.customModel.openAccordionTableRows) (Config.AccordionTableRowToggled 0)
                        |> Row.withSmallSize
                        |> Row.withSummary [] [ Text.textSmallLight |> Text.view [] [ text "Summary" ] ]
                        |> Row.withDetails [] [ Text.textSmallLight |> Text.view [] [ text "Details" ] ]
                        |> Row.view []
                    ]
          , {}
          )
        ]
