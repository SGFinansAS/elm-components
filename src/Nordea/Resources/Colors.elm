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
    , grayLight
    , grayLightStatus
    , grayMedium
    , grayNordea
    , grayWarm
    , green
    , greenDark
    , greenStatus
    , inputOutline
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

import Css exposing (Color, ColorValue, NonMixable, Style, hex, rgba)
import Nordea.Themes as Themes


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


grayCool : Color
grayCool =
    hex "#F1F2F4"


grayWarm : Color
grayWarm =
    hex "#F4F2F1"



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
    hex "#3FC6161"


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



-- EXTRAS


toString : Css.Color -> String
toString color =
    [ String.fromInt color.red
    , String.fromInt color.green
    , String.fromInt color.blue
    , String.fromFloat color.alpha
    ]
        |> String.join ","
        |> (\s -> "rgba(" ++ s ++ ")")


inputOutline : Style
inputOutline =
    Css.property "box-shadow" ("0rem 0rem 0rem 0.0625rem " ++ Themes.colorVariable Themes.SecondaryColor blueNordea)
