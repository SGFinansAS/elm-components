module Components.Button exposing
    ( Model
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



-- MODEL


type Variant
    = Primary
    | Secondary
    | Tertiary


type Model
    = Model { variant : Variant }


init : Variant -> Model
init variant =
    Model { variant = variant }


primary : Model
primary =
    init Primary


secondary : Model
secondary =
    init Secondary


tertiary : Model
tertiary =
    init Tertiary



-- VIEW


view : List (Attribute msg) -> List (Html msg) -> Model -> Html msg
view attributes children model =
    styled button (styles model) attributes children



-- STYLES


styles : Model -> List Style
styles (Model model) =
    baseStyles ++ variantStyles model.variant


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
