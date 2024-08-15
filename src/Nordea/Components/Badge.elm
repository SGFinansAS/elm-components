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
        , top
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
    | NumberTopPlacement Int


view : List (Attribute msg) -> List (Html msg) -> Notification -> Html msg
view attrs children config =
    let
        ( showBadge, badgeTextContent, configSpecificStyles ) =
            case config of
                Number num ->
                    ( num > 0
                    , String.fromInt num
                    , Css.batch
                        [ right (rem 0)
                        , bottom (rem 0)
                        , width (rem 1.125)
                        , height (rem 1.125)
                        ]
                    )

                NumberTopPlacement num ->
                    ( num > 0
                    , String.fromInt num
                    , Css.batch
                        [ top (rem -0.5)
                        , right (rem -0.5)
                        , height (rem 1.5)
                        , width (rem 1.5)
                        ]
                    )

                Generic ->
                    ( True
                    , "•"
                    , Css.batch
                        [ right (rem 0)
                        , bottom (rem 0)
                        , width (rem 1.125)
                        , height (rem 1.125)
                        ]
                    )
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
                    , backgroundColor Colors.darkRed
                    , borderRadius (pct 50)
                    , color Colors.white
                    , configSpecificStyles
                    ]
                ]
                [ Html.text badgeTextContent ]
            |> showIf showBadge
         )
            :: children
        )
