module Nordea.Components.Button exposing
    ( Button
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
                [ backgroundColor Colors.blueDeep
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
                ]

        Secondary ->
            batch
                [ backgroundColor Colors.white
                , color Colors.blueDeep
                , border3 (rem 0.125) solid Colors.blueDeep
                , hover
                    [ backgroundColor (Colors.blueCloud |> Colors.withAlpha 0.5)
                    , color Colors.blueDeep
                    ]
                , focus
                    [ outline none
                    , backgroundColor Colors.blueCloud
                    , color Colors.blueDeep
                    , boxShadow5 zero zero zero (rem 0.125) Colors.blueDeep
                    ]
                ]

        Tertiary ->
            batch
                [ backgroundColor Colors.transparent
                , color Colors.blueDeep
                , border3 (rem 0.125) solid Colors.transparent
                , hover
                    [ backgroundColor Colors.transparent
                    , color Colors.blueNordea
                    ]
                , focus
                    [ outline none
                    , backgroundColor Colors.transparent
                    , color Colors.blueDeep
                    , boxShadow5 zero zero zero (rem 0.25) Colors.blueHaas
                    ]
                ]
