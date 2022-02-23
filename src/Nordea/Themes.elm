module Nordea.Themes exposing
    ( ThemeColor(..)
    , backgroundColor
    , borderColor
    , color
    , colorVariable
    , toString
    )

import Css
import Nordea.Css as Css


type ThemeColor
    = PrimaryColor
    | PrimaryColorLight
    | SecondaryColor
    | TextColorOnPrimaryColorBackground



-- Utils


backgroundColor : ThemeColor -> Css.Color -> Css.Style
backgroundColor themeColor fallbackColor =
    Css.propertyWithColorVariable "background-color" (toString themeColor) fallbackColor


color : ThemeColor -> Css.Color -> Css.Style
color themeColor fallbackColor =
    Css.propertyWithColorVariable "color" (toString themeColor) fallbackColor


borderColor : ThemeColor -> Css.Color -> Css.Style
borderColor themeColor fallbackColor =
    Css.propertyWithColorVariable "border-color" (toString themeColor) fallbackColor


colorVariable : ThemeColor -> Css.Color -> String
colorVariable themeColor fallbackColor =
    Css.colorVariable (toString themeColor) fallbackColor


toString : ThemeColor -> String
toString themeColor =
    case themeColor of
        PrimaryColor ->
            "--themePrimaryColor"

        PrimaryColorLight ->
            "--themePrimaryColorLight"

        SecondaryColor ->
            "--themeSecondaryColor"

        TextColorOnPrimaryColorBackground ->
            "--themeTextColorOnPrimaryColorBackground"
