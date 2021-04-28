module Nordea.Components.Button exposing
    ( Button
    , primary
    , secondary
    , tertiary
    , view
    , withStyles
    )

import Css exposing (Style)
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
        , Css.batch config.styles
        ]
        attributes
        children



-- STYLES


baseStyle : Style
baseStyle =
    Css.batch
        [ Css.fontFamilies [ "inherit" ]
        , Css.fontSize (Css.rem 1)
        , Css.fontWeight (Css.int 500)
        , Css.padding2 (Css.rem 0.5) (Css.rem 1)
        , Css.borderRadius (Css.rem 2)
        , Css.cursor Css.pointer
        , Css.boxSizing Css.borderBox
        , Css.disabled
            [ Css.opacity (Css.num 0.25)
            , Css.pointerEvents Css.none
            ]
        ]


variantStyle : Variant -> Style
variantStyle variant =
    case variant of
        Primary ->
            Css.batch
                [ Css.backgroundColor Colors.blueDeep
                , Css.color Colors.white
                , Css.border3 (Css.rem 0.125) Css.solid Colors.transparent
                , Css.hover
                    [ Css.backgroundColor Colors.blueCloud
                    , Css.color Colors.blueDeep
                    ]
                , Css.focus
                    [ Css.outline Css.none
                    , Css.backgroundColor Colors.blueNordea
                    , Css.color Colors.blueHaas
                    , Css.boxShadow5 Css.zero Css.zero Css.zero (Css.rem 0.25) Colors.blueHaas
                    ]
                ]

        Secondary ->
            Css.batch
                [ Css.backgroundColor Colors.white
                , Css.color Colors.blueDeep
                , Css.border3 (Css.rem 0.125) Css.solid Colors.blueDeep
                , Css.hover
                    [ Css.backgroundColor Colors.blueCloud
                    , Css.color Colors.blueDeep
                    ]
                , Css.focus
                    [ Css.outline Css.none
                    , Css.backgroundColor Colors.blueCloud
                    , Css.color Colors.blueDeep
                    , Css.boxShadow5 Css.zero Css.zero Css.zero (Css.rem 0.125) Colors.blueDeep
                    ]
                ]

        Tertiary ->
            Css.batch
                [ Css.backgroundColor Colors.transparent
                , Css.color Colors.blueDeep
                , Css.border3 (Css.rem 0.125) Css.solid Colors.transparent
                , Css.hover
                    [ Css.backgroundColor Colors.transparent
                    , Css.color Colors.blueNordea
                    ]
                , Css.focus
                    [ Css.outline Css.none
                    , Css.backgroundColor Colors.transparent
                    , Css.color Colors.blueDeep
                    , Css.boxShadow5 Css.zero Css.zero Css.zero (Css.rem 0.25) Colors.blueHaas
                    ]
                ]
