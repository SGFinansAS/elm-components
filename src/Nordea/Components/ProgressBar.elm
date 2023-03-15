module Nordea.Components.ProgressBar exposing
    ( init
    , view
    , withAnimationDurationMs
    , withCheckmarkColor
    , withCustomCenterLabel
    , withStrokeColor
    , withStrokeWidth
    , withUnfilledStrokeColor
    )

import Css
    exposing
        ( Color
        , absolute
        , animationDelay
        , animationDuration
        , animationName
        , deg
        , display
        , fill
        , fontFamilies
        , fontSize
        , fontWeight
        , height
        , int
        , left
        , lineHeight
        , ms
        , none
        , opacity
        , pct
        , position
        , relative
        , rem
        , rotate
        , scaleX
        , top
        , transform
        , transforms
        , translate2
        , transparent
        , width
        )
import Css.Animations as Animations exposing (keyframes)
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attrs
import Nordea.Css exposing (propertyWithVariable)
import Nordea.Html exposing (showIf)
import Nordea.Resources.Colors as Colors
import Nordea.Themes as Themes
import Svg.Styled as Svg
import Svg.Styled.Attributes as SvgAttrs


type alias ViewConfig msg =
    { strokeWidth : Int
    , strokeColor : Css.Color
    , unfilledStrokeColor : Css.Color
    , checkmarkColor : Css.Color
    , animDurationMs : Float
    , progress : Float
    , isCompleted : Bool
    , customCenterLabel : Maybe (Html msg)
    }


init : { progress : Float, isCompleted : Bool } -> ViewConfig msg
init { progress, isCompleted } =
    { strokeWidth = 6
    , strokeColor = Colors.deepBlue
    , unfilledStrokeColor = Colors.coolGray
    , checkmarkColor = Colors.darkGreen
    , animDurationMs = 1000
    , progress = progress
    , isCompleted = isCompleted
    , customCenterLabel = Nothing
    }


