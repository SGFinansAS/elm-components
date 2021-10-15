module Nordea.Components.Button exposing
    ( Button
    , Variant(..)
    , buttonStyleForExport
    , primary
    , secondary
    , tertiary
    , view
    , withStyles
    )

import Css
    exposing
        ( Style
        , alignItems
        , backgroundColor
        , batch
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
        , focus
        , fontFamilies
        , fontSize
        , fontWeight
        , hover
        , int
        , none
        , num
        , opacity
        , outline
        , padding2
        , pointer
        , pointerEvents
        , rem
        , solid
        , zero
        )
import Html.Styled as Html exposing (Attribute, Html)
import Nordea.Css exposing (backgroundColorWithVariable, borderColorWithVariable, colorVariable, colorWithVariable)
import Nordea.Resources.Colors as Colors



-- CONFIG


type Variant
    = Primary
    | Secondary
    | Tertiary


type alias Config =
    { variant : Variant, styles : List Style }


type Button
    = Button Config


init : Variant -> Button
init variant =
    Button
        { variant = variant, styles = [] }


primary : Button
primary =
    init Primary


secondary : Button
secondary =
    init Secondary


tertiary : Button
tertiary =
    init Tertiary


withStyles : List Style -> Button -> Button
withStyles styles (Button config) =
    Button { config | styles = styles }



-- VIEW


view : List (Attribute msg) -> List (Html msg) -> Button -> Html msg
view attributes children (Button config) =
    Html.styled Html.button
        [ baseStyle
        , variantStyle config.variant
        , batch config.styles
        ]
        attributes
        children



-- STYLES


baseStyle : Style
baseStyle =
    batch
        [ fontFamilies [ "inherit" ]
        , displayFlex
        , alignItems center
        , fontSize (rem 1)
        , fontWeight (int 500)
        , padding2 (rem 0.5) (rem 1)
        , borderRadius (rem 2)
        , cursor pointer
        , boxSizing borderBox
        , disabled
            [ opacity (num 0.25)
            , pointerEvents none
            ]
        ]


variantStyle : Variant -> Style
variantStyle variant =
    case variant of
        Primary ->
            batch
                [ backgroundColorWithVariable "--themePrimaryColor" Colors.blueDeep
                , color Colors.white
                , border3 (rem 0.125) solid Colors.transparent
                , hover
                    [ backgroundColorWithVariable "--themePrimaryColor20" Colors.blueCloud
                    , colorWithVariable "--themePrimaryColor" Colors.blueDeep
                    ]
                , focus
                    [ outline none
                    , backgroundColorWithVariable "--themePrimaryColor70" Colors.blueNordea
                    , colorWithVariable "--themePrimaryColor20" Colors.blueHaas
                    , Css.property "box-shadow" ("0rem 0rem 0rem 0.25rem " ++ colorVariable "--themePrimaryColor20" Colors.blueHaas)
                    ]
                ]

        Secondary ->
            batch
                [ backgroundColor Colors.white
                , colorWithVariable "--themePrimaryColor" Colors.blueDeep
                , border3 (rem 0.125) solid Css.transparent
                , borderColorWithVariable "--themePrimaryColor" Colors.blueDeep
                , hover
                    [ backgroundColorWithVariable "--themePrimaryColor20" (Colors.blueCloud |> Colors.withAlpha 0.5)
                    , colorWithVariable "--themePrimaryColor" Colors.blueDeep
                    ]
                , focus
                    [ outline none
                    , backgroundColorWithVariable "--themePrimaryColor20" Colors.blueCloud
                    , colorWithVariable "--themePrimaryColor" Colors.blueDeep
                    , Css.property "box-shadow" ("0rem 0rem 0rem 0.25rem " ++ colorVariable "--themePrimaryColor" Colors.blueDeep)
                    ]
                ]

        Tertiary ->
            batch
                [ backgroundColor Colors.transparent
                , colorWithVariable "--themePrimaryColor" Colors.blueDeep
                , border3 (rem 0.125) solid Colors.transparent
                , hover
                    [ backgroundColor Colors.transparent
                    , colorWithVariable "--themePrimaryColor70" Colors.blueNordea
                    ]
                , focus
                    [ outline none
                    , backgroundColor Colors.transparent
                    , colorWithVariable "--themePrimaryColor" Colors.blueDeep
                    , Css.property "box-shadow" ("0rem 0rem 0rem 0.25rem " ++ colorVariable "--themePrimaryColor20" Colors.blueHaas)
                    ]
                ]


buttonStyleForExport : Variant -> Style
buttonStyleForExport variant =
    batch [ baseStyle, variantStyle variant ]
