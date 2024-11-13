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
        , padding2
        , position
        , relative
        , rem
        , right
        , top
        , width
        )
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes exposing (css)
import Maybe.Extra as Maybe
import Nordea.Components.Text as Text
import Nordea.Html exposing (showIf, styleIf)
import Nordea.Resources.Colors as Colors


type Notification
    = Number Int (Maybe Int)
    | Generic
    | NumberTopPlacement Int


view : List (Attribute msg) -> List (Html msg) -> Notification -> Html msg
view attrs children config =
    let
        ( showBadge, badgeTextContent, configSpecificStyles ) =
            case config of
                Number num maxCharCount ->
                    ( num > 0
                    , maxCharCount
                        |> Maybe.filter (\charCount -> num >= (10 ^ charCount))
                        |> Maybe.map (\charCount -> String.fromInt (10 ^ charCount - 1) ++ "+")
                        |> Maybe.withDefault (String.fromInt num)
                        |> Just
                    , Css.batch
                        [ right (rem 0) |> styleIf (List.isEmpty children |> not)
                        , bottom (rem 0) |> styleIf (List.isEmpty children |> not)
                        , padding2 (rem 0) (rem 0.375)
                        , height (rem 1.125)
                        ]
                    )

                NumberTopPlacement num ->
                    ( num > 0
                    , Just (String.fromInt num)
                    , Css.batch
                        [ top (rem -0.5)
                        , right (rem -0.5)
                        , height (rem 1.5)
                        , width (rem 1.5)
                        ]
                    )

                Generic ->
                    ( True
                    , Nothing
                    , Css.batch
                        [ width (rem 0.5)
                        , height (rem 0.5)
                        , bottom (rem 0) |> styleIf (List.isEmpty children |> not)
                        ]
                    )

        commonStyles =
            Css.batch
                [ displayFlex
                , backgroundColor Colors.darkRed
                , position absolute |> styleIf (List.isEmpty children |> not)
                , configSpecificStyles
                ]
    in
    Html.div
        (css [ position relative ] :: attrs)
        ((badgeTextContent
            |> Maybe.map
                (\textContent ->
                    Text.textTinyHeavy
                        |> Text.view
                            [ css
                                [ commonStyles
                                , alignItems center
                                , justifyContent center
                                , color Colors.white
                                , borderRadius (rem 0.75)
                                ]
                            ]
                            [ Html.text textContent ]
                )
            |> Maybe.withDefault (Html.div [ css [ commonStyles, borderRadius (rem 0.25) ] ] [])
            |> showIf showBadge
         )
            :: children
        )
