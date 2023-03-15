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
        Css.color color_


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
        color__ =
            Colors.withAlpha 1 color_
    in
    if color__ == Colors.deepBlue then
        Just PrimaryColor

    else if color__ == Colors.nordeaBlue then
        Just PrimaryColorLight

    else if List.member color__ [ Colors.mediumBlue, Colors.haasBlue, Colors.cloudBlue ] then
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
