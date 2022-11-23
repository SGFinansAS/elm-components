module Nordea.Resources.Colors exposing
    ( black
    , black25
    , blueDeep
    , blueHaas
    , blueMedium
    , blueNordea
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
    , haasBlue
    , lightGray
    , mediumBlue
    , mediumGray
    , nordeaBlue
    , nordeaGray
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

import Css
    exposing
        ( Color
        , ColorValue
        , NonMixable
        , hex
        , rgba
        )



-- PRIMARY COLORS


{-| Deprecated, use deepBlue
-}
blueDeep : Color
blueDeep =
    hex "#00005E"


deepBlue : Color
deepBlue =
    hex "#00005E"


{-| Deprecated, use nordeaBlue
-}
blueNordea : Color
blueNordea =
    hex "#0000A0"


nordeaBlue : Color
nordeaBlue =
    hex "#0000A0"


{-| Deprecated, use deepBlue
-}
blueMedium : Color
blueMedium =
    hex "#83B8ED"


mediumBlue : Color
mediumBlue =
    hex "#83B8ED"


{-| Deprecated, use haasBlue
-}
blueHaas : Color
blueHaas =
    hex "#AED5FF"


haasBlue : Color
haasBlue =
    hex "#AED5FF"


cloudBlue : Color
cloudBlue =
    hex "#DCEDFF"


black : Color
black =
    hex "#000000"


{-| Deprecated, use darkestGray
-}
grayDarkest : Color
grayDarkest =
    hex "#151515"


darkestGray : Color
darkestGray =
    hex "#151515"


{-| Deprecated, use eclipse
-}
grayEclipse : Color
grayEclipse =
    hex "#383838"


eclipse : Color
eclipse =
    hex "#383838"


{-| Deprecated, use darkGray
-}
grayDark : Color
grayDark =
    hex "#5A575C"


darkGray : Color
darkGray =
    hex "#5A575C"


{-| Deprecated, use nordeaGray
-}
grayNordea : Color
grayNordea =
    hex "#8B8A8D"


nordeaGray : Color
nordeaGray =
    hex "#8B8A8D"


gray : Color
gray =
    hex "#9E9E9E"


{-| Deprecated, use mediumGray
-}
grayMedium : Color
grayMedium =
    hex "#C9C7C7"


mediumGray : Color
mediumGray =
    hex "#C9C7C7"


{-| Deprecated, use lightGray
-}
grayLight : Color
grayLight =
    hex "#E3E3E3"


{-| Deprecated, use coolGray
-}
grayCool : Color
grayCool =
    hex "#F1F2F4"


coolGray : Color
coolGray =
    hex "#F1F2F4"


white : Color
white =
    hex "#FFFFFF"


{-| Deprecated, use darkRed
-}
redDark : Color
redDark =
    hex "#E70404"


darkRed : Color
darkRed =
    hex "#E70404"


{-| Deprecated, use darkGreen
-}
greenDark : Color
greenDark =
    hex "#0D8268"


darkGreen : Color
darkGreen =
    hex "#0D8268"


{-| Deprecated, use darkYellow
-}
yellowDark : Color
yellowDark =
    hex "#FFCF3D"


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


transparent : ColorValue NonMixable
transparent =
    Css.transparent


withAlpha : Float -> Color -> Color
withAlpha alpha color =
    rgba color.red color.green color.blue alpha


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
