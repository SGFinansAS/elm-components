module Nordea.Components.Button exposing
    ( Button
    , Variant(..)
    , buttonStyleForExport
    , card
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
        , borderStyle
        , boxShadow4
        , boxSizing
        , center
        , cursor
        , disabled
        , displayFlex
        , focus
        , fontFamilies
        , fontSize
        , fontWeight
        , hover
        , int
        , left
        , none
        , num
        , opacity
        , outline
        , padding
        , padding2
        , pointer
        , pointerEvents
        , rem
        , scale
        , solid
        , textAlign
        , transform
        )
import Html.Styled as Html exposing (Attribute, Html)
import Nordea.Resources.Colors as Colors
import Nordea.Themes as Themes



-- CONFIG


type Variant
    = Primary
    | Secondary
    | Tertiary
    | Card


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


card : Button
card =
    init Card


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
                [ Themes.backgroundColor Themes.PrimaryColor Colors.blueDeep
                , Themes.color Themes.TextColorOnPrimaryColorBackground Colors.white
                , border3 (rem 0.125) solid Colors.transparent
                , hover
                    [ Themes.backgroundColor Themes.SecondaryColor Colors.blueCloud
                    , Themes.color Themes.PrimaryColor Colors.blueDeep
                    ]
                , focus
                    [ outline none
                    , Themes.backgroundColor Themes.PrimaryColorLight Colors.blueNordea
                    , Themes.color Themes.SecondaryColor Colors.blueHaas
                    , Css.property "box-shadow" ("0rem 0rem 0rem 0.25rem " ++ Themes.colorVariable Themes.SecondaryColor Colors.blueHaas)
                    ]
                ]

        Secondary ->
            batch
                [ backgroundColor Colors.white
                , Themes.color Themes.PrimaryColor Colors.blueDeep
                , border3 (rem 0.125) solid Css.transparent
                , Themes.borderColor Themes.PrimaryColor Colors.blueDeep
                , hover
                    [ Themes.backgroundColor Themes.SecondaryColor (Colors.blueCloud |> Colors.withAlpha 0.5)
                    , Themes.color Themes.PrimaryColor Colors.blueDeep
                    ]
                , focus
                    [ outline none
                    , Themes.backgroundColor Themes.SecondaryColor Colors.blueCloud
                    , Themes.color Themes.PrimaryColor Colors.blueDeep
                    , Css.property "box-shadow" ("0rem 0rem 0rem 0.125rem " ++ Themes.colorVariable Themes.PrimaryColor Colors.blueDeep)
                    ]
                ]

        Tertiary ->
            batch
                [ backgroundColor Colors.transparent
                , Themes.color Themes.PrimaryColor Colors.blueDeep
                , border3 (rem 0.125) solid Colors.transparent
                , hover
                    [ backgroundColor Colors.transparent
                    , Themes.color Themes.PrimaryColorLight Colors.blueNordea
                    ]
                , focus
                    [ outline none
                    , backgroundColor Colors.transparent
                    , Themes.color Themes.PrimaryColor Colors.blueDeep
                    , Css.property "box-shadow" ("0rem 0rem 0rem 0.25rem " ++ Themes.colorVariable Themes.SecondaryColor Colors.blueHaas)
                    ]
                ]

        Card ->
            batch
                [ backgroundColor Colors.white
                , textAlign left
                , padding (rem 1)
                , borderRadius (rem 0.75)
                , borderStyle none
                , boxShadow4 (rem 0) (rem 0.25) (rem 2.5) Colors.grayLight
                , hover [ transform (scale 1.25) ]
                ]


buttonStyleForExport : Variant -> Style
buttonStyleForExport variant =
    batch [ baseStyle, variantStyle variant ]
