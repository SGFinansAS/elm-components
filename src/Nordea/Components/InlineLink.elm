module Nordea.Components.InlineLink exposing
    ( InlineLink
    , default
    , view
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
        , display
        , focus
        , hover
        , inlineFlex
        , none
        , num
        , opacity
        , pointer
        , pointerEvents
        , textDecoration
        , underline
        , visited
        )
import Html.Styled as Html exposing (Attribute, Html)
import Nordea.Resources.Colors as Colors
import Nordea.Themes as Themes



-- CONFIG


type alias Config =
    { styles : List Style, isDisabled : Bool }


type InlineLink
    = InlineLink Config


default : InlineLink
default =
    InlineLink { styles = [], isDisabled = False }


withStyles : List Style -> InlineLink -> InlineLink
withStyles styles (InlineLink config) =
    InlineLink { config | styles = styles }


withDisabled : InlineLink -> InlineLink
withDisabled (InlineLink config) =
    InlineLink { config | isDisabled = True }



-- VIEW


view : List (Attribute msg) -> String -> InlineLink -> Html msg
view attributes text (InlineLink config) =
    Html.styled Html.a
        [ baseStyle
        , disabledStyles config.isDisabled
        , Css.batch config.styles
        ]
        attributes
        [ Html.text text ]



-- STYLES


baseStyle : Style
baseStyle =
    Css.batch
        [ display inlineFlex
        , alignItems center
        , cursor pointer
        , boxSizing borderBox
        , textDecoration underline
        , Themes.color Themes.PrimaryColor Colors.blueNordea
        , hover [ Themes.color Themes.PrimaryColorLight Colors.blueDeep ]
        , focus [ Themes.color Themes.PrimaryColorLight Colors.blueDeep ]
        , visited [ Themes.color Themes.PrimaryColorLight Colors.purple ]
        ]


disabledStyles : Bool -> Style
disabledStyles isDisabled =
    if isDisabled then
        Css.batch
            [ opacity (num 0.3)
            , pointerEvents none
            ]

    else
        Css.batch []
