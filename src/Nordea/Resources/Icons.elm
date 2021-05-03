module Nordea.Resources.Icons exposing (check, info, leftIcon, rightIcon)

import Css exposing (displayFlex, marginLeft, marginRight, rem)
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes exposing (css)
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



-- Icon Wrappers


leftIcon : Html msg -> Html msg
leftIcon icon =
    Html.div [ css [ displayFlex, marginRight (rem 0.28125) ] ]
        [ icon
        ]


rightIcon : Html msg -> Html msg
rightIcon icon =
    Html.div [ css [ displayFlex, marginLeft (rem 0.28125) ] ]
        [ icon
        ]



-- Inline SVG Icons


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


info : Svg msg
info =
    svg [ width "1em", height "1em", viewBox "0 0 18 18", fill "none" ]
        [ Svg.path
            [ fillRule "evenodd"
            , clipRule "evenodd"
            , d "M18 9C18 4.02944 13.9706 0 9 0C4.02944 0 0 4.02944 0 9C0 13.9706 4.02944 18 9 18C13.9706 18 18 13.9706 18 9ZM14.3033 14.3033C12.8968 15.7098 10.9891 16.5 9 16.5C4.85786 16.5 1.5 13.1421 1.5 9C1.5 4.85786 4.85786 1.5 9 1.5C13.1421 1.5 16.5 4.85786 16.5 9C16.5 10.9891 15.7098 12.8968 14.3033 14.3033ZM10.5 12C10.9142 12 11.25 12.3358 11.25 12.75C11.25 13.1642 10.9142 13.5 10.5 13.5H7.5C7.08579 13.5 6.75 13.1642 6.75 12.75C6.75 12.3358 7.08579 12 7.5 12H8.25V9H7.5C7.08579 9 6.75 8.66421 6.75 8.25C6.75 7.83579 7.08579 7.5 7.5 7.5H9.75V12H10.5ZM8.7075 6.2625C9.32882 6.2625 9.8325 5.75882 9.8325 5.1375C9.8325 4.51618 9.32882 4.0125 8.7075 4.0125C8.08618 4.0125 7.5825 4.51618 7.5825 5.1375C7.5825 5.75882 8.08618 6.2625 8.7075 6.2625Z"
            , fill "currentColor"
            ]
            []
        ]
