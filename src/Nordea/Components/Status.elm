module Nordea.Components.Status exposing (blue, gray, green, partiallyFilled, red, yellow)

import Css
    exposing
        ( Color
        , absolute
        , backgroundColor
        , before
        , borderBottomRightRadius
        , borderRadius
        , borderTopRightRadius
        , display
        , ellipsis
        , height
        , hidden
        , inlineBlock
        , left
        , overflow
        , padding
        , pct
        , position
        , relative
        , rem
        , textOverflow
        , top
        , width
        )
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes exposing (attribute, css)
import Nordea.Components.Text as Text
import Nordea.Resources.Colors as Color


type StatusColor
    = Green
    | Red
    | CloudBlue
    | Yellow
    | LightGray
    | TwoColors Color Color Float


view : String -> StatusColor -> List (Attribute msg) -> Html msg
view text statusColor attrs =
    let
        attrs_ bgColor =
            css
                [ display inlineBlock
                , borderRadius (rem 0.75)
                , padding (rem 0.5)
                , backgroundColor bgColor
                , textOverflow ellipsis
                , overflow hidden
                , position relative
                ]
                :: attrs

        twoColorAttrs_ colorDone colorUndone pctDone =
            attrs_ colorUndone
                ++ [ css
                        [ before
                            [ Css.property "content" "''"
                            , position absolute
                            , left (rem 0)
                            , top (rem 0)
                            , backgroundColor colorDone
                            , borderTopRightRadius (rem 0.75)
                            , borderBottomRightRadius (rem 0.75)
                            , width (pct pctDone)
                            , height (pct 100)
                            ]
                        ]
                   , attribute "role" "progressbar"
                   , attribute "aria-valuenow" (String.fromFloat pctDone)
                   , attribute "aria-label" text
                   ]

        ordinaryLabel bgColor =
            Text.textTinyLight
                |> Text.view
                    (attrs_ bgColor)
                    [ Html.text text ]

        twoColorsLabel colorDone colorUndone pctDone =
            Html.div (twoColorAttrs_ colorDone colorUndone pctDone)
                [ Text.textTinyLight
                    |> Text.view
                        [ css
                            [ position relative
                            ]
                        ]
                        [ Html.text text ]
                ]
    in
    case statusColor of
        Green ->
            ordinaryLabel Color.greenStatus

        Red ->
            ordinaryLabel Color.redStatus

        CloudBlue ->
            ordinaryLabel Color.cloudBlueStatus

        Yellow ->
            ordinaryLabel Color.yellowStatus

        LightGray ->
            ordinaryLabel Color.grayLightStatus

        TwoColors colorDone colorUndone pctDone ->
            twoColorsLabel colorDone colorUndone pctDone


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


partiallyFilled : String -> Color -> Float -> List (Attribute msg) -> Html msg
partiallyFilled text colorDone pctDone =
    view text (TwoColors colorDone (colorDone |> Color.withAlpha 0.4) pctDone)
