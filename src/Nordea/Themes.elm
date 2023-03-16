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
import Nordea.Resources.Colors as Colors


type ThemeColor
    = PrimaryColor
    | PrimaryColorLight
    | SecondaryColor
    | TextColorOnPrimaryColorBackground



-- Utils


backgroundColor : Css.Color -> Css.Style
backgroundColor color_ =
    color_
        |> themeVariableForColor
        |> Maybe.map (\themeColor -> Css.propertyWithColorVariable "background-color" (toString themeColor) color_)
        |> Maybe.withDefault (Css.backgroundColor color_)


color : Css.Color -> Css.Style
color color_ =
    if color_ == Colors.white then
        Css.propertyWithColorVariable "color" (toString TextColorOnPrimaryColorBackground) color_

    else
        color_
            |> themeVariableForColor
            |> Maybe.map (\themeColor -> Css.propertyWithColorVariable "color" (toString themeColor) color_)
            |> Maybe.withDefault (Css.color color_)


borderColor : Css.Color -> Css.Style
borderColor color_ =
    color_
        |> themeVariableForColor
        |> Maybe.map (\themeColor -> Css.propertyWithColorVariable "border-color" (toString themeColor) color_)
        |> Maybe.withDefault (Css.borderColor color_)


colorVariable : Css.Color -> String
colorVariable color_ =
    color_
        |> themeVariableForColor
        |> Maybe.map (\themeColor -> Css.colorVariable (toString themeColor) color_)
        |> Maybe.withDefault (Css.colorToString color_)


themeVariableForColor : Css.Color -> Maybe ThemeColor
themeVariableForColor color_ =
    let
        isEqual c1 c2 =
            Colors.withAlpha 1 c1 == Colors.withAlpha 1 c2
    in
    if isEqual color_ Colors.deepBlue then
        Just PrimaryColor

    else if isEqual color_ Colors.nordeaBlue then
        Just PrimaryColorLight

    else if List.any (isEqual color_) [ Colors.mediumBlue, Colors.haasBlue, Colors.cloudBlue ] then
        Just SecondaryColor

    else
        Nothing


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
