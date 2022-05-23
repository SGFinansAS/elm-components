module Stories.Tooltip exposing (stories)

import Config exposing (Config, Msg(..), TooltipMsg(..), TooltipState)
import Css exposing (alignItems, center, displayFlex, marginLeft, rem)
import Html.Styled as Html exposing (div, text)
import Html.Styled.Attributes as Attributes exposing (css)
import Html.Styled.Events as Events
import Nordea.Components.Card as Card exposing (Card(..))
import Nordea.Components.Tooltip as Tooltip exposing (Placement(..))
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Icons as Icons
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI Config Config.Msg {}
stories =
    styledStoriesOf
        "Tooltip"
        [ ( "Top"
          , \_ ->
                div []
                    [ text "There is a tooltip "
                    , Tooltip.init
                        |> Tooltip.withPlacement Top
                        |> Tooltip.withContent [ text "This is a tooltip" ]
                        |> Tooltip.view [ text "here" ]
                    ]
          , {}
          )
        , ( "Bottom"
          , \_ ->
                div []
                    [ text "There is a tooltip "
                    , Tooltip.init
                        |> Tooltip.withPlacement Bottom
                        |> Tooltip.withContent [ text "This is a tooltip" ]
                        |> Tooltip.view [ text "here" ]
                    ]
          , {}
          )
        , ( "Left"
          , \_ ->
                div []
                    [ text "There is a tooltip "
                    , Tooltip.init
                        |> Tooltip.withPlacement Left
                        |> Tooltip.withContent [ text "This is a tooltip" ]
                        |> Tooltip.view [ text "here" ]
                    ]
          , {}
          )
        , ( "Right"
          , \_ ->
                div []
                    [ text "There is a tooltip "
                    , Tooltip.init
                        |> Tooltip.withPlacement Right
                        |> Tooltip.withContent [ text "This is a tooltip" ]
                        |> Tooltip.view [ text "here" ]
                    ]
          , {}
          )
        , ( "With icon"
          , \_ ->
                div [ css [ displayFlex, alignItems center ] ]
                    [ text "There is a tooltip "
                    , Tooltip.init
                        |> Tooltip.withPlacement Right
                        |> Tooltip.withContent [ text "This is a tooltip" ]
                        |> Tooltip.view [ Icons.questionMark [ css [ marginLeft (rem 0.25) ] ] ]
                    ]
          , {}
          )
        , ( "Card"
          , \state ->
                div []
                    [ text "There is a tooltip "
                    , Tooltip.init
                        |> Tooltip.withPlacement Bottom
                        |> Tooltip.withArrowColor Colors.white
                        |> Tooltip.withOverrideShow state.customModel.tooltipState.cardIsOpen
                        |> Tooltip.withContent
                            [ Card.init
                                |> Card.withShadow
                                |> Card.view [ Attributes.css [ Css.maxHeight (Css.px 300), Css.overflowY Css.scroll, Css.maxWidth (Css.px 300) ] ] [ text "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum." ]
                            ]
                        |> Tooltip.view2 [ Icons.questionMark [ css [ marginLeft (rem 0.25), Css.cursor Css.pointer ], Events.onClick Toggle ] ]
                    ]
                    |> Html.map ToolTipMsg
          , {}
          )
        ]
