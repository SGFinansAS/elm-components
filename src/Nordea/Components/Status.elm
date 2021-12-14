module Nordea.Components.Status exposing (blue, gray, green, red, yellow)

import Css
    exposing
        ( Color
        , backgroundColor
        , borderRadius
        , display
        , ellipsis
        , fontSize
        , hidden
        , inlineBlock
        , lineHeight
        , overflow
        , padding
        , pct
        , rem
        , textOverflow
        )
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes exposing (css)
import Nordea.Components.Text as Text
import Nordea.Resources.Colors as Color


type StatusColor
    = Green
    | Red
    | CloudBlue
    | Yellow
    | LightGray


view : String -> StatusColor -> List (Attribute msg) -> Html msg
view text statusColor attrs =
    let
        backgroundColorForStatus =
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
    in
    Text.textTinyLight
        |> Text.view
            (css
                [ display inlineBlock
                , borderRadius (rem 0.75)
                , padding (rem 0.5)
                , backgroundColor backgroundColorForStatus
                , textOverflow ellipsis
                , overflow hidden
                ]
                :: attrs
            )
            [ Html.text text ]


green : String -> List (Attribute msg) -> Html msg
green text =
    view text Green


yellow : String -> List (Attribute msg) -> Html msg
yellow text =
    view text Yellow


red : String -> List (Attribute msg) -> Html msg
red text =
    view text Red


blue : String -> List (Attribute msg) -> Html msg
blue text =
    view text CloudBlue


gray : String -> List (Attribute msg) -> Html msg
gray text =
    view text LightGray
