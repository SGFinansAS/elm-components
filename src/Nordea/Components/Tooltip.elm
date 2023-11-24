module Nordea.Components.Tooltip exposing
    ( ArrowPlacement(..)
    , Placement(..)
    , Tooltip
    , Visibility(..)
    , infoTooltip
    , init
    , view
    , withArrowPlacement
    , withContent
    , withPlacement
    , withVisibility
    )

import Css
    exposing
        ( absolute
        , active
        , animationDuration
        , animationName
        , backgroundColor
        , block
        , borderRadius
        , bottom
        , boxShadow4
        , color
        , column
        , deg
        , display
        , displayFlex
        , flexDirection
        , height
        , hover
        , inherit
        , inlineFlex
        , int
        , left
        , marginBottom
        , marginLeft
        , marginRight
        , marginTop
        , maxWidth
        , minWidth
        , ms
        , none
        , padding2
        , pct
        , position
        , pseudoClass
        , relative
        , rem
        , rgba
        , right
        , rotate
        , top
        , transform
        , transforms
        , translate2
        , translateX
        , translateY
        , width
        , zIndex
        , zero
        )
import Css.Animations as Animations exposing (keyframes)
import Css.Global exposing (class, descendants)
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attr exposing (css)
import Nordea.Html exposing (styleIf)
import Nordea.Resources.Colors as Colors


type Placement
    = Top
    | Bottom
    | Left
    | Right


type ArrowPlacement
    = Center
    | NearCorner
    | NearOtherCorner


type Visibility
    = OnHoverFocus
    | FadeOutMs Float
    | Show
    | Hidden


type alias Config msg =
    { placement : Placement
    , arrowDistanceFromCornerInPct : Float
    , content : (List (Attribute msg) -> Html msg) -> Html msg
    , visibility : Visibility
    }


type Tooltip msg
    = Tooltip (Config msg)


init : Tooltip msg
init =
    Tooltip
        { placement = Top
        , arrowDistanceFromCornerInPct = 50
        , content = \_ -> Html.text ""
        , visibility = OnHoverFocus
        }


withPlacement : Placement -> Tooltip msg -> Tooltip msg
withPlacement placement (Tooltip config) =
    Tooltip { config | placement = placement }


withArrowPlacement : ArrowPlacement -> Tooltip msg -> Tooltip msg
withArrowPlacement arrowPlacement (Tooltip config) =
    case arrowPlacement of
        NearCorner ->
            Tooltip { config | arrowDistanceFromCornerInPct = 15 }

        Center ->
            Tooltip { config | arrowDistanceFromCornerInPct = 50 }

        NearOtherCorner ->
            Tooltip { config | arrowDistanceFromCornerInPct = 85 }


withContent :
    ((List (Attribute msg) -> Html msg) -> Html msg)
    -> Tooltip msg
    -> Tooltip msg
withContent content (Tooltip config) =
    Tooltip { config | content = content }


withVisibility : Visibility -> Tooltip msg -> Tooltip msg
withVisibility visibility (Tooltip config) =
    Tooltip { config | visibility = visibility }


