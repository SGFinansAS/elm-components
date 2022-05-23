module Stories.Tooltip exposing (stories)

import Css exposing (alignItems, center, displayFlex, marginLeft, rem)
import Html.Styled exposing (div, text)
import Html.Styled.Attributes exposing (css)
import Nordea.Components.Card as Card exposing (Card(..))
import Nordea.Components.Tooltip as Tooltip exposing (Placement(..))
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Icons as Icons
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI a b {}
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
          , \_ ->
                div []
                    [ text "There is a tooltip "
                    , Tooltip.init
                        |> Tooltip.withPlacement Right
                        |> Tooltip.withArrowColor Colors.white
                        |> Tooltip.withOverrideShow True
                        |> Tooltip.withContent
                            [ Card.init
                                |> Card.withShadow
                                |> Card.view [] [ text "Card content" ]
                            ]
                        |> Tooltip.view2 [ text "here" ]
                    ]
          , {}
          )
        ]
