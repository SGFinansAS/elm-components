module Stories.Tooltip exposing (stories)

import Html.Styled exposing (div, text)
import Nordea.Components.Card as Card exposing (Card(..))
import Nordea.Components.Tooltip as Tooltip exposing (Placement(..))
import Nordea.Resources.Colors as Colors
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
