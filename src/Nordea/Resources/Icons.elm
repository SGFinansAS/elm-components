module Nordea.Resources.Icons exposing (check)

import Svg.Styled as Svg exposing (Svg, svg)
import Svg.Styled.Attributes
    exposing
        ( clipRule
        , d
        , fill
        , fillRule
        , height
        , viewBox
        , width
        )


check : Svg msg
check =
    svg
        [ width "1em", height "1em", viewBox "0 0 16 12" ]
        [ Svg.path
            [ fillRule "evenodd"
            , clipRule "evenodd"
            , d "M15.8284 1.41421L14.4142 0L5.91421 8.5L1.41421 4L0 5.41421L4.5 9.91421L4.48531 9.92891L5.89952 11.3431L15.8284 1.41421Z"
            , fill "currentColor"
            ]
            []
        ]
