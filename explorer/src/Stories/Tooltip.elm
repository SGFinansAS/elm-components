module Stories.Tooltip exposing (stories)

import Nordea.Components.Tooltip as Tooltip exposing (Placement(..), Alignment(..))
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)
import Html.Styled exposing (text, div)

stories : UI a b {}
stories =
    styledStoriesOf
        "Tooltip"
        [ ( "Top"
          , \_ -> div [] [ text "This is a ", Tooltip.init
                    |> Tooltip.withPlacement Top
                    |> Tooltip.withContent [ text "That is a tooltip" ]
                    |> Tooltip.view [ text "tooltip" ]]
          , {}
          )
          ,( "Bottom"
          , \_ -> div [] [ text "This is a ", Tooltip.init
                    |> Tooltip.withPlacement Bottom
                    |> Tooltip.withContent [ text "That is a tooltip" ]
                    |> Tooltip.view [ text "tooltip" ]]
          , {}
          ),
          ( "Left"
          , \_ -> div [] [ text "This is a ", Tooltip.init
                    |> Tooltip.withPlacement Left
                    |> Tooltip.withContent [ text "That is a tooltip" ]
                    |> Tooltip.view [ text "tooltip" ]]
          , {}
          ),
          ( "Right"
          , \_ -> div [] [ text "This is a ", Tooltip.init
                    |> Tooltip.withPlacement Right
                    |> Tooltip.withContent [ text "That is a tooltip" ]
                    |> Tooltip.view [ text "tooltip" ]]
          , {}
          )
        ]
