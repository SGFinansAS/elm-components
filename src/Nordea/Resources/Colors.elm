module Nordea.Resources.Colors exposing
    ( black
    , blueCloud
    , blueDeep
    , blueHaas
    , blueMedium
    , blueNordea
    , gray
    , grayDark
    , grayDarkest
    , grayEclipse
    , grayLight
    , grayMedium
    , grayNordea
    , grayWarm
    , green
    , greenDark
    , red
    , redDark
    , transparent
    , white
    , yellow
    , yellowDark
    )

import Css exposing (Color, ColorValue, NonMixable)


transparent : ColorValue NonMixable
transparent =
    Css.transparent



-- B&W


white : Color
white =
    Css.hex "#FFFFFF"


black : Color
black =
    Css.hex "#000000"



-- Gray


grayDarkest : Color
grayDarkest =
    Css.hex "#151515"


grayEclipse : Color
grayEclipse =
    Css.hex "#383838"


grayDark : Color
grayDark =
    Css.hex "#5A575C"


grayNordea : Color
grayNordea =
    Css.hex "#8B8A8D"


gray : Color
gray =
    Css.hex "#9E9E9E"


grayMedium : Color
grayMedium =
    Css.hex "#C9C7C7"


grayLight : Color
grayLight =
    Css.hex "#E3E3E3"


grayWarm : Color
grayWarm =
    Css.hex "#F4F2F1"



-- Blue


blueDeep : Color
blueDeep =
    Css.hex "#00005E"


blueNordea : Color
blueNordea =
    Css.hex "#0000A0"


blueMedium : Color
blueMedium =
    Css.hex "#83B8ED"


blueHaas : Color
blueHaas =
    Css.hex "#AED5FF"


blueCloud : Color
blueCloud =
    Css.hex "#DCEDFF"



-- Accents


green : Color
green =
    Css.hex "#40BFA3"


greenDark : Color
greenDark =
    Css.hex "#0D8268"


red : Color
red =
    Css.hex "#3FC6161"


redDark : Color
redDark =
    Css.hex "#E70404"


yellow : Color
yellow =
    Css.hex "#FFE183"


yellowDark : Color
yellowDark =
    Css.hex "#FFCF3D"
