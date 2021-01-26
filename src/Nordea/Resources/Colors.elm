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

import Css exposing (Color, ColorValue, NonMixable, hex)


transparent : ColorValue NonMixable
transparent =
    Css.transparent



-- B&W


white : Color
white =
    hex "#FFFFFF"


black : Color
black =
    hex "#000000"



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



-- Accents


green : Color
green =
    hex "#40BFA3"


greenDark : Color
greenDark =
    hex "#0D8268"


red : Color
red =
    hex "#3FC6161"


redDark : Color
redDark =
    hex "#E70404"


yellow : Color
yellow =
    hex "#FFE183"


yellowDark : Color
yellowDark =
    hex "#FFCF3D"
