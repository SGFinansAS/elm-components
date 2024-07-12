module Nordea.Components.FiveStarRating exposing (FiveStarRating(..), init, view)

import Css exposing (alignItems, backgroundColor, center, color, displayFlex, flexDirection, padding, rem, row, transparent, width)
import Html.Styled as Styled exposing (Attribute)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events exposing (onClick)
import Nordea.Css exposing (gap2)
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Icons as Icons


type FiveStarRating msg
    = FiveStarRating (Config msg)


type alias Config msg =
    { onClick : msg
    }


init : msg -> FiveStarRating msg
init msg =
    FiveStarRating
        { onClick = msg }


view : msg -> FiveStarRating msg -> Styled.Html msg
view msg (FiveStarRating config) =
    let
        starIconButton : msg -> Styled.Html msg
        starIconButton onClickMsg =
            Styled.button
                [ css
                    [ backgroundColor transparent
                    ]
                , onClick onClickMsg
                ]
                [ Icons.star
                    [ css
                        [ width (rem 1.5)
                        , color Colors.deepBlue
                        ]
                    ]
                ]
    in
    Styled.div [ css [ displayFlex, flexDirection row, alignItems center, padding (rem 0.6), gap2 (rem 3) (rem 1) ] ]
        (List.range 1 5 |> List.map (\_ -> starIconButton msg))
