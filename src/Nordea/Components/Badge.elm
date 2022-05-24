module Nordea.Components.Badge exposing (Notification(..), view)

import Css
    exposing
        ( absolute
        , alignItems
        , backgroundColor
        , borderRadius
        , bottom
        , center
        , color
        , displayFlex
        , height
        , justifyContent
        , left
        , pct
        , position
        , relative
        , rem
        , width
        )
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes exposing (css)
import Nordea.Components.Text as Text
import Nordea.Resources.Colors as Colors


type Notification
    = Number Int
    | Generic


view : List (Attribute msg) -> List (Html msg) -> Notification -> Html msg
view attrs children config =
    let
        textContent =
            case config of
                Number num ->
                    String.fromInt num

                Generic ->
                    "•"
    in
    Html.div
        (css [ position relative ] :: attrs)
        (Text.view
            [ css
                [ displayFlex
                , alignItems center
                , justifyContent center
                , position absolute
                , left (rem -0.5)
                , bottom (rem -0.5)
                , width (rem 2)
                , height (rem 2)
                , backgroundColor Colors.darkRed
                , borderRadius (pct 50)
                , color Colors.white
                ]
            ]
            [ Html.text textContent ]
            Text.bodyTextHeavy
            :: children
        )