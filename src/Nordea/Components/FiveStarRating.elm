module Nordea.Components.FiveStarRating exposing (FiveStarRating(..), init, view)

import Css exposing (alignItems, backgroundColor, borderRadius, center, color, displayFlex, flexDirection, focus, height, justifyContent, none, outline, padding, rem, row, transparent, width)
import Html.Styled as Styled exposing (Attribute)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events exposing (onClick, onMouseEnter)
import Nordea.Css exposing (gap2)
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Icons as Icons
import Nordea.Themes as Themes


type FiveStarRating msg
    = FiveStarRating (Config msg)


type alias Config msg =
    { rating : Int
    , currentHover : Int
    , onHover : Int -> msg
    , onClick : Int -> msg
    }


init : (Int -> msg) -> (Int -> msg) -> FiveStarRating msg
init onHover onClick =
    FiveStarRating
        { rating = 0
        , currentHover = 0
        , onHover = onHover
        , onClick = onClick
        }


view : List (Attribute msg) -> Int -> FiveStarRating msg -> Styled.Html msg
view attrs currentHoverRating (FiveStarRating config) =
    let
        iconStarStyle =
            [ css
                [ width (rem 1.5)
                , height (rem 1.5)
                , color Colors.deepBlue
                ]
            ]

        starIcon index =
            if index <= currentHoverRating then
                Icons.filledStar iconStarStyle

            else
                Icons.star iconStarStyle

        starIconButton : Int -> Styled.Html msg
        starIconButton value =
            Styled.button
                [ css
                    [ displayFlex
                    , alignItems center
                    , justifyContent center
                    , backgroundColor transparent
                    , borderRadius (rem 0.1)
                    , padding (rem 0.25)
                    , focus
                        [ outline none
                        , Css.property "box-shadow" ("0rem 0rem 0rem 0.2rem " ++ Themes.colorVariable Colors.haasBlue)
                        ]
                    ]
                , onMouseEnter (config.onHover value)
                , onClick (config.onClick value)
                ]
                [ starIcon value
                ]
    in
    Styled.div (css [ displayFlex, flexDirection row, alignItems center, padding (rem 0.6), gap2 (rem 0.5) (rem 0.5) ] :: attrs)
        (List.range 1 5 |> List.map (\index -> starIconButton index))
