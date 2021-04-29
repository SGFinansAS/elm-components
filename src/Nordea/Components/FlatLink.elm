module Nordea.Components.FlatLink exposing (..)

import Css exposing (Style)
import Html.Styled as Html exposing (Attribute, Html)
import Nordea.Resources.Colors as Colors



-- CONFIG


type Variant
    = Primary
    | Mini


type alias Config =
    { variant : Variant, styles : List Style, isDisabled : Maybe Bool }


type FlatLink
    = FlatLink Config


init : Variant -> FlatLink
init variant =
    FlatLink { variant = variant, styles = [], isDisabled = Nothing }


primary : FlatLink
primary =
    init Primary


mini : FlatLink
mini =
    init Mini


withStyles : List Style -> FlatLink -> FlatLink
withStyles styles (FlatLink config) =
    FlatLink { config | styles = styles }


withDisabled : FlatLink -> FlatLink
withDisabled (FlatLink config) =
    FlatLink { config | isDisabled = Just True }



-- VIEW


view : List (Attribute msg) -> List (Html msg) -> FlatLink -> Html msg
view attributes children (FlatLink config) =
    Html.styled Html.a
        [ baseStyle
        , variantStyle config.variant
        , disabledStyles config.isDisabled
        , Css.batch config.styles
        ]
        attributes
        children



-- STYLES


baseStyle : Style
baseStyle =
    Css.batch
        [ Css.cursor Css.pointer
        , Css.boxSizing Css.borderBox
        , Css.textDecoration Css.underline
        , Css.color Colors.blueDeep
        , Css.hover
            [ Css.color Colors.blueNordea
            ]
        , Css.focus
            [ Css.color Colors.blueNordea
            ]
        ]


disabledStyles : Maybe Bool -> Style
disabledStyles isDisabled =
    case isDisabled of
        Just True ->
            Css.batch
                [ Css.opacity (Css.num 0.3)
                , Css.pointerEvents Css.none
                ]

        _ ->
            Css.batch []


variantStyle : Variant -> Style
variantStyle variant =
    case variant of
        Primary ->
            Css.batch
                [ Css.fontSize (Css.rem 1)
                , Css.lineHeight (Css.rem 1.5)
                ]

        Mini ->
            Css.batch
                [ Css.fontSize (Css.rem 0.875)
                , Css.lineHeight (Css.rem 1.125)
                ]
