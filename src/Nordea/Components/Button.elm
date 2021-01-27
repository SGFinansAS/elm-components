module Nordea.Components.Button exposing
    ( Button
    , primary
    , secondary
    , tertiary
    , view
    )

import Css
    exposing
        ( Style
        , backgroundColor
        , border3
        , borderBox
        , borderRadius
        , boxSizing
        , color
        , cursor
        , disabled
        , em
        , focus
        , fontSize
        , height
        , hover
        , none
        , num
        , opacity
        , outline3
        , outlineOffset
        , padding2
        , pointer
        , pointerEvents
        , rem
        , solid
        )
import Html.Styled as Html exposing (Attribute, Html, button, styled)
import Nordea.Resources.Colors as Colors



-- CONFIG


type Variant
    = Primary
    | Secondary
    | Tertiary


type alias Config =
    { variant : Variant }


type Button
    = Button Config


init : Variant -> Button
init variant =
    Button { variant = variant }


primary : Button
primary =
    init Primary


secondary : Button
secondary =
    init Secondary


tertiary : Button
tertiary =
    init Tertiary



-- VIEW


view : List (Attribute msg) -> List (Html msg) -> Button -> Html msg
view attributes children (Button config) =
    styled button (styles config) attributes children



-- STYLES


styles : Config -> List Style
styles config =
    baseStyles ++ variantStyles config.variant


baseStyles : List Style
baseStyles =
    [ fontSize (rem 1)
    , height (em 2.5)
    , padding2 (em 0.5) (em 2)
    , borderRadius (em 2)
    , cursor pointer
    , boxSizing borderBox
    , disabled
        [ opacity (num 0.3)
        , pointerEvents none
        ]
    , focus
        [ outline3 (em 0.125) solid Colors.blueDeep
        , outlineOffset (em 0.1875)
        ]
    ]


variantStyles : Variant -> List Style
variantStyles variant =
    case variant of
        Primary ->
            [ backgroundColor Colors.blueDeep
            , color Colors.white
            , border3 (em 0.125) solid Colors.transparent
            , hover
                [ backgroundColor Colors.blueNordea
                ]
            ]

        Secondary ->
            [ backgroundColor Colors.white
            , color Colors.blueDeep
            , border3 (em 0.125) solid Colors.blueDeep
            , hover
                [ backgroundColor Colors.blueCloud
                ]
            ]

        Tertiary ->
            [ backgroundColor Colors.transparent
            , color Colors.blueDeep
            , border3 (em 0.125) solid Colors.transparent
            , hover
                [ color Colors.blueNordea
                ]
            ]
