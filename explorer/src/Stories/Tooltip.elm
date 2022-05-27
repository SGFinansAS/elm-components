module Stories.Tooltip exposing (stories)

import Css exposing (alignItems, center, displayFlex, marginLeft, rem)
import Html.Styled exposing (div, text)
import Html.Styled.Attributes exposing (css)
import Nordea.Components.Tooltip as Tooltip exposing (Placement(..))
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
        , ( "With icon dissapear 3s"
           , \_ ->
                div [ css [ displayFlex, alignItems center ] ]
                    [ text "There is a tooltip "
                    , Tooltip.init
                        |> Tooltip.withIsDissapear 3000
                        |> Tooltip.withPlacement Right
                        |> Tooltip.withContent [ text "This is a tooltip" ]
                        |> Tooltip.view [ Icons.questionMark [ css [ marginLeft (rem 0.25) ] ] ]
                    ]
          , {}
          )
        , ( "With icon dissapear 5s"
           , \_ ->
                 div [ css [ displayFlex, alignItems center ] ]
                     [ text "There is a tooltip "
                     , Tooltip.init
                         |> Tooltip.withIsDissapear 5000
                         |> Tooltip.withPlacement Right
                         |> Tooltip.withContent [ text "This is a tooltip" ]
                         |> Tooltip.view [ Icons.questionMark [ css [ marginLeft (rem 0.25) ] ] ]
                     ]
           , {}
           )
        ]
