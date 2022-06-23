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
        , pct
        , position
        , relative
        , rem
        , right
        , width
        )
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes exposing (css)
import Nordea.Components.Text as Text
import Nordea.Html exposing (showIf)
import Nordea.Resources.Colors as Colors


type Notification
    = Number Int
    | Generic


view : List (Attribute msg) -> List (Html msg) -> Notification -> Html msg
view attrs children config =
    let
        ( showBadge, badgeTextContent ) =
            case config of
                Number num ->
                    ( num > 0, String.fromInt num )

                Generic ->
                    ( True, "•" )
    in
    Html.div
        (css [ position relative ] :: attrs)
        ((Text.textTinyHeavy
            |> Text.view
                [ css
                    [ displayFlex
                    , alignItems center
                    , justifyContent center
                    , position absolute
                    , right (rem 0)
                    , bottom (rem 0)
                    , width (rem 1.125)
                    , height (rem 1.125)
                    , backgroundColor Colors.darkRed
                    , borderRadius (pct 50)
                    , color Colors.white
                    ]
                ]
                [ Html.text badgeTextContent ]
            |> showIf showBadge
         )
            :: children
        )