view : List (Attribute msg) -> ViewConfig msg -> Html msg
view attrs config =
    let
        animDurationMs =
            config.animDurationMs

        progress =
            floor config.progress
                |> clamp 0 100

        maxProgress =
            max 100 progress

        -- the duration each number is visible when counting up during completion animation
        partAnimDuration =
            animDurationMs / toFloat maxProgress

        distanceToMax =
            maxProgress - progress

        svgCircle stroke progress_ =
            let
                circleProgress =
                    if config.isCompleted then
                        100

                    else
                        clamp 0 100 progress_

                radius =
                    50 - (toFloat config.strokeWidth / 2) |> floor

                circumference =
                    2 * pi * toFloat radius

                dashOffsetAnimDuration =
                    if config.isCompleted then
                        partAnimDuration * (toFloat distanceToMax + 1)

                    else
                        animDurationMs / 2
            in
            Svg.circle
                [ SvgAttrs.css
                    [ fill transparent
                    , Css.property "stroke-width" (config.strokeWidth |> String.fromInt)
                    , stroke
                    , Css.property "stroke-linecap" "round"
                    , Css.property "stroke-dasharray" (circumference |> String.fromFloat)
                    , Css.property "stroke-dashoffset" (circumference - (circumference * circleProgress) / 100 |> String.fromFloat)
                    , transitions
                        [ transition "stroke-dashoffset" dashOffsetAnimDuration "ease-in-out" 0
                        , transition "stroke" (animDurationMs / 2) "ease-in-out" (partAnimDuration * (toFloat distanceToMax + 1))
                        ]
                    ]
                , SvgAttrs.cx "50"
                , SvgAttrs.cy "50"
                , SvgAttrs.r (String.fromInt radius)
                ]
                []

        svgCheckmark strokeColor =
            Svg.rect
                [ SvgAttrs.css
                    [ fill transparent
                    , Css.property "stroke-width" (config.strokeWidth |> String.fromInt)
                    , Css.property "stroke" (Colors.toString strokeColor)
                    , Css.property "stroke-dasharray" "101"
                    , Css.property "stroke-dashoffset" "101"
                    , Css.property "stroke-linecap" "round"
                    , transforms [ rotate (deg 315), scaleX -1 ]
                    , Css.property "transform-origin" "center"
                    , Css.property "animation-fill-mode" "forwards"
                    , Css.property "animation-timing-function" "ease-in-out"
                    , animationName
                        (keyframes
                            [ ( 0, [ Animations.property "stroke-dashoffset" "101" ] )
                            , ( 100, [ Animations.property "stroke-dashoffset" "52" ] )
                            ]
                        )
                    , animationDuration (ms (animDurationMs / 2))
                    , animationDelay (ms (partAnimDuration * (toFloat distanceToMax + 1)))
                    ]
                , SvgAttrs.x "40"
                , SvgAttrs.y "35"
                , SvgAttrs.width "15"
                , SvgAttrs.height "35"
                ]
                []

        centerLabel =
            let
                animation =
                    if config.isCompleted then
                        keyframes
                            [ ( 0, [ Animations.opacity (Css.int 1) ] )
                            , ( 99, [ Animations.opacity (Css.int 1) ] )
                            , ( 100, [ Animations.opacity (Css.int 0) ] )
                            ]

                    else
                        keyframes
                            [ ( 0, [ Animations.opacity (Css.int 1) ] )
                            , ( 99, [ Animations.opacity (Css.int 1) ] )
                            ]

                animPlayState =
                    if config.isCompleted then
                        "running"

                    else
                        "paused"

                containerStyle =
                    Css.batch
                        [ position absolute
                        , left (pct 50)
                        , top (pct 50)
                        , transform (translate2 (pct -50) (pct -50))
                        ]
            in
            case config.customCenterLabel of
                Just customCenterLabel ->
                    Html.span [ Attrs.css [ containerStyle ] ] [ customCenterLabel ]

                Nothing ->
                    List.range 0 maxProgress
                        |> List.indexedMap
                            (\i percent ->
                                Html.span
                                    [ Attrs.css
                                        [ containerStyle
                                        , fontFamilies [ "Nordea Sans Small" ]
                                        , Themes.color Colors.deepBlue
                                        , fontSize (rem 0.875)
                                        , fontWeight (int 500)
                                        , lineHeight (rem 0)
                                        , opacity (int 0)
                                        , Css.property "animation-fill-mode" "forwards"
                                        , Css.property "animation-timing-function" "linear"
                                        , animationName animation
                                        , animationDuration (ms partAnimDuration)
                                        , Css.property "animation-play-state" animPlayState
                                        , animationDelay (ms (partAnimDuration * toFloat i - (partAnimDuration * toFloat progress)))
                                        ]
                                    ]
                                    [ Html.text (String.fromInt percent ++ "%") ]
                            )
                        |> Html.span []

        circleStrokeColor =
            if config.isCompleted then
                Css.property "stroke" (Colors.toString config.checkmarkColor)

            else
                propertyWithVariable "stroke" (Themes.toString Themes.PrimaryColor) (Colors.toString config.strokeColor)
    in
    Html.div
        (Attrs.css [ position relative, width (rem 4), height (rem 4) ] :: attrs)
        [ Svg.svg
            [ SvgAttrs.viewBox "0 0 100 100"
            , Attrs.style "transform" "rotate(-90deg)"
            ]
            [ svgCircle (Css.property "stroke" (Colors.toString config.unfilledStrokeColor)) 100
            , svgCircle circleStrokeColor config.progress
            , svgCheckmark config.checkmarkColor |> showIf config.isCompleted
            ]
        , centerLabel
        , Html.progress
            [ Attrs.css [ display none ]
            , Attrs.max "100"
            , Attrs.value (config.progress |> round |> String.fromInt)
            ]
            []
        ]


withStrokeWidth : Int -> ViewConfig msg -> ViewConfig msg
withStrokeWidth width viewConfig =
    { viewConfig | strokeWidth = width }


withStrokeColor : Color -> ViewConfig msg -> ViewConfig msg
withStrokeColor color viewConfig =
    { viewConfig | strokeColor = color }


withUnfilledStrokeColor : Color -> ViewConfig msg -> ViewConfig msg
withUnfilledStrokeColor color viewConfig =
    { viewConfig | unfilledStrokeColor = color }


withCheckmarkColor : Color -> ViewConfig msg -> ViewConfig msg
withCheckmarkColor color viewConfig =
    { viewConfig | checkmarkColor = color }


withAnimationDurationMs : Float -> ViewConfig msg -> ViewConfig msg
withAnimationDurationMs animDurationMs viewConfig =
    { viewConfig | animDurationMs = animDurationMs }


withCustomCenterLabel : Html msg -> ViewConfig msg -> ViewConfig msg
withCustomCenterLabel centerLabel viewConfig =
    { viewConfig | customCenterLabel = Just centerLabel }



-- UTILS


transition : String -> Float -> String -> Float -> String
transition prop durationMs timingFunc delayMs =
    [ prop, String.fromFloat durationMs ++ "ms", timingFunc, String.fromFloat delayMs ++ "ms" ]
        |> String.join " "


transitions : List String -> Css.Style
transitions t =
    String.join ", " t
        |> Css.property "transition"
