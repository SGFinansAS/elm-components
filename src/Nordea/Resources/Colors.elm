module Nordea.Resources.Colors exposing
    ( black
    , black25
    , blueCloud
    , blueCloudStatus
    , blueDeep
    , blueHaas
    , blueMedium
    , blueNordea
    , gray
    , grayCool
    , grayDark
    , grayDarkest
    , grayEclipse
    , grayHover
    , grayLight
    , grayLightBorder
    , grayLightStatus
    , grayMedium
    , grayNordea
    , grayWarm
    , green
    , greenDark
    , greenStatus
    , purple
    , red
    , redDark
    , redStatus
    , toString
    , transparent
    , white
    , withAlpha
    , yellow
    , yellowDark
    , yellowStatus
    )

import Css exposing (Color, ColorValue, NonMixable, hex, rgba)


transparent : ColorValue NonMixable
transparent =
    Css.transparent


withAlpha : Float -> Color -> Color
withAlpha alpha color =
    rgba color.red color.green color.blue alpha



-- B&W


white : Color
white =
    hex "#FFFFFF"


black : Color
black =
    hex "#000000"


black25 : Color
black25 =
    rgba 0 0 0 0.25



-- Gray


grayDarkest : Color
grayDarkest =
    hex "#151515"


grayEclipse : Color
grayEclipse =
    hex "#383838"


grayDark : Color
grayDark =
    hex "#5A575C"


grayNordea : Color
grayNordea =
    hex "#8B8A8D"


gray : Color
gray =
    hex "#9E9E9E"


grayMedium : Color
grayMedium =
    hex "#C9C7C7"


grayLight : Color
grayLight =
    hex "#E3E3E3"


grayLightStatus : Color
grayLightStatus =
    hex "#D8D7D7"


grayLightBorder : Color
grayLightBorder =
    hex "#E5E5EE33"


grayCool : Color
grayCool =
    hex "#F1F2F4"


grayWarm : Color
grayWarm =
    hex "#F4F2F1"


grayHover : Color
grayHover =
    hex "#F5F6F7"



-- Blue


blueDeep : Color
blueDeep =
    hex "#00005E"


blueNordea : Color
blueNordea =
    hex "#0000A0"


blueMedium : Color
blueMedium =
    hex "#83B8ED"


blueHaas : Color
blueHaas =
    hex "#AED5FF"


blueCloud : Color
blueCloud =
    hex "#DCEDFF"


blueCloudStatus : Color
blueCloudStatus =
    hex "#C5E0FE"



-- Accents


green : Color
green =
    hex "#40BFA3"


greenStatus : Color
greenStatus =
    hex "#78D1BE"


greenDark : Color
greenDark =
    hex "#0D8268"


red : Color
red =
    hex "#FC6161"


redDark : Color
redDark =
    hex "#E70404"


redStatus : Color
redStatus =
    hex "#FC8F8F"


yellow : Color
yellow =
    hex "#FFE183"


yellowStatus : Color
yellowStatus =
    hex "#FEDC76"


yellowDark : Color
yellowDark =
    hex "#FFCF3D"


purple : Color
purple =
    hex "#7E15D1"


toString : Css.Color -> String
toString color =
    [ String.fromInt color.red
    , String.fromInt color.green
    , String.fromInt color.blue
    , String.fromFloat color.alpha
    ]
        |> String.join ","
        |> (\s -> "rgba(" ++ s ++ ")")
