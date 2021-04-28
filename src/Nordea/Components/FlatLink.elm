module Nordea.Components.FlatLink exposing (..)

import Css exposing ( Style )
import Html.Styled exposing (Attribute, Html, a, styled)
import Nordea.Resources.Colors as Colors



-- CONFIG


type Variant
    = Primary
    | Mini

type alias Option =
    { isDisabled : Bool }

type alias Config =
    { variant : Variant, isDisabled : Maybe Bool }


type FlatLink
    = FlatLink Config


init : Variant -> FlatLink
init variant =
    FlatLink { variant = variant, isDisabled = Nothing }


primary : FlatLink
primary  =
    init Primary

mini : FlatLink
mini =
    init Mini

withDisabled : FlatLink -> FlatLink
withDisabled ( FlatLink config ) =
    FlatLink { config | isDisabled = Just True}

-- VIEW


view : List (Attribute msg) -> List (Html msg) -> FlatLink -> Html msg
view attributes children (FlatLink config) =
    styled a (styles config) attributes children



-- STYLES


styles : Config -> List Style
styles config =
    baseStyles ++ variantStyles config.variant ++ disabledStyles config.isDisabled


baseStyles : List Style
baseStyles =
    [ Css.fontSize (Css.rem 1)
    , Css.height (Css.em 2.5)
    , Css.cursor Css.pointer
    , Css.boxSizing Css.borderBox
    , Css.textDecoration Css.underline
    ]

disabledStyles : Maybe Bool -> List Style
disabledStyles isDisabled =
    case isDisabled of
        Just True ->
            [ Css.opacity (Css.num 0.3)
            , Css.pointerEvents Css.none
            ]

        _ ->
            []

variantStyles : Variant -> List Style
variantStyles variant =
    case variant of
        Primary ->
            [ Css.color Colors.blueDeep
            , Css.hover
                [ Css.color Colors.blueNordea
                ]
            ]

        Mini ->
            [ Css.backgroundColor Colors.white
            , Css.color Colors.blueDeep
            , Css.border3 (Css.em 0.125) Css.solid Colors.blueDeep
            , Css.hover
                [ Css.backgroundColor Colors.blueCloud
                ]
            ]

