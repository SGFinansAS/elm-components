module Nordea.Components.Snackbar exposing
    ( Variant(..)
    , info
    , init
    , view
    , withIsHiddenCloseIcon
    )

import Css
    exposing
        ( alignItems
        , animationDuration
        , animationName
        , backgroundColor
        , borderRadius
        , bottom
        , center
        , color
        , cursor
        , fixed
        , fontSize
        , height
        , hover
        , int
        , left
        , marginLeft
        , ms
        , opacity
        , padding2
        , pct
        , pointer
        , position
        , property
        , rem
        , textAlign
        , transform
        , translate2
        , width
        )
import Css.Animations as Animations exposing (keyframes)
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events exposing (on, onClick)
import Json.Decode as Json
import Nordea.Html as Html
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Icons as Icon
import Nordea.Themes as Themes


type Variant
    = Info
    | Success
    | Warning


type alias Properties msg =
    { onFinish : msg
    , animationDurationMs : Int
    , visibleDurationMs : Int
    , variant : Variant
    , isClosableByUser : Bool
    , isHiddenCloseIcon : Bool
    }


info : msg -> Properties msg
info onFinish =
    init Info onFinish


init : Variant -> msg -> Properties msg
init variant onFinish =
    { onFinish = onFinish
    , animationDurationMs = 400
    , visibleDurationMs = 4000
    , variant = variant
    , isClosableByUser = False
    , isHiddenCloseIcon = False
    }


view : List (Attribute msg) -> List (Html msg) -> Properties msg -> Html msg
view attrs children props =
    let
        closeIcon =
            let
                iconColor =
                    case props.variant of
                        Info ->
                            Colors.white

                        Success ->
                            Colors.white

                        Warning ->
                            Colors.black
            in
            Icon.close
                [ onClick props.onFinish
                , css
                    [ marginLeft (rem 1)
                    , width (rem 1)
                    , height (rem 1)
                    , hover [ cursor pointer ]
                    , color iconColor
                    ]
                ]

        totalDurationMs =
            toFloat (props.animationDurationMs + props.visibleDurationMs)

        animation =
            let
                animationPartFraction =
                    round ((toFloat props.animationDurationMs / totalDurationMs) * 100)
            in
            keyframes
                [ ( 0
                  , [ Animations.opacity (int 0)
                    , Animations.transform [ translate2 (pct -50) (pct 50) ]
                    ]
                  )
                , ( animationPartFraction
                  , [ Animations.opacity (int 1)
                    , Animations.transform [ translate2 (pct -50) (pct 0) ]
                    ]
                  )
                , ( 100 - animationPartFraction
                  , [ Animations.opacity (int 1)
                    , Animations.transform [ translate2 (pct -50) (pct 0) ]
                    ]
                  )
                , ( 100
                  , [ Animations.opacity (int 0)
                    , Animations.transform [ translate2 (pct -50) (pct 50) ]
                    ]
                  )
                ]
    in
    Html.row
        ([ on "animationend" (Json.succeed props.onFinish)
         , css
            [ position fixed
            , left (pct 50)
            , alignItems center
            , case props.variant of
                Info ->
                    Css.batch
                        [ Themes.backgroundColor Colors.deepBlue
                        , Themes.color Colors.white
                        ]

                Success ->
                    Css.batch [ backgroundColor Colors.darkGreen, color Colors.white ]

                Warning ->
                    Css.batch [ backgroundColor Colors.yellow, color Colors.black ]
            , padding2 (rem 1) (rem 1.5)
            , fontSize (rem 1)
            , textAlign center
            , borderRadius (rem 0.5)
            , property "animation-fill-mode" "forwards"
            , transform (translate2 (pct -50) (pct 50))
            , if props.isClosableByUser then
                Css.batch [ opacity (int 1), bottom (rem 2.25) ]

              else
                Css.batch
                    [ opacity (int 0)
                    , bottom (rem 1.5)
                    , animationName animation
                    , animationDuration (ms totalDurationMs)
                    ]
            ]
         ]
            ++ attrs
        )
        (children
            ++ [ if props.isHiddenCloseIcon then
                    Html.text ""

                 else
                    closeIcon
               ]
        )


withIsHiddenCloseIcon : Properties msg -> Properties msg
withIsHiddenCloseIcon snackbarProperties =
    { snackbarProperties | isHiddenCloseIcon = True }
