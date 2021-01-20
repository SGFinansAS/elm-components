module Components.Button exposing
    ( Config
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
        , fontSize
        , height
        , hover
        , none
        , num
        , opacity
        , padding2
        , pointer
        , pointerEvents
        , rem
        , solid
        )
import Html.Styled as Html exposing (Attribute, Html, button, styled)
import Resources.Colors as Colors



-- CONFIG


type Variant
    = Primary
    | Secondary
    | Tertiary


type Config
    = Config { variant : Variant }


config : Variant -> Config
config variant =
    Config { variant = variant }


primary : Config
primary =
    config Primary


secondary : Config
secondary =
    config Secondary


tertiary : Config
tertiary =
    config Tertiary



-- VIEW


view : List (Attribute msg) -> List (Html msg) -> Config -> Html msg
view attributes children config =
    styled button (styles config) attributes children



-- STYLES


styles : Config -> List Style
styles (Config config) =
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
                [ backgroundColor Colors.blueHaas
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
