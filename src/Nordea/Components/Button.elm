module Nordea.Components.Button exposing
    ( Button
    , Size(..)
    , Variant(..)
    , buttonStyleForExport
    , card
    , circular
    , flatLinkStyle
    , primary
    , secondary
    , tertiary
    , view
    , withHtmlTag
    , withSmallSize
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
        , outlineOffset
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
    | FlatLinkStyle
    | Circular


type Size
    = Standard
    | Small


type alias Config msg =
    { variant : Variant
    , styles : List Style
    , htmlTag : List (Attribute msg) -> List (Html msg) -> Html msg
    , size : Size
    }


type Button msg
    = Button (Config msg)


init : Variant -> Button msg
init variant =
    Button
        { variant = variant, styles = [], htmlTag = Html.button, size = Standard }


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


flatLinkStyle : Button msg
flatLinkStyle =
    init FlatLinkStyle


circular : Button msg
circular =
    init Circular


withSmallSize : Button msg -> Button msg
withSmallSize (Button config) =
    Button { config | size = Small }



-- VIEW


view : List (Attribute msg) -> List (Html msg) -> Button msg -> Html msg
view attributes children (Button config) =
    let
        variantSpecificChildren =
            case config.variant of
                Card ->
                    [ Icons.arrowRight [ class "arrowicon", css [ width (rem 1) ] ] ]

                _ ->
                    []
    in
    Html.styled config.htmlTag
        [ baseStyle
        , variantStyle config.variant config.size
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
        , fontWeight (int 500)
        , borderRadius (rem 2)
        , cursor pointer
        , boxSizing borderBox
        , disabled
            [ opacity (num 0.25)
            , pointerEvents none
            ]
        ]


variantStyle : Variant -> Size -> Style
variantStyle variant size =
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
                , boxShadow4 (rem 0) (rem 0.25) (rem 2.5) Colors.lightGray
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

        primaryStyling =
            [ Themes.backgroundColor Colors.deepBlue
            , Themes.color Colors.white
            , border3 (rem 0.125) solid Colors.transparent
            , hover
                [ Themes.backgroundColor Colors.cloudBlue
                , Themes.color Colors.deepBlue
                ]
            , focus
                [ outline none
                , Themes.backgroundColor Colors.nordeaBlue
                , Themes.color Colors.haasBlue
                , Css.property "box-shadow" ("0rem 0rem 0rem 0.25rem " ++ Themes.colorVariable Colors.haasBlue)
                ]
            , hoverTransition
            ]

        secondaryStyling =
            [ backgroundColor Colors.white
            , Themes.color Colors.deepBlue
            , border3 (rem 0.125) solid Css.transparent
            , Themes.borderColor Colors.deepBlue
            , hover
                [ Themes.backgroundColor (Colors.cloudBlue |> Colors.withAlpha 0.5)
                , Themes.color Colors.deepBlue
                ]
            , focus
                [ outline none
                , Themes.backgroundColor Colors.cloudBlue
                , Themes.color Colors.deepBlue
                , Css.property "box-shadow" ("0rem 0rem 0rem 0.125rem " ++ Themes.colorVariable Colors.deepBlue)
                ]
            , hoverTransition
            ]

        tertiaryStyling =
            [ backgroundColor Colors.transparent
            , Themes.color Colors.deepBlue
            , border3 (rem 0.125) solid Colors.transparent
            , hover
                [ backgroundColor Colors.transparent
                , Themes.color Colors.nordeaBlue
                ]
            , focus
                [ outline none
                , backgroundColor Colors.transparent
                , Themes.color Colors.deepBlue
                , Css.property "box-shadow" ("0rem 0rem 0rem 0.25rem " ++ Themes.colorVariable Colors.haasBlue)
                ]
            , hoverTransition
            ]

        sizeSpecificStyling =
            case size of
                Standard ->
                    [ fontSize (rem 1)
                    , padding2 (rem 0) (rem 1)
                    , height (rem 2.5)
                    ]

                Small ->
                    [ fontSize (rem 0.75)
                    , padding2 (rem 0.5) (rem 1)
                    , height (rem 2)
                    ]
    in
    case variant of
        Primary ->
            batch (sizeSpecificStyling ++ primaryStyling)

        Secondary ->
            batch (sizeSpecificStyling ++ secondaryStyling)

        Tertiary ->
            batch (sizeSpecificStyling ++ tertiaryStyling)

        Card ->
            case size of
                Standard ->
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

                Small ->
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
                , Themes.color Colors.deepBlue
                , border (rem 0)
                , backgroundColor transparent
                , hover [ Themes.color Colors.nordeaBlue ]
                , focus
                    [ outlineOffset (rem 0.5)
                    , Css.property "outline" ("0.25rem solid " ++ Themes.colorVariable Colors.mediumBlue)
                    ]
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
                , hover [ Themes.backgroundColor Colors.cloudBlue ]
                , position relative
                , children [ everything [ flex (num 1) ] ]
                ]


buttonStyleForExport : Variant -> Size -> Style
buttonStyleForExport variant size =
    batch [ baseStyle, variantStyle variant size ]



-- EXTRAS


withStyles : List Style -> Button msg -> Button msg
withStyles styles (Button config) =
    Button { config | styles = styles }


withHtmlTag : (List (Attribute msg) -> List (Html msg) -> Html msg) -> Button msg -> Button msg
withHtmlTag htmlTag (Button config) =
    Button { config | htmlTag = htmlTag }
