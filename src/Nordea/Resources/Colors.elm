module Nordea.Resources.Colors exposing
    ( black
    , black25
    , cloudBlue
    , cloudBlueStatus
    , coolGray
    , darkGray
    , darkGreen
    , darkRed
    , darkYellow
    , darkestGray
    , deepBlue
    , eclipse
    , gray
    , grayHover
    , grayLightBorder
    , grayLightStatus
    , grayWarm
    , green
    , greenStatus
    , haasBlue
    , lightBlue
    , lightGray
    , lightOrange
    , mediumBlue
    , mediumGray
    , nordeaBlue
    , nordeaGray
    , purple
    , red
    , redStatus
    , toString
    , transparent
    , white
    , withAlpha
    , yellow
    , yellowStatus
    )

import Css
    exposing
        ( Color
        , hex
        , rgba
        )



-- PRIMARY COLORS


deepBlue : Color
deepBlue =
    hex "#00005E"


nordeaBlue : Color
nordeaBlue =
    hex "#0000A0"


mediumBlue : Color
mediumBlue =
    hex "#83B8ED"


haasBlue : Color
haasBlue =
    hex "#AED5FF"


cloudBlue : Color
cloudBlue =
    hex "#DCEDFF"


black : Color
black =
    hex "#000000"


darkestGray : Color
darkestGray =
    hex "#151515"


eclipse : Color
eclipse =
    hex "#383838"


darkGray : Color
darkGray =
    hex "#5A575C"


nordeaGray : Color
nordeaGray =
    hex "#8B8A8D"


gray : Color
gray =
    hex "#9E9E9E"


mediumGray : Color
mediumGray =
    hex "#C9C7C7"


coolGray : Color
coolGray =
    hex "#F1F2F4"


white : Color
white =
    hex "#FFFFFF"


darkRed : Color
darkRed =
    hex "#E70404"


darkGreen : Color
darkGreen =
    hex "#0D8268"


darkYellow : Color
darkYellow =
    hex "#FFCF3D"


black25 : Color
black25 =
    rgba 0 0 0 0.25


lightGray : Color
lightGray =
    hex "#E3E3E3"


grayLightStatus : Color
grayLightStatus =
    hex "#D8D7D7"


grayLightBorder : Color
grayLightBorder =
    hex "#E5E5EE33"


grayWarm : Color
grayWarm =
    hex "#F4F2F1"


grayHover : Color
grayHover =
    hex "#F5F6F7"


cloudBlueStatus : Color
cloudBlueStatus =
    hex "#C5E0FE"



-- Accents


green : Color
green =
    hex "#40BFA3"


greenStatus : Color
greenStatus =
    hex "#78D1BE"


red : Color
red =
    hex "#FC6161"


redStatus : Color
redStatus =
    hex "#FC8F8F"


yellow : Color
yellow =
    hex "#FFE183"


yellowStatus : Color
yellowStatus =
    hex "#FEDC76"


transparent : Color
transparent =
    rgba 0 0 0 0


withAlpha : Float -> Color -> Color
withAlpha alpha color =
    rgba color.red color.green color.blue alpha


purple : Color
purple =
    hex "#7E15D1"


lightOrange : Color
lightOrange =
    hex "#FBD9CA"


lightBlue : Color
lightBlue =
    hex "#99CCFF"


toString : Css.Color -> String
toString color =
    [ String.fromInt color.red
    , String.fromInt color.green
    , String.fromInt color.blue
    , String.fromFloat color.alpha
    ]
        |> String.join ","
        |> (\s -> "rgba(" ++ s ++ ")")
