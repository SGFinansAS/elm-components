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
        , borderBox
        , boxSizing
        , center
        , color
        , cursor
        , displayFlex
        , fitContent
        , focus
        , fontSize
        , hover
        , lineHeight
        , maxWidth
        , none
        , num
        , opacity
        , pointer
        , pointerEvents
        , rem
        , textDecoration
        , underline
        )
import Html.Styled as Html exposing (Attribute, Html)
import Nordea.Components.Button as Button
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


withButtonStyle : Button.Variant -> FlatLink -> FlatLink
withButtonStyle buttonVariant (FlatLink config) =
    FlatLink { config | styles = buttonStyle buttonVariant }



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


buttonStyle : Button.Variant -> List Style
buttonStyle buttonVariant =
    [ maxWidth fitContent
    , textDecoration none
    , Button.buttonStyleForExport buttonVariant
    ]
