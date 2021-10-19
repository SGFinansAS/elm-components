module Nordea.Components.Checkbox exposing
    ( Appearance(..)
    , Checkbox
    , init
    , view
    , withAppearance
    , withHasError
    , withIsChecked
    , withOnBlur
    )

import Css
    exposing
        ( absolute
        , after
        , alignItems
        , backgroundColor
        , block
        , border3
        , borderBottomLeftRadius
        , borderBottomRightRadius
        , borderColor
        , borderRadius
        , borderTopColor
        , borderTopLeftRadius
        , borderTopRightRadius
        , borderWidth4
        , boxShadow5
        , center
        , cursor
        , deg
        , display
        , displayFlex
        , firstOfType
        , flex
        , flexBasis
        , height
        , hover
        , inlineFlex
        , int
        , lastOfType
        , left
        , margin
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
        , rotate
        , solid
        , top
        , transforms
        , transparent
        , width
        , zIndex
        )
import Css.Transitions exposing (transition)
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attrs exposing (class, css, name, type_)
import Html.Styled.Events exposing (onCheck)
import Nordea.Html exposing (styleIf)
import Nordea.Resources.Colors as Colors
import Nordea.Themes as Themes


type alias CheckBoxProperties msg =
    { name : String
    , label : Html msg
    , onCheck : Bool -> msg
    , onBlur : Maybe msg
    , isChecked : Bool
    , appearance : Appearance
    , hasError : Bool
    }


type Checkbox msg
    = Checkbox (CheckBoxProperties msg)


type Appearance
    = Standard
    | Simple
    | ListStyle


init : String -> Html msg -> (Bool -> msg) -> Checkbox msg
init name label onCheck =
    Checkbox
        { name = name
        , label = label
        , onCheck = onCheck
        , onBlur = Nothing
        , isChecked = False
        , appearance = Standard
        , hasError = False
        }


view : List (Attribute msg) -> Checkbox msg -> Html msg
view attrs (Checkbox config) =
    let
        checkbox =
            Html.span
                [ class "nfe-checkbox"
                , css
                    [ displayFlex
                    , flex none
                    , height (rem 1.25)
                    , width (rem 1.25)
                    , backgroundColor Colors.white
                    , border3 (rem 0.125) solid Css.transparent
                    , Themes.borderColor Themes.PrimaryColor70 Colors.blueNordea
                    , borderRadius (rem 0.125)
                    , borderColor Colors.redDark
                        |> styleIf (config.hasError && config.appearance == Simple)
                    , borderColor Colors.grayMedium
                        |> styleIf (config.hasError && List.member config.appearance [ Standard, ListStyle ])
                    , position relative

                    -- Styling the checkmark
                    , after
                        [ Css.property "content" "''"
                        , display none
                        , position absolute
                        , top (rem -0.0625)
                        , left (rem 0.25)
                        , width (rem 0.5)
                        , height (rem 0.813)
                        , transforms [ rotate (deg 45) ]
                        , border3 (rem 0.0625) solid Colors.white
                        , borderWidth4 (rem 0) (rem 0.125) (rem 0.125) (rem 0)
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
                        , Themes.backgroundColor Themes.PrimaryColor20 Colors.blueCloud |> styleIf config.isChecked
                        , hover
                            [ Themes.borderColor Themes.PrimaryColor70 Colors.blueNordea |> styleIf (not config.hasError)
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
                        , borderColor Colors.grayMedium |> styleIf (not config.isChecked)
                        , borderColor Colors.redDark |> styleIf config.hasError
                        ]

                ListStyle ->
                    Css.batch
                        [ commonNonSimpleStyles
                        , flexBasis (pct 100)
                        , borderColor Colors.grayMedium
                        , borderColor Colors.redDark |> styleIf config.hasError
                        , Css.firstOfType [ borderTopLeftRadius (rem 0.5), borderTopRightRadius (rem 0.5) ]
                        , Css.lastOfType [ borderBottomLeftRadius (rem 0.5), borderBottomRightRadius (rem 0.5) ]
                        , pseudoClass "not(label:first-of-type):not(:hover)" [ borderTopColor transparent ] |> styleIf (not config.isChecked)
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
            , pseudoClass "hover .nfe-checkbox" [ Css.property "box-shadow" ("0rem 0rem 0rem 0.0625rem " ++ Themes.colorVariable Themes.PrimaryColor20 Colors.blueMedium) ]
            , pseudoClass "focus-within .nfe-checkbox" [ Css.property "box-shadow" ("0rem 0rem 0rem 0.0625rem " ++ Themes.colorVariable Themes.PrimaryColor20 Colors.blueMedium) ]
            ]
            :: attrs
        )
        [ Html.input
            [ type_ "checkbox"
            , name config.name
            , Attrs.checked config.isChecked
            , onCheck config.onCheck
            , css
                [ position absolute
                , opacity (num 0)
                , width (rem 0)
                , height (rem 0)

                -- when <input> is checked, apply styles to sibling with class .nfe-checkbox
                , pseudoClass "checked ~ .nfe-checkbox"
                    [ Themes.backgroundColor Themes.PrimaryColor70 Colors.blueNordea
                    , after [ display block ]
                    ]
                ]
            ]
            []
        , checkbox
        , config.label
        ]


withIsChecked : Bool -> Checkbox msg -> Checkbox msg
withIsChecked isChecked (Checkbox config) =
    Checkbox { config | isChecked = isChecked }


withOnBlur : msg -> Checkbox msg -> Checkbox msg
withOnBlur msg (Checkbox config) =
    Checkbox { config | onBlur = Just msg }


withAppearance : Appearance -> Checkbox msg -> Checkbox msg
withAppearance appearance (Checkbox config) =
    Checkbox { config | appearance = appearance }


withHasError : Bool -> Checkbox msg -> Checkbox msg
withHasError hasError (Checkbox config) =
    Checkbox { config | hasError = hasError }
