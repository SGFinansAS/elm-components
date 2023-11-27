module Nordea.Components.Tooltip exposing
    ( Placement(..)
    , Tooltip
    , Visibility(..)
    , infoTooltip
    , init
    , view
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
        , boxSizing
        , calc
        , color
        , column
        , contentBox
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
        , minus
        , ms
        , none
        , padding2
        , pct
        , plus
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
    | TopRight
    | TopLeft
    | Bottom
    | BottomLeft
    | BottomRight
    | Left
    | LeftBottom
    | LeftTop
    | Right
    | RightBottom
    | RightTop


type Visibility
    = OnHoverFocus
    | FadeOutMs Float
    | Show
    | Hidden


type alias Config msg =
    { placement : Placement
    , content : (List (Attribute msg) -> Html msg) -> Html msg
    , visibility : Visibility
    }


type Tooltip msg
    = Tooltip (Config msg)


init : Tooltip msg
init =
    Tooltip
        { placement = Top
        , content = \_ -> Html.text ""
        , visibility = OnHoverFocus
        }


withPlacement : Placement -> Tooltip msg -> Tooltip msg
withPlacement placement (Tooltip config) =
    Tooltip { config | placement = placement }


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
        arrowDistanceFromCornerInPct =
            15

        arrowWidthInRem =
            1

        arrowHeightInRem =
            1

        arrowVerticalMarginInRem =
            arrowHeightInRem * 0.65

        arrowHorizontalMarginInRem =
            arrowWidthInRem * 0.65

        calcString lengthLeft unitLeft op lengthRight unitRight =
            "calc(" ++ String.fromFloat lengthLeft ++ unitLeft ++ " " ++ op ++ " " ++ String.fromFloat lengthRight ++ unitRight ++ ")"

        translateString x y =
            "translate(" ++ x ++ ", " ++ y ++ ")"

        arrow arrowAttrs =
            let
                arrowPosition =
                    case config.placement of
                        Top ->
                            Css.batch
                                [ bottom (rem -arrowVerticalMarginInRem)
                                , left (pct 50)
                                , transforms [ translateX (pct -50), rotate (deg 180) ]
                                ]

                        TopRight ->
                            Css.batch
                                [ bottom (rem -arrowVerticalMarginInRem)
                                , left (calc (pct arrowDistanceFromCornerInPct) plus (rem arrowWidthInRem))
                                , transforms [ translateX (pct -50), rotate (deg 180) ]
                                ]

                        TopLeft ->
                            Css.batch
                                [ bottom (rem -arrowVerticalMarginInRem)
                                , left (calc (pct (100 - arrowDistanceFromCornerInPct)) minus (rem arrowWidthInRem))
                                , transforms [ translateX (pct -50), rotate (deg 180) ]
                                ]

                        Bottom ->
                            Css.batch
                                [ top (rem -arrowHorizontalMarginInRem)
                                , left (pct 50)
                                , transforms [ translateX (pct -50) ]
                                ]

                        BottomLeft ->
                            Css.batch
                                [ top (rem -arrowVerticalMarginInRem)
                                , left (calc (pct (100 - arrowDistanceFromCornerInPct)) minus (rem arrowWidthInRem))
                                , transforms [ translateX (pct -50) ]
                                ]

                        BottomRight ->
                            Css.batch
                                [ top (rem -arrowVerticalMarginInRem)
                                , left (calc (pct arrowDistanceFromCornerInPct) plus (rem arrowWidthInRem))
                                , transforms [ translateX (pct -50) ]
                                ]

                        Left ->
                            Css.batch
                                [ right (rem -arrowHorizontalMarginInRem)
                                , top (pct 50)
                                , transforms [ translateY (pct -50), rotate (deg 90) ]
                                ]

                        LeftBottom ->
                            Css.batch
                                [ right (rem -arrowHorizontalMarginInRem)
                                , top (calc (pct (100 - arrowDistanceFromCornerInPct)) minus (rem arrowHeightInRem))
                                , transforms [ translateY (pct -50), rotate (deg 90) ]
                                ]

                        LeftTop ->
                            Css.batch
                                [ right (rem -arrowHorizontalMarginInRem)
                                , top (calc (pct arrowDistanceFromCornerInPct) plus (rem arrowHeightInRem))
                                , transforms [ translateY (pct -50), rotate (deg 90) ]
                                ]

                        Right ->
                            Css.batch
                                [ left (rem -arrowHorizontalMarginInRem)
                                , top (pct 50)
                                , transforms [ translateY (pct -50), rotate (deg -90) ]
                                ]

                        RightTop ->
                            Css.batch
                                [ left (rem -arrowHorizontalMarginInRem)
                                , top (calc (pct (100 - arrowDistanceFromCornerInPct)) minus (rem arrowHeightInRem))
                                , transforms [ translateY (pct -50), rotate (deg -90) ]
                                ]

                        RightBottom ->
                            Css.batch
                                [ left (rem -arrowHorizontalMarginInRem)
                                , top (calc (pct arrowDistanceFromCornerInPct) plus (rem arrowHeightInRem))
                                , transforms [ translateY (pct -50), rotate (deg -90) ]
                                ]
            in
            Html.div
                (css
                    [ display block
                    , position absolute
                    , Css.property "clip-path" "polygon(50% 20%, 100% 70%, 0 70%)"
                    , arrowPosition
                    , width (rem arrowWidthInRem)
                    , height (rem arrowHeightInRem)
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
                                , left (pct 50)
                                , transform (translate2 (pct -50) (pct -100))
                                ]

                        TopRight ->
                            Css.batch
                                [ top (rem 0)
                                , left (pct 50)
                                , Css.property "transform"
                                    (translateString (calcString -arrowDistanceFromCornerInPct "%" "-" arrowWidthInRem "rem") "-100%")
                                ]

                        TopLeft ->
                            Css.batch
                                [ top (rem 0)
                                , left (pct 50)
                                , Css.property "transform"
                                    (translateString (calcString -(100 - arrowDistanceFromCornerInPct) "%" "+" arrowWidthInRem "rem") "-100%")
                                ]

                        Bottom ->
                            Css.batch
                                [ bottom (rem 0)
                                , left (pct 50)
                                , transform (translate2 (pct -50) (pct 100))
                                ]

                        BottomLeft ->
                            Css.batch
                                [ bottom (rem 0)
                                , left (pct 50)
                                , Css.property "transform"
                                    (translateString (calcString -(100 - arrowDistanceFromCornerInPct) "%" "+" arrowWidthInRem "rem") "100%")
                                ]

                        BottomRight ->
                            Css.batch
                                [ bottom (rem 0)
                                , left (pct 50)
                                , Css.property "transform"
                                    (translateString (calcString -arrowDistanceFromCornerInPct "%" "-" arrowWidthInRem "rem") "100%")
                                ]

                        Left ->
                            Css.batch
                                [ left (rem 0)
                                , top (pct 50)
                                , transform (translate2 (pct -100) (pct -50))
                                ]

                        LeftBottom ->
                            Css.batch
                                [ left (rem 0)
                                , top (pct 50)
                                , Css.property "transform"
                                    (translateString "-100%" (calcString -(100 - arrowDistanceFromCornerInPct) "%" "+" arrowHeightInRem "rem"))
                                ]

                        LeftTop ->
                            Css.batch
                                [ left (rem 0)
                                , top (pct 50)
                                , Css.property "transform"
                                    (translateString "-100%" (calcString -arrowDistanceFromCornerInPct "%" "-" arrowHeightInRem "rem"))
                                ]

                        Right ->
                            Css.batch
                                [ right (rem 0)
                                , top (pct 50)
                                , transform (translate2 (pct 100) (pct -50))
                                ]

                        RightTop ->
                            Css.batch
                                [ right (rem 0)
                                , top (pct 50)
                                , Css.property "transform"
                                    (translateString "100%" (calcString -(100 - arrowDistanceFromCornerInPct) "%" "+" arrowHeightInRem "rem"))
                                ]

                        RightBottom ->
                            Css.batch
                                [ right (rem 0)
                                , top (pct 50)
                                , Css.property "transform"
                                    (translateString "100%" (calcString -arrowDistanceFromCornerInPct "%" "-" arrowHeightInRem "rem"))
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

                    --, Css.property "translate" "35%"
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
                    [ --left (pct 35)
                      case config.placement of
                        Top ->
                            marginBottom (rem 1)

                        TopRight ->
                            marginBottom (rem 1)

                        TopLeft ->
                            marginBottom (rem 1)

                        Bottom ->
                            marginTop (rem 1)

                        BottomLeft ->
                            marginTop (rem 1)

                        BottomRight ->
                            marginTop (rem 1)

                        Left ->
                            marginRight (rem 1)

                        LeftBottom ->
                            marginRight (rem 1)

                        LeftTop ->
                            marginRight (rem 1)

                        Right ->
                            marginLeft (rem 1)

                        RightBottom ->
                            marginLeft (rem 1)

                        RightTop ->
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
            , boxSizing contentBox
            , position relative
            ]
         ]
            ++ attrs
        )
        (arrow [] :: children)
