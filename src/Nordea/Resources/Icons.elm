module Nordea.Resources.Icons exposing
    ( check
    , chevronDown
    , chevronDownFilled
    , chevronUp
    , error
    , info
    , leftIcon
    , rightIcon
    , spinner
    )

import Css
    exposing
        ( alignItems
        , animationDuration
        , animationName
        , center
        , display
        , displayFlex
        , flex
        , flexShrink
        , inlineFlex
        , int
        , marginLeft
        , marginRight
        , ms
        , rem
        , zero
        )
import Css.Animations as Animations exposing (keyframes)
import Css.Global exposing (children, everything)
import Html.Styled as Html exposing (Attribute, Html, div, styled)
import Html.Styled.Attributes exposing (css)
import Nordea.Resources.Colors as Colors
import Svg.Styled as Svg exposing (Svg, rect, svg)
import Svg.Styled.Attributes as SvgAttrs exposing (clipRule, cx, cy, d, fill, fillRule, height, r, rx, stroke, strokeWidth, viewBox, width)



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


chevronUp : List (Attribute msg) -> Html msg
chevronUp attrs =
    iconContainer (css [ Css.width (rem 1) ] :: attrs)
        [ svg [ viewBox "0 0 20 20", fill "none" ]
            [ Svg.path
                [ d "M16 13L10 7L4 13"
                , stroke "currentColor"
                , strokeWidth "2"
                ]
                []
            ]
        ]


chevronDown : List (Attribute msg) -> Html msg
chevronDown attrs =
    iconContainer (css [ Css.width (rem 1) ] :: attrs)
        [ svg [ viewBox "0 0 20 20", fill "none" ]
            [ Svg.path
                [ d "M4 7L10 13L16 7"
                , stroke "currentColor"
                , strokeWidth "2"
                ]
                []
            ]
        ]


chevronDownFilled : List (Attribute msg) -> Html msg
chevronDownFilled attrs =
    iconContainer (css [ Css.width (rem 2) ] :: attrs)
        [ svg [ viewBox "0 0 30 30", fill "none" ]
            [ rect [ width "30", height "30", rx "2", fill "currentColor" ] []
            , Svg.path
                [ fillRule "evenodd"
                , clipRule "evenodd"
                , d "M20.5303 13.5304L14.9999 19.0607L9.46961 13.5304L10.5303 12.4697L14.9999 16.9391L19.4696 12.4697L20.5303 13.5304Z"
                , fill (Colors.toString Colors.grayEclipse)
                ]
                []
            ]
        ]


spinner : List (Attribute msg) -> Html msg
spinner attrs =
    iconContainer
        attrs
        [ Svg.svg
            [ fill "none"
            , viewBox "0 0 20 20"
            , SvgAttrs.css
                [ Css.property "animation-iteration-count" "infinite"
                , Css.property "animation-timing-function" "linear"
                , Css.property "transform-origin" "center"
                , animationDuration (ms 1000)
                , animationName
                    (keyframes
                        [ ( 0, [ Animations.transform [ Css.rotateZ (Css.deg 0) ] ] )
                        , ( 100, [ Animations.transform [ Css.rotateZ (Css.deg 360) ] ] )
                        ]
                    )
                ]
            ]
            [ Svg.circle
                [ cx "10"
                , cy "10"
                , r "9"
                , strokeWidth "2"
                , stroke "currentColor"
                , SvgAttrs.css
                    [ Css.property "stroke-dasharray" "56px"
                    , Css.property "animation-iteration-count" "infinite"
                    , animationDuration (ms 4000)
                    , animationName
                        (keyframes
                            [ ( 0, [ Animations.property "stroke-dashoffset" "112" ] )
                            , ( 100, [ Animations.property "stroke-dashoffset" "0" ] )
                            ]
                        )
                    ]
                ]
                []
            ]
        ]


error : List (Attribute msg) -> Html msg
error attrs =
    iconContainer (css [ Css.width (rem 1) ] :: attrs)
        [ Svg.svg [ viewBox "0 0 16 16", fill "none" ]
            [ Svg.path
                [ fillRule "evenodd"
                , clipRule "evenodd"
                , d "M15 8C15 4.14 11.859 1 8 1C4.14 1 1 4.14 1 8C1 11.86 4.14 15 8 15C11.859 15 15 11.86 15 8ZM0 8C0 3.589 3.589 0 8 0C12.411 0 16 3.589 16 8C16 12.411 12.411 16 8 16C3.589 16 0 12.411 0 8ZM9.0064 11.9283C9.0064 12.4373 8.5944 12.8493 8.0864 12.8493C7.5784 12.8493 7.1664 12.4373 7.1664 11.9283C7.1664 11.4203 7.5784 11.0083 8.0864 11.0083C8.5944 11.0083 9.0064 11.4203 9.0064 11.9283ZM8.5 3C8.5 2.72386 8.27614 2.5 8 2.5C7.72386 2.5 7.5 2.72386 7.5 3L7.5 9C7.5 9.27614 7.72386 9.5 8 9.5C8.27614 9.5 8.5 9.27614 8.5 9V3Z"
                , fill "currentColor"
                ]
                []
            ]
        ]


iconContainer : List (Attribute msg) -> List (Html msg) -> Html msg
iconContainer =
    styled div
        [ display inlineFlex
        , alignItems center
        , children [ everything [ flex (int 1) ] ]
        , flexShrink zero
        ]
