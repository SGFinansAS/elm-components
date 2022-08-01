module Nordea.Components.Button exposing
    ( Button
    , Variant(..)
    , buttonStyleForExport
    , card
    , circular
    , flatLinkStyle
    , primary
    , secondary
    , smallCard
    , tertiary
    , view
    , withHtmlTag
    , withStyles
    )

import Css
    exposing
        ( Style
        , absolute
        , alignItems
        , auto
        , backgroundColor
        , batch
        , border
        , border3
        , borderBox
        , borderRadius
        , borderStyle
        , boxShadow4
        , boxSizing
        , center
        , column
        , cursor
        , disabled
        , displayFlex
        , flex
        , flexDirection
        , focus
        , fontFamilies
        , fontSize
        , fontWeight
        , height
        , hover
        , int
        , justifyContent
        , left
        , marginTop
        , none
        , num
        , opacity
        , outline
        , padding
        , padding2
        , paddingRight
        , pct
        , pointer
        , pointerEvents
        , position
        , relative
        , rem
        , right
        , scale2
        , solid
        , start
        , stretch
        , textAlign
        , textDecoration
        , top
        , transform
        , transforms
        , translateX
        , translateY
        , transparent
        , underline
        , width
        )
import Css.Global exposing (children, descendants, everything, withClass)
import Css.Transitions exposing (easeOut, transition)
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes exposing (class, css)
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Icons as Icons
import Nordea.Themes as Themes



-- CONFIG


type Variant
    = Primary
    | Secondary
    | Tertiary
    | Card
    | SmallCard
    | FlatLinkStyle
    | Circular


type alias Config msg =
    { variant : Variant
    , styles : List Style
    , htmlTag : List (Attribute msg) -> List (Html msg) -> Html msg
    }


type Button msg
    = Button (Config msg)


init : Variant -> Button msg
init variant =
    Button
        { variant = variant, styles = [], htmlTag = Html.button }


primary : Button msg
primary =
    init Primary


secondary : Button msg
secondary =
    init Secondary


tertiary : Button msg
tertiary =
    init Tertiary


card : Button msg
card =
    init Card


smallCard : Button msg
smallCard =
    init SmallCard


flatLinkStyle : Button msg
flatLinkStyle =
    init FlatLinkStyle


circular : Button msg
circular =
    init Circular



-- VIEW


view : List (Attribute msg) -> List (Html msg) -> Button msg -> Html msg
view attributes children (Button config) =
    let
        variantSpecificChildren =
            case config.variant of
                Card ->
                    [ Icons.arrowRight [ class "arrowicon", css [ width (rem 1) ] ] ]

                SmallCard ->
                    [ Icons.arrowRight [ class "arrowicon", css [ width (rem 1) ] ] ]

                _ ->
                    []
    in
    Html.styled config.htmlTag
        [ baseStyle
        , variantStyle config.variant
        , batch config.styles
        ]
        attributes
        (children ++ variantSpecificChildren)



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
    let
        commonCardStyle =
            batch
                [ displayFlex
                , flexDirection column
                , position relative
                , backgroundColor Colors.white
                , textAlign left
                , alignItems start
                , padding (rem 1)
                , borderRadius (rem 0.5)
                , borderStyle none
                , boxShadow4 (rem 0) (rem 0.25) (rem 2.5) Colors.grayLight
                , descendants
                    [ everything
                        [ withClass "arrowicon"
                            [ transition [ Css.Transitions.transform3 150 0 easeOut ] ]
                        ]
                    ]
                , hover [ backgroundColor Colors.grayHover ]
                ]

        hoverTransition =
            Css.batch
                [ transition
                    [ Css.Transitions.transform3 300 0 easeOut
                    , Css.Transitions.backgroundColor3 300 0 easeOut
                    , Css.Transitions.color3 300 0 easeOut
                    ]
                , hover [ transform (scale2 1.05 1.05) ]
                ]
    in
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
                , hoverTransition
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
                , hoverTransition
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
                , hoverTransition
                ]

        Card ->
            let
                arrowIconMovement movementLengthRight =
                    descendants
                        [ everything
                            [ withClass "arrowicon"
                                [ transforms [ translateX movementLengthRight ]
                                , marginTop auto
                                ]
                            ]
                        ]
            in
            batch
                [ commonCardStyle
                , arrowIconMovement (rem 0)
                , hover [ arrowIconMovement (rem 1) ]
                ]

        SmallCard ->
            let
                arrowIconMovement movementLengthRight =
                    descendants
                        [ everything
                            [ withClass "arrowicon"
                                [ transforms [ translateY (pct -50), translateX movementLengthRight ]
                                , position absolute
                                , top (pct 50)
                                , right (rem 1.5)
                                ]
                            ]
                        ]
            in
            batch
                [ commonCardStyle
                , paddingRight (rem 3.5)
                , arrowIconMovement (rem 0)
                , hover [ arrowIconMovement (rem 1) ]
                ]

        FlatLinkStyle ->
            batch
                [ textDecoration underline
                , fontSize (rem 0.875)
                , padding (rem 0)
                , Themes.color Themes.PrimaryColor Colors.blueDeep
                , border (rem 0)
                , backgroundColor transparent
                , hover
                    [ Themes.color Themes.PrimaryColorLight Colors.blueNordea ]
                , focus
                    [ outline none ]
                ]

        Circular ->
            batch
                [ border3 (rem 0.0625) solid Colors.mediumGray
                , borderRadius (pct 50)
                , width (rem 2.5)
                , height (rem 2.5)
                , padding (rem 0.5)
                , displayFlex
                , justifyContent center
                , alignItems stretch
                , hover [ Themes.backgroundColor Themes.SecondaryColor Colors.cloudBlue ]
                , position relative
                , children [ everything [ flex (num 1) ] ]
                ]


buttonStyleForExport : Variant -> Style
buttonStyleForExport variant =
    batch [ baseStyle, variantStyle variant ]



-- EXTRAS


withStyles : List Style -> Button msg -> Button msg
withStyles styles (Button config) =
    Button { config | styles = styles }


withHtmlTag : (List (Attribute msg) -> List (Html msg) -> Html msg) -> Button msg -> Button msg
withHtmlTag htmlTag (Button config) =
    Button { config | htmlTag = htmlTag }
