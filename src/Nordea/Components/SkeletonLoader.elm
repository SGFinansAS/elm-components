module Nordea.Components.SkeletonLoader exposing (view)

import Css
    exposing
        ( animationDuration
        , animationName
        , ms
        )
import Css.Animations exposing (keyframes)
import Html.Styled as Html
    exposing
        ( Attribute
        , Html
        )
import Html.Styled.Attributes exposing (css)


view : List (Attribute msg) -> Html msg
view attrs =
    Html.div
        (css
            [ skeletonLoading
            ]
            :: attrs
        )
        []


skeletonLoading : Css.Style
skeletonLoading =
    Css.batch
        [ Css.property "background" "linear-gradient(90deg, rgba(201, 199, 199, 0.25) 37.5%, rgba(139, 138, 141, 0.25) 50%, rgba(201, 199, 199, 0.25) 62.5%)"
        , Css.property "background-size" "200% 200%"
        , animationDuration (ms 1400)
        , Css.property "animation-timing-function" "ease"
        , Css.property "animation-iteration-count" "infinite"
        , animationName <|
            keyframes
                [ ( 0, [ Css.Animations.property "background-position-x" "200%" ] )
                , ( 100, [ Css.Animations.property "background-position-x" "0%" ] )
                ]
        ]
