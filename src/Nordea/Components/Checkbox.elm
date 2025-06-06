module Nordea.Components.Checkbox exposing
    ( Appearance(..)
    , Checkbox
    , init
    , view
    , withAppearance
    , withHasError
    , withInputAttrs
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
        , boxSizing
        , center
        , cursor
        , deg
        , display
        , displayFlex
        , flex
        , flexBasis
        , height
        , hover
        , inlineFlex
        , left
        , minHeight
        , none
        , num
        , opacity
        , padding2
        , padding4
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
import Css.Transitions exposing (transition)
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attrs exposing (class, css, disabled, name, type_)
import Html.Styled.Events exposing (onCheck)
import Nordea.Components.Text as Text
import Nordea.Css exposing (gap)
import Nordea.Html exposing (styleIf)
import Nordea.Resources.Colors as Colors
import Nordea.Themes as Themes


type alias CheckboxProperties msg =
    { name : String
    , label : Html msg
    , onCheck : Bool -> msg
    , onBlur : Maybe msg
    , isChecked : Bool
    , appearance : Appearance
    , hasError : Bool
    , inputAttrs : List (Attribute msg)
    }


type Checkbox msg
    = Checkbox (CheckboxProperties msg)


type Appearance
    = Standard
    | Small
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
        , inputAttrs = []
        }


view : List (Attribute msg) -> Checkbox msg -> Html msg
view attrs (Checkbox config) =
    let
        isDisabled =
            List.member (Attrs.disabled True) attrs

        checkbox =
            let
                checkboxSizeStyling =
                    if config.appearance == Small then
                        Css.batch
                            [ height (rem 1)
                            , width (rem 1)
                            ]

                    else
                        Css.batch
                            [ height (rem 1.25)
                            , width (rem 1.25)
                            ]

                checkmarkSizeStyling =
                    if config.appearance == Small then
                        Css.batch
                            [ width (rem 0.25)
                            , height (rem 0.75)
                            ]

                    else
                        Css.batch
                            [ width (rem 0.5)
                            , height (rem 0.813)
                            ]
            in
            Html.span
                [ class "nfe-checkbox"
                , css
                    [ displayFlex
                    , flex none
                    , checkboxSizeStyling
                    , backgroundColor Colors.white
                    , border3 (rem 0.125) solid Css.transparent
                    , if isDisabled then
                        borderColor Colors.mediumGray

                      else
                        Themes.borderColor Colors.nordeaBlue
                    , borderRadius (rem 0.125)
                    , borderColor Colors.darkRed
                        |> styleIf (config.hasError && config.appearance == Simple)
                    , borderColor Colors.mediumGray
                        |> styleIf (config.hasError && List.member config.appearance [ Standard, Small, ListStyle ])
                    , position relative
                    , boxSizing borderBox

                    -- Styling the checkmark
                    , after
                        [ Css.property "content" "''"
                        , display none
                        , position absolute
                        , top (rem -0.0625)
                        , left (rem 0.25)
                        , checkmarkSizeStyling
                        , transforms [ rotate (deg 45) ]
                        , if isDisabled then
                            border3 (rem 0.0625) solid Colors.nordeaGray

                          else
                            border3 (rem 0.0625) solid Colors.white
                        , if config.appearance == Small then
                            borderWidth4 (rem 0) (rem 0.0625) (rem 0.0625) (rem 0)

                          else
                            borderWidth4 (rem 0) (rem 0.125) (rem 0.125) (rem 0)
                        , boxSizing borderBox
                        ]
                    ]
                ]
                []

        appearanceStyle =
            let
                commonNonSimpleStyles =
                    Css.batch
                        [ border3 (rem 0.0625) solid transparent
                        , Themes.backgroundColor Colors.cloudBlue |> styleIf config.isChecked
                        , transition [ Css.Transitions.borderColor 100, Css.Transitions.boxShadow 100 ]
                        ]

                commonStandardStyles =
                    Css.batch
                        [ borderRadius (rem 0.25)
                        , borderColor Colors.mediumGray |> styleIf (not config.isChecked)
                        , borderColor Colors.darkRed |> styleIf config.hasError
                        , hover
                            [ Themes.borderColor Colors.nordeaBlue |> styleIf (not config.hasError)
                            , Themes.backgroundColor Colors.cloudBlue
                            ]
                            |> styleIf (not isDisabled)
                        ]
            in
            case config.appearance of
                ListStyle ->
                    Css.batch
                        [ gap (rem 0.5)
                        , commonNonSimpleStyles
                        , padding2 (rem 0.5) (rem 1)
                        , flexBasis (pct 100)
                        , borderColor Colors.mediumGray
                        , borderColor Colors.darkRed |> styleIf config.hasError
                        , Css.firstOfType [ borderTopLeftRadius (rem 0.5), borderTopRightRadius (rem 0.5) ]
                        , Css.lastOfType [ borderBottomLeftRadius (rem 0.5), borderBottomRightRadius (rem 0.5) ]
                        , pseudoClass "not(label:first-of-type):not(:hover)" [ borderTopColor transparent ] |> styleIf (not config.isChecked)
                        , pseudoClass "not(label:first-of-type)" [ Css.marginTop (rem -0.0625) ]
                        , hover [ Themes.backgroundColor Colors.cloudBlue ] |> styleIf (not isDisabled)
                        ]

                Simple ->
                    Css.batch
                        [ gap (rem 0.5)
                        ]

                Small ->
                    Css.batch
                        [ gap (rem 0.25)
                        , padding4 (rem 0.25) (rem 0.5) (rem 0.25) (rem 0.25)
                        , height (rem 1.5)
                        , commonNonSimpleStyles
                        , commonStandardStyles
                        ]

                Standard ->
                    Css.batch
                        [ gap (rem 0.5)
                        , padding2 (rem 0.5) (rem 1)
                        , minHeight (rem 2.5)
                        , commonNonSimpleStyles
                        , commonStandardStyles
                        ]

        notDisabledSpecificStyling =
            let
                hoverShadow =
                    Css.property "box-shadow" ("0rem 0rem 0rem 0.0625rem " ++ Themes.colorVariable Colors.mediumBlue)
            in
            Css.batch
                [ pseudoClass "hover .nfe-checkbox" [ hoverShadow ]
                , pseudoClass "focus-within .nfe-checkbox" [ hoverShadow ]
                , cursor pointer
                ]
                |> styleIf (not isDisabled)

        label =
            if config.appearance == Small then
                Text.textTinyLight |> Text.view [] [ config.label ]

            else
                config.label
    in
    Html.label
        (css
            [ display inlineFlex
            , alignItems center
            , boxSizing borderBox
            , position relative
            , notDisabledSpecificStyling
            , appearanceStyle
            ]
            :: attrs
        )
        [ Html.input
            ([ type_ "checkbox"
             , name config.name
             , Attrs.checked config.isChecked
             , onCheck config.onCheck
             , disabled isDisabled
             , css
                [ position absolute
                , opacity (num 0)
                , width (rem 0)
                , height (rem 0)

                -- when <input> is checked, show checkmark
                , pseudoClass "checked ~ .nfe-checkbox"
                    [ after [ display block ]
                    , if isDisabled then
                        backgroundColor Colors.mediumGray

                      else
                        Themes.backgroundColor Colors.nordeaBlue
                    ]
                ]
             ]
                ++ config.inputAttrs
            )
            []
        , checkbox
        , label
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


withInputAttrs : List (Attribute msg) -> Checkbox msg -> Checkbox msg
withInputAttrs attrs (Checkbox config) =
    Checkbox { config | inputAttrs = attrs }
