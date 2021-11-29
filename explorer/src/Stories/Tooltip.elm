module Stories.Tooltip exposing (stories)

import Nordea.Components.Tooltip as Tooltip exposing (Placement(..))
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)
import Html.Styled exposing (text, div)

stories : UI a b {}
stories =
    styledStoriesOf
        "Tooltip"
        [ ( "Top"
          , \_ -> div [] [ text "There is a tooltip ", Tooltip.init
                    |> Tooltip.withPlacement Top
                    |> Tooltip.withContent [ text "This is a tooltip" ]
                    |> Tooltip.view [ text "here" ]]
          , {}
          )
          ,( "Bottom"
          , \_ -> div [] [ text "There is a tooltip ", Tooltip.init
                    |> Tooltip.withPlacement Bottom
                    |> Tooltip.withContent [ text "This is a tooltip" ]
                    |> Tooltip.view [ text "here" ]]
          , {}
          ),
          ( "Left"
          , \_ -> div [] [ text "There is a tooltip ", Tooltip.init
                    |> Tooltip.withPlacement Left
                    |> Tooltip.withContent [ text "This is a tooltip" ]
                    |> Tooltip.view [ text "here" ]]
          , {}
          ),
          ( "Right"
          , \_ -> div [] [ text "There is a tooltip ", Tooltip.init
                    |> Tooltip.withPlacement Right
                    |> Tooltip.withContent [ text "This is a tooltip" ]
                    |> Tooltip.view [ text "here" ]]
          , {}
          )
        ]
