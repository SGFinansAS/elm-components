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
        , borderBox
        , borderColor
        , borderRadius
        , borderTopColor
        , borderTopLeftRadius
        , borderTopRightRadius
        , borderWidth4
        , boxShadow5
        , boxSizing
        , center
        , cursor
        , deg
        , disabled
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
        )
import Css.Global exposing (withAttribute)
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
        isDisabled =
            List.member (Attrs.disabled True) attrs

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
                    , if isDisabled then
                        borderColor Colors.grayMedium

                      else
                        Themes.borderColor Themes.PrimaryColorLight Colors.blueNordea
                    , borderRadius (rem 0.125)
                    , borderColor Colors.redDark
                        |> styleIf (config.hasError && config.appearance == Simple)
                    , borderColor Colors.grayMedium
                        |> styleIf (config.hasError && List.member config.appearance [ Standard, ListStyle ])
                    , position relative
                    , boxSizing borderBox

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
                        , if isDisabled then
                            border3 (rem 0.0625) solid Colors.grayNordea

                          else
                            border3 (rem 0.0625) solid Colors.white
                        , borderWidth4 (rem 0) (rem 0.125) (rem 0.125) (rem 0)
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
                        , Themes.backgroundColor Themes.SecondaryColor Colors.blueCloud |> styleIf config.isChecked
                        , transition [ Css.Transitions.borderColor 100, Css.Transitions.boxShadow 100 ]
                        ]
            in
            case config.appearance of
                Standard ->
                    Css.batch
                        [ commonNonSimpleStyles
                        , borderRadius (rem 0.25)
                        , height (rem 3)
                        , borderColor Colors.grayMedium |> styleIf (not config.isChecked)
                        , borderColor Colors.redDark |> styleIf config.hasError
                        , hover
                            [ Themes.borderColor Themes.PrimaryColorLight Colors.blueNordea |> styleIf (not config.hasError)
                            , Themes.backgroundColor Themes.SecondaryColor Colors.blueCloud
                            ]
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
                        , hover [ Themes.backgroundColor Themes.SecondaryColor Colors.blueCloud ]
                        ]

                Simple ->
                    Css.batch []

        notDisabledSpecificStyling =
            if isDisabled then
                []

            else
                [ pseudoClass "hover .nfe-checkbox" [ Css.property "box-shadow" ("0rem 0rem 0rem 0.0625rem " ++ Themes.colorVariable Themes.SecondaryColor Colors.blueMedium) ]
                , pseudoClass "focus-within .nfe-checkbox" [ Css.property "box-shadow" ("0rem 0rem 0rem 0.0625rem " ++ Themes.colorVariable Themes.SecondaryColor Colors.blueMedium) ]
                , cursor pointer
                ]
    in
    Html.label
        (css
            ([ display inlineFlex
             , Css.property "gap" "0.5rem"
             , alignItems center
             , boxSizing borderBox
             , appearanceStyle
             , position relative
             ]
                ++ notDisabledSpecificStyling
            )
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
                    [ after [ display block ]
                    , if isDisabled then
                        backgroundColor Colors.grayMedium

                      else
                        Themes.backgroundColor Themes.PrimaryColorLight Colors.blueNordea
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
