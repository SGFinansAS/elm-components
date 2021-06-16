module Nordea.Components.FlatLink exposing
    ( FlatLink
    , default
    , mini
    , view
    , withButtonStyle
    , withDisabled
    , withStyles
    )

import Css
    exposing
        ( Style
        , alignItems
        , backgroundColor
        , border3
        , borderBox
        , borderRadius
        , boxShadow5
        , boxSizing
        , center
        , color
        , cursor
        , disabled
        , displayFlex
        , fitContent
        , focus
        , fontFamilies
        , fontSize
        , fontWeight
        , hover
        , int
        , lineHeight
        , none
        , num
        , opacity
        , outline
        , padding2
        , pointer
        , pointerEvents
        , rem
        , solid
        , textDecoration
        , underline
        , zero
        )
import Html.Styled as Html exposing (Attribute, Html)
import Nordea.Resources.Colors as Colors



-- CONFIG


type Variant
    = Default
    | Mini


type alias Config =
    { variant : Variant, styles : List Style, isDisabled : Maybe Bool }


type FlatLink
    = FlatLink Config


init : Variant -> FlatLink
init variant =
    FlatLink { variant = variant, styles = [], isDisabled = Nothing }


default : FlatLink
default =
    init Default


mini : FlatLink
mini =
    init Mini


withStyles : List Style -> FlatLink -> FlatLink
withStyles styles (FlatLink config) =
    FlatLink { config | styles = styles }


withDisabled : FlatLink -> FlatLink
withDisabled (FlatLink config) =
    FlatLink { config | isDisabled = Just True }


withButtonStyle : FlatLink -> FlatLink
withButtonStyle (FlatLink config) =
    FlatLink { config | styles = buttonStyle }



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
        [ displayFlex
        , alignItems center
        , cursor pointer
        , boxSizing borderBox
        , textDecoration underline
        , color Colors.blueDeep
        , hover
            [ color Colors.blueNordea
            ]
        , focus
            [ color Colors.blueNordea
            ]
        ]


disabledStyles : Maybe Bool -> Style
disabledStyles isDisabled =
    case isDisabled of
        Just True ->
            Css.batch
                [ opacity (num 0.3)
                , pointerEvents none
                ]

        _ ->
            Css.batch []


variantStyle : Variant -> Style
variantStyle variant =
    case variant of
        Default ->
            Css.batch
                [ fontSize (rem 1)
                , lineHeight (rem 1.5)
                ]

        Mini ->
            Css.batch
                [ fontSize (rem 0.875)
                , lineHeight (rem 1.125)
                ]


buttonStyle : List Style
buttonStyle =
    [ fontFamilies [ "inherit" ]
    , Css.maxWidth fitContent
    , textDecoration none
    , displayFlex
    , alignItems center
    , fontSize (rem 1)
    , fontWeight (int 500)
    , padding2 (rem 0.5) (rem 1)
    , borderRadius (rem 2)
    , cursor pointer
    , boxSizing borderBox
    , backgroundColor Colors.blueDeep
    , color Colors.white
    , border3 (rem 0.125) solid Colors.transparent
    , hover
        [ backgroundColor Colors.blueCloud
        , color Colors.blueDeep
        ]
    , focus
        [ outline none
        , backgroundColor Colors.blueNordea
        , color Colors.blueHaas
        , boxShadow5 zero zero zero (rem 0.25) Colors.blueHaas
        ]
    , disabled
        [ opacity (num 0.25)
        , pointerEvents none
        ]
    ]
