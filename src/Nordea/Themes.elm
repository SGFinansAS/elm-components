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
        |> Maybe.map toString
        |> Maybe.withDefault "--not-existing"
        |> (\themeColor -> Css.propertyWithColorVariable "background-color" themeColor color_)


color : Css.Color -> Css.Style
color color_ =
    color_
        |> themeVariableForColor
        |> Maybe.map toString
        |> Maybe.withDefault "--not-existing"
        |> (\themeColor -> Css.propertyWithColorVariable "color" themeColor color_)


borderColor : Css.Color -> Css.Style
borderColor color_ =
    color_
        |> themeVariableForColor
        |> Maybe.map toString
        |> Maybe.withDefault "--not-existing"
        |> (\themeColor -> Css.propertyWithColorVariable "border-color" themeColor color_)


colorVariable : Css.Color -> String
colorVariable color_ =
    color_
        |> themeVariableForColor
        |> Maybe.map toString
        |> Maybe.withDefault "--not-existing"
        |> (\themeColor -> Css.colorVariable themeColor color_)


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

    else if color__ == Colors.white then
        Just TextColorOnPrimaryColorBackground

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
