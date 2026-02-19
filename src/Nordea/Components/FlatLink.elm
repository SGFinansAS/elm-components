module Nordea.Components.FlatLink exposing
    ( FlatLink
    , default
    , inline
    , mini
    , outer
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
        , cursor
        , displayFlex
        , fitContent
        , focus
        , fontSize
        , fontWeight
        , height
        , hover
        , inlineFlex
        , int
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
        , visited
        , width
        )
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes exposing (css)
import Nordea.Components.Button as Button
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Icons as Icons
import Nordea.Themes as Themes



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


withDisabled : Bool -> FlatLink -> FlatLink
withDisabled b (FlatLink config) =
    FlatLink { config | isDisabled = Just b }


withButtonStyle : Button.Variant -> FlatLink -> FlatLink
withButtonStyle buttonVariant (FlatLink config) =
    let
        buttonSize =
            case config.variant of
                Default ->
                    Button.Standard

                Mini ->
                    Button.Small
    in
    FlatLink { config | styles = buttonStyle buttonVariant buttonSize }



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


inline : List (Attribute msg) -> List (Html msg) -> Html msg
inline attrs children =
    view attrs
        children
        (FlatLink
            { styles =
                [ Css.display inlineFlex
                , Css.fontWeight Css.inherit
                , Themes.color Colors.nordeaBlue
                , hover [ Themes.color Colors.deepBlue ]
                , focus [ Themes.color Colors.deepBlue ]
                , visited [ Css.color Colors.purple ]
                ]
            , isDisabled = Just (List.member (Html.Styled.Attributes.disabled True) attrs)
            , variant = Default
            }
        )


outer : List (Attribute msg) -> List (Html msg) -> Html msg
outer attrs children =
    view attrs
        (children
            ++ [ Icons.rightIcon (Icons.outerLink [ css [ width (rem 1), height (rem 1) ] ]) ]
        )
        (FlatLink
            { styles =
                [ Css.fontWeight Css.inherit
                , Themes.color Colors.nordeaBlue
                , textDecoration none
                , hover
                    [ Themes.color Colors.deepBlue
                    , textDecoration underline
                    ]
                , focus [ Themes.color Colors.deepBlue ]
                , visited [ Css.color Colors.purple ]
                ]
            , isDisabled = Just (List.member (Html.Styled.Attributes.disabled True) attrs)
            , variant = Default
            }
        )



-- STYLES


baseStyle : Style
baseStyle =
    Css.batch
        [ displayFlex
        , alignItems center
        , cursor pointer
        , boxSizing borderBox
        , textDecoration underline
        , Themes.color Colors.deepBlue
        , hover [ Themes.color Colors.nordeaBlue ]
        , focus [ Themes.color Colors.nordeaBlue ]
        , fontWeight (int 500)
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


buttonStyle : Button.Variant -> Button.Size -> List Style
buttonStyle buttonVariant buttonSize =
    [ maxWidth fitContent
    , textDecoration none
    , Button.buttonStyleForExport buttonVariant buttonSize
    ]
