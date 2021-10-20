module Nordea.Components.RadioButton exposing
    ( Appearance(..)
    , RadioButton
    , init
    , view
    , withAppearance
    , withHasError
    , withIsSelected
    , withOnBlur
    )

import Css
    exposing
        ( absolute
        , after
        , alignItems
        , backgroundColor
        , before
        , block
        , border3
        , borderBottomColor
        , borderBottomLeftRadius
        , borderBottomRightRadius
        , borderBox
        , borderColor
        , borderRadius
        , borderTopColor
        , borderTopLeftRadius
        , borderTopRightRadius
        , boxShadow5
        , boxSizing
        , center
        , cursor
        , display
        , firstOfType
        , flex
        , flexBasis
        , height
        , hover
        , inlineFlex
        , int
        , lastOfType
        , left
        , marginTop
        , none
        , num
        , opacity
        , padding2
        , pct
        , pointer
        , position
        , pseudoClass
        , relative
        , rem
        , solid
        , top
        , transparent
        , width
        , zIndex
        )
import Css.Transitions exposing (transition)
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attrs exposing (css, name, type_)
import Html.Styled.Events as Events
import Nordea.Html exposing (styleIf)
import Nordea.Resources.Colors as Colors
import Nordea.Themes as Themes


type alias InputProperties msg =
    { name : String
    , label : Html msg
    , onCheck : msg
    , onBlur : Maybe msg
    , isSelected : Bool
    , appearance : Appearance
    , showError : Bool
    }


type RadioButton msg
    = RadioButton (InputProperties msg)


type Appearance
    = Standard
    | Simple
    | ListStyle


init : String -> Html msg -> msg -> RadioButton msg
init name label onCheck =
    RadioButton
        { name = name
        , label = label
        , onCheck = onCheck
        , onBlur = Nothing
        , isSelected = False
        , appearance = Standard
        , showError = False
        }


view : List (Attribute msg) -> RadioButton msg -> Html msg
view attrs (RadioButton config) =
    let
        radiomark =
            Html.span
                [ Attrs.class "nfe-radiomark"
                , css
                    [ position relative
                    , width (rem 1.375)
                    , height (rem 1.375)
                    , flex none
                    , before
                        [ Css.property "content" "''"
                        , display block
                        , position absolute
                        , top (rem 0)
                        , left (rem 0)
                        , width (pct 100)
                        , height (pct 100)
                        , backgroundColor Colors.white
                        , border3 (rem 0.125) solid Css.transparent
                        , Themes.borderColor Themes.PrimaryColor70 Colors.blueNordea
                        , borderColor Colors.redDark
                            |> styleIf (config.showError && config.appearance == Simple)
                        , borderColor Colors.grayMedium
                            |> styleIf (config.showError && List.member config.appearance [ Standard, ListStyle ])
                        , borderRadius (pct 100)
                        , boxSizing borderBox
                        ]
                    , after
                        [ Css.property "content" "''"
                        , position absolute
                        , top (rem 0.3125)
                        , left (rem 0.3125)
                        , display none
                        , width (rem 0.75)
                        , height (rem 0.75)
                        , Themes.backgroundColor Themes.PrimaryColor70 Colors.blueNordea
                        , borderRadius (pct 100)
                        , boxSizing borderBox
                        ]
                    ]
                ]
                []

        appearanceStyle =
            let
                commonNonSimpleStyles =
                    Css.batch
                        [ padding2 (rem 0.75) (rem 1)
                        , border3 (rem 0.0625) solid transparent
                        , Themes.backgroundColor Themes.PrimaryColor20 Colors.blueCloud |> styleIf config.isSelected
                        , hover
                            [ Themes.borderColor Themes.PrimaryColor70 Colors.blueNordea |> styleIf (not config.showError)
                            , boxShadow5 (rem 0) (rem 0.25) (rem 0.25) (rem 0) Colors.black25
                            , zIndex (int 1)
                            ]
                        , transition [ Css.Transitions.borderColor 100, Css.Transitions.boxShadow 100 ]
                        ]
            in
            case config.appearance of
                Standard ->
                    Css.batch
                        [ commonNonSimpleStyles
                        , borderRadius (rem 0.5)
                        , borderColor Colors.grayMedium |> styleIf (not config.isSelected)
                        , borderColor Colors.redDark |> styleIf config.showError
                        ]

                ListStyle ->
                    Css.batch
                        [ commonNonSimpleStyles
                        , flexBasis (pct 100)
                        , borderColor Colors.grayMedium
                        , borderColor Colors.redDark |> styleIf config.showError
                        , Css.firstOfType [ borderTopLeftRadius (rem 0.5), borderTopRightRadius (rem 0.5) ]
                        , Css.lastOfType [ borderBottomLeftRadius (rem 0.5), borderBottomRightRadius (rem 0.5) ]
                        , pseudoClass "not(label:first-of-type):not(:hover)" [ borderTopColor transparent ] |> styleIf (not config.isSelected)
                        , pseudoClass "not(label:first-of-type)" [ Css.marginTop (rem -0.0625) ]
                        ]

                Simple ->
                    Css.batch []
    in
    Html.label
        (css
            [ display inlineFlex
            , Css.property "gap" "0.5rem"
            , alignItems center
            , cursor pointer
            , appearanceStyle
            , position relative
            , pseudoClass "hover .nfe-radiomark:before" [ Css.property "box-shadow" ("0rem 0rem 0rem 0.0625rem " ++ Themes.colorVariable Themes.PrimaryColor20 Colors.blueMedium) ]
            , pseudoClass "focus-within .nfe-radiomark:before" [ Css.property "box-shadow" ("0rem 0rem 0rem 0.0625rem " ++ Themes.colorVariable Themes.PrimaryColor20 Colors.blueMedium) ]
            ]
            :: attrs
        )
        [ Html.input
            [ type_ "radio"
            , name config.name
            , Attrs.checked config.isSelected
            , Events.onCheck (\_ -> config.onCheck)
            , css
                [ position absolute
                , opacity (num 0)
                , height (rem 0)
                , width (rem 0)

                -- when <input> is checked, apply styles to sibling with class .nfe-radiomark
                , pseudoClass "checked ~ .nfe-radiomark:after" [ display block ]
                ]
            ]
            []
        , radiomark
        , config.label
        ]


withOnBlur : msg -> RadioButton msg -> RadioButton msg
withOnBlur msg (RadioButton config) =
    RadioButton { config | onBlur = Just msg }


withIsSelected : Bool -> RadioButton msg -> RadioButton msg
withIsSelected isSelected (RadioButton config) =
    RadioButton { config | isSelected = isSelected }


withAppearance : Appearance -> RadioButton msg -> RadioButton msg
withAppearance appearance (RadioButton config) =
    RadioButton { config | appearance = appearance }


withHasError : Bool -> RadioButton msg -> RadioButton msg
withHasError showError (RadioButton config) =
    RadioButton { config | showError = showError }
