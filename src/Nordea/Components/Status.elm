module Nordea.Components.Status exposing (blue, gray, green, red, yellow)

import Css exposing (Color, backgroundColor, borderRadius, display, ellipsis, fontSize, hidden, inlineBlock, lineHeight, maxWidth, overflow, padding, pct, rem, textOverflow)
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes exposing (css)
import Nordea.Resources.Colors as Color


type StatusColor
    = Green
    | Red
    | CloudBlue
    | Yellow
    | LightGray


view : String -> StatusColor -> Html msg
view text statusColor =
    Html.span
        [ css
            [ padding (rem 0.5)
            , backgroundColor (statusToColor statusColor)
            , borderRadius (rem 0.75)
            , fontSize (rem 0.75)
            , display inlineBlock
            , lineHeight (rem 1)
            , maxWidth (pct 100)
            , textOverflow ellipsis
            , overflow hidden
            ]
        ]
        [ Html.text text
        ]


green : String -> Html msg
green text =
    view text Green


yellow : String -> Html msg
yellow text =
    view text Yellow


red : String -> Html msg
red text =
    view text Red


blue : String -> Html msg
blue text =
    view text CloudBlue


gray : String -> Html msg
gray text =
    view text LightGray


statusToColor : StatusColor -> Color
statusToColor statusColor =
    case statusColor of
        Green ->
            Color.greenStatus

        Red ->
            Color.redStatus

        CloudBlue ->
            Color.blueCloudStatus

        Yellow ->
            Color.yellowStatus

        LightGray ->
            Color.grayLightStatus
