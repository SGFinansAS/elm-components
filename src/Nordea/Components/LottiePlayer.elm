module Nordea.Components.LottiePlayer exposing
    ( LottiePlayer
    , init
    , view
    , withAutoplay
    , withControls
    , withLoop
    , withSpeed
    )

import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attrs
import Nordea.Html.Attributes as Attrs


type LottiePlayer
    = LottiePlayer Config


type alias Config =
    { src : String
    , controls : Bool
    , autoplay : Bool
    , loop : Bool
    , speed : Float
    }


init : String -> LottiePlayer
init src =
    LottiePlayer
        { src = src
        , controls = False
        , autoplay = True
        , loop = False
        , speed = 1
        }


withControls : Bool -> LottiePlayer -> LottiePlayer
withControls controls (LottiePlayer config) =
    LottiePlayer { config | controls = controls }


withAutoplay : Bool -> LottiePlayer -> LottiePlayer
withAutoplay autoplay (LottiePlayer config) =
    LottiePlayer { config | autoplay = autoplay }


withLoop : Bool -> LottiePlayer -> LottiePlayer
withLoop loop (LottiePlayer config) =
    LottiePlayer { config | loop = loop }


withSpeed : Float -> LottiePlayer -> LottiePlayer
withSpeed speed (LottiePlayer config) =
    LottiePlayer { config | speed = speed }


view : List (Attribute msg) -> LottiePlayer -> Html msg
view attributes (LottiePlayer config) =
    Html.node "lottie-player"
        ([ Attrs.src config.src
         , Attrs.stringProperty "background" "transparent"
         , Attrs.floatProperty "speed" config.speed
         , Attrs.boolProperty "controls" config.controls
         , Attrs.loop config.loop
         , Attrs.autoplay config.autoplay
         ]
            ++ attributes
        )
        []
