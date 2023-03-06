module Nordea.Components.Toggle exposing (view)

import Css
    exposing
        ( absolute
        , after
        , alignItems
        , backgroundColor
        , block
        , border3
        , borderRadius
        , center
        , cursor
        , display
        , displayFlex
        , height
        , hex
        , left
        , opacity
        , pct
        , pointer
        , position
        , property
        , pseudoClass
        , relative
        , rem
        , solid
        , top
        , transform
        , translateY
        , width
        , zero
        )
import Css.Transitions as Transitions
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attrs exposing (class, css, name, type_)
import Html.Styled.Events as Events
import Nordea.Resources.Colors as Colors
import Nordea.Themes as Themes


type alias ToggleProperties msg =
    { name : String
    , onCheck : Bool -> msg
    , isChecked : Bool
    }


view : List (Attribute msg) -> ToggleProperties msg -> Html msg
view attrs toggleProperties =
    let
        isDisabled =
            List.member (Attrs.disabled True) attrs
    in
    Html.label
        (css
            [ displayFlex
            , alignItems center
            , position relative
            , height (rem 1.5)
            , width (rem 2.625)
            , cursor pointer
            ]
            :: attrs
        )
        [ Html.input
            [ type_ "checkBox"
            , name toggleProperties.name
            , Attrs.checked toggleProperties.isChecked
            , Events.onCheck toggleProperties.onCheck
            , Attrs.disabled isDisabled
            , css
                [ opacity zero
                , height zero
                , width zero
                , pseudoClass "checked ~ .nfe-toggle"
                    [ Themes.backgroundColor Colors.blueDeep
                    , Themes.borderColor Colors.blueDeep
                    , after [ left (rem 1.125) ]
                    ]
                , pseudoClass "disabled ~ .nfe-toggle"
                    [ backgroundColor Colors.grayLight
                    , border3 (rem 0.125) solid Colors.grayLight
                    , after [ backgroundColor Colors.grayMedium ]
                    ]
                ]
            ]
            []
        , Html.span
            [ class "nfe-toggle"
            , css
                [ width (pct 100)
                , height (pct 100)
                , backgroundColor Colors.grayMedium
                , border3 (rem 0.125) solid Colors.grayMedium
                , borderRadius (rem 1)
                , position relative
                , after
                    [ display block
                    , property "content" "''"
                    , position absolute
                    , top (pct 50)
                    , left (rem 0)
                    , transform (translateY (pct -50))
                    , width (rem 1.25)
                    , height (rem 1.25)
                    , backgroundColor (hex "#FFFFFF")
                    , borderRadius (pct 50)
                    , Css.boxShadow4 (rem 0) (rem 0.0625) (rem 0.0625) (Colors.withAlpha 0.5 Colors.black)
                    , Transitions.transition [ Transitions.left3 300 0 Transitions.ease ]
                    ]
                ]
            ]
            []
        ]
