module Nordea.Components.Tooltip exposing (..)

import Css exposing (Style, animationDuration, animationName, deg, int, ms, opacity, pct, rem, zero)
import Css.Animations as Animations exposing (keyframes)
import Css.Global as Css
import Css.Transitions exposing (transition)
import Html.Styled exposing (Html, div, span, styled)
import Html.Styled.Attributes as Attr
import Nordea.Resources.Colors as Colors


type Placement
    = Top
    | Bottom
    | Left
    | Right


type Visibility
    = Always
    | DurationMs Float


type alias Config msg =
    { placement : Placement
    , content : List (Html msg)
    , visibility : Visibility
    }


type Tooltip msg
    = Tooltip (Config msg)


init : Tooltip msg
init =
    Tooltip
        { placement = Top
        , content = []
        , visibility = Always
        }


withPlacement : Placement -> Tooltip msg -> Tooltip msg
withPlacement placement (Tooltip config) =
    Tooltip { config | placement = placement }


withContent : List (Html msg) -> Tooltip msg -> Tooltip msg
withContent content (Tooltip config) =
    Tooltip { config | content = content }


withVisibility : Visibility -> Tooltip msg -> Tooltip msg
withVisibility visibility (Tooltip config) =
    Tooltip { config | visibility = visibility }


view : List (Html msg) -> Tooltip msg -> Html msg
view children (Tooltip config) =
    let
        animation =
            keyframes
                [ ( 0, [ Animations.opacity (int 1) ] )
                , ( 10, [ Animations.opacity (int 1) ] )
                , ( 90, [ Animations.opacity (int 1) ] )
                , ( 100, [ Animations.opacity (int 0) ] )
                ]
    in
    styled span
        [ Css.position Css.relative
        , Css.hover
            [ Css.descendants
                [ Css.class "tooltip"
                    [ case config.visibility of
                        DurationMs duration ->
                            Css.batch
                                [ opacity (int 0)
                                , animationName animation
                                , animationDuration (ms duration)
                                ]

                        Always ->
                            Css.opacity (int 1)
                    ]
                ]
            ]
        ]
        []
        (children
            ++ [ styled div
                    [ Css.position Css.absolute
                    , Css.backgroundColor Colors.grayDarkest
                    , Css.color Colors.white
                    , Css.padding2 (rem 0.5) (rem 1)
                    , Css.borderRadius (rem 0.5)
                    , Css.boxShadow4 zero (rem 0.0625) (rem 0.125) (Css.rgba 0 0 0 0.2)
                    , Css.property "width" "max-content"
                    , Css.maxWidth (rem 20)
                    , Css.pointerEvents Css.none
                    , Css.opacity zero
                    , transition [ Css.Transitions.opacity 150 ]
                    , tooltipContentStyle config.placement
                    , Css.before
                        [ Css.property "content" "' '"
                        , Css.width (rem 0.625)
                        , Css.height (rem 0.625)
                        , Css.backgroundColor Css.inherit
                        , Css.position Css.absolute
                        , arrowStyle config.placement
                        ]
                    ]
                    [ Attr.class "tooltip" ]
                    config.content
               ]
        )


tooltipContentStyle : Placement -> Style
tooltipContentStyle placement =
    case placement of
        Top ->
            Css.batch
                [ Css.top (rem -1)
                , Css.left (pct 50)
                , Css.transform (Css.translate2 (pct -50) (pct -100))
                ]

        Bottom ->
            Css.batch
                [ Css.bottom (rem -1)
                , Css.left (pct 50)
                , Css.transform (Css.translate2 (pct -50) (pct 100))
                ]

        Left ->
            Css.batch
                [ Css.left (rem -1)
                , Css.top (pct 50)
                , Css.transform (Css.translate2 (pct -100) (pct -50))
                ]

        Right ->
            Css.batch
                [ Css.right (rem -1)
                , Css.top (pct 50)
                , Css.transform (Css.translate2 (pct 100) (pct -50))
                ]


arrowStyle : Placement -> Style
arrowStyle placement =
    case placement of
        Top ->
            Css.batch
                [ Css.bottom (rem -0.3125)
                , Css.left (pct 50)
                , Css.transforms [ Css.translateX (pct -50), Css.rotate (deg 45) ]
                ]

        Bottom ->
            Css.batch
                [ Css.top (rem -0.3125)
                , Css.left (pct 50)
                , Css.transforms [ Css.translateX (pct -50), Css.rotate (deg 45) ]
                ]

        Left ->
            Css.batch
                [ Css.right (rem -0.3125)
                , Css.top (pct 50)
                , Css.transforms [ Css.translateY (pct -50), Css.rotate (deg 45) ]
                ]

        Right ->
            Css.batch
                [ Css.left (rem -0.3125)
                , Css.top (pct 50)
                , Css.transforms [ Css.translateY (pct -50), Css.rotate (deg 45) ]
                ]