view : List (Attribute msg) -> List (Html msg) -> Tooltip msg -> Html msg
view attrs children (Tooltip config) =
    let
        arrow arrowAttrs =
            let
                arrowPosition =
                    case config.placement of
                        Top ->
                            Css.batch
                                [ bottom (rem -0.66)
                                , left (pct config.arrowDistanceFromCornerInPct)
                                , transforms [ translateX (pct -config.arrowDistanceFromCornerInPct), rotate (deg 180) ]
                                ]

                        Bottom ->
                            Css.batch
                                [ top (rem -0.66)
                                , left (pct config.arrowDistanceFromCornerInPct)
                                , transforms [ translateX (pct -config.arrowDistanceFromCornerInPct) ]
                                ]

                        Left ->
                            Css.batch
                                [ right (rem -0.66)
                                , top (pct config.arrowDistanceFromCornerInPct)
                                , transforms [ translateY (pct -config.arrowDistanceFromCornerInPct), rotate (deg 90) ]
                                ]

                        Right ->
                            Css.batch
                                [ left (rem -0.66)
                                , top (pct config.arrowDistanceFromCornerInPct)
                                , transforms [ translateY (pct -config.arrowDistanceFromCornerInPct), rotate (deg -90) ]
                                ]
            in
            Html.div
                (css
                    [ display block
                    , position absolute
                    , Css.property "clip-path" "polygon(50% 20%, 100% 70%, 0 70%)"
                    , arrowPosition
                    , width (rem 1)
                    , height (rem 1)
                    , backgroundColor inherit
                    ]
                    :: arrowAttrs
                )
                []

        tooltipContainer =
            let
                tooltipPosition =
                    case config.placement of
                        Top ->
                            Css.batch
                                [ top (rem 0)
                                , left (pct config.arrowDistanceFromCornerInPct)
                                , transform (translate2 (pct -config.arrowDistanceFromCornerInPct) (pct -100))
                                ]

                        Bottom ->
                            Css.batch
                                [ bottom (rem 0)
                                , left (pct config.arrowDistanceFromCornerInPct)
                                , transform (translate2 (pct -config.arrowDistanceFromCornerInPct) (pct 100))
                                ]

                        Left ->
                            Css.batch
                                [ left (rem 0)
                                , top (pct config.arrowDistanceFromCornerInPct)
                                , transform (translate2 (pct -100) (pct -config.arrowDistanceFromCornerInPct))
                                ]

                        Right ->
                            Css.batch
                                [ right (rem 0)
                                , top (pct config.arrowDistanceFromCornerInPct)
                                , transform (translate2 (pct 100) (pct -config.arrowDistanceFromCornerInPct))
                                ]
            in
            Html.div
                [ Attr.class "tooltip"
                , css
                    [ position absolute
                    , display none
                    , flexDirection column
                    , zIndex (int 100)
                    , minWidth (pct 100)
                    , tooltipPosition
                    , case config.visibility of
                        FadeOutMs duration ->
                            Css.batch
                                [ displayFlex
                                , animationDuration (ms duration)
                                , Css.property "animation-fill-mode" "forwards"

                                -- visibility hides it from screen readers
                                , animationName
                                    (keyframes
                                        [ ( 0, [ Animations.opacity (int 1) ] )
                                        , ( 90, [ Animations.opacity (int 1) ] )
                                        , ( 99
                                          , [ Animations.opacity (int 0)
                                            , Animations.property "visibility" "unset"
                                            ]
                                          )
                                        , ( 100
                                          , [ Animations.opacity (int 0)
                                            , Animations.property "visibility" "hidden"
                                            ]
                                          )
                                        ]
                                    )
                                ]

                        Show ->
                            displayFlex

                        _ ->
                            Css.batch []
                    ]
                ]

        showTooltipOnHover =
            class "tooltip" [ displayFlex ]
    in
    Html.div
        (css
            [ display inlineFlex
            , flexDirection column
            , position relative
            , hover [ descendants [ showTooltipOnHover ] ]
                |> styleIf (config.visibility == OnHoverFocus)
            , active [ descendants [ showTooltipOnHover ] ]
                |> styleIf (config.visibility == OnHoverFocus)
            , pseudoClass "focus-within" [ descendants [ showTooltipOnHover ] ]
                |> styleIf (config.visibility == OnHoverFocus)
            , descendants
                [ class "tooltip-content-default-margin"
                    [ case config.placement of
                        Top ->
                            marginBottom (rem 1)

                        Bottom ->
                            marginTop (rem 1)

                        Left ->
                            marginRight (rem 1)

                        Right ->
                            marginLeft (rem 1)
                    ]
                ]
            ]
            :: attrs
        )
        (children ++ [ tooltipContainer [ config.content arrow ] ])


infoTooltip : List (Attribute msg) -> List (Html msg) -> (List (Attribute msg) -> Html msg) -> Html msg
infoTooltip attrs children arrow =
    Html.div
        ([ Attr.class "tooltip-content-default-margin"
         , css
            [ backgroundColor Colors.darkestGray
            , color Colors.white
            , padding2 (rem 0.5) (rem 1)
            , borderRadius (rem 0.5)
            , boxShadow4 zero (rem 0.0625) (rem 0.125) (rgba 0 0 0 0.2)
            , Css.property "width" "max-content"
            , maxWidth (rem 20)
            , position relative
            ]
         ]
            ++ attrs
        )
        (arrow [] :: children)
