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
        , block
        , border3
        , borderBox
        , borderColor
        , borderRadius
        , borderWidth
        , boxSizing
        , center
        , cursor
        , display
        , flex
        , height
        , hover
        , inlineFlex
        , justifyContent
        , left
        , minHeight
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
        , transform
        , translate2
        , transparent
        , width
        )
import Css.Transitions exposing (transition)
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attrs exposing (css, disabled, name, type_)
import Html.Styled.Events as Events
import Nordea.Html exposing (showIf, styleIf)
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
        isDisabled =
            List.member (Attrs.disabled True) attrs

        radiomark =
            Html.span
                [ Attrs.class "nfe-radiomark"
                , css
                    [ position relative
                    , width (rem 1.375)
                    , height (rem 1.375)
                    , flex none
                    , backgroundColor Colors.white
                    , border3 (rem 0.125) solid Css.transparent
                    , if isDisabled then
                        borderColor Colors.mediumGray

                      else
                        Themes.borderColor Colors.nordeaBlue
                    , borderColor Colors.darkRed
                        |> styleIf (config.showError && config.appearance == Simple)
                    , borderColor Colors.mediumGray
                        |> styleIf (config.showError && config.appearance == Standard)
                    , borderRadius (pct 50)
                    , boxSizing borderBox
                    , after
                        [ Css.property "content" "''"
                        , position absolute
                        , top (pct 50)
                        , left (pct 50)
                        , transform (translate2 (pct -50) (pct -50))
                        , width (rem 0.75)
                        , height (rem 0.75)
                        , if isDisabled then
                            backgroundColor Colors.nordeaGray

                          else
                            Themes.backgroundColor Colors.nordeaBlue
                        , borderRadius (pct 50)
                        , boxSizing borderBox
                        , display none
                        ]
                    ]
                ]
                []

        appearanceStyle =
            case config.appearance of
                Simple ->
                    Css.batch []

                Standard ->
                    Css.batch
                        [ padding2 (rem 0.5) (rem 0.75)
                        , border3 (rem 0.0625) solid transparent
                        , borderRadius (rem 0.25)
                        , minHeight (rem 2.5)
                        , justifyContent center
                        , Themes.backgroundColor Colors.cloudBlue
                            |> styleIf config.isSelected
                        , transition
                            [ Css.Transitions.borderColor 100
                            , Css.Transitions.backgroundColor 100
                            ]
                        , if config.showError then
                            borderColor Colors.darkRed

                          else
                            borderColor Colors.mediumGray
                        , Css.batch
                            [ Themes.color Colors.nordeaBlue
                            , Themes.borderColor Colors.nordeaBlue |> styleIf (not config.showError)
                            ]
                            |> styleIf (config.isSelected && not isDisabled)
                        , hover
                            [ Themes.borderColor Colors.transparent |> styleIf (not config.showError)
                            , Themes.backgroundColor Colors.cloudBlue
                            , Themes.color Colors.nordeaBlue
                            ]
                            |> styleIf (not config.isSelected && not isDisabled)
                        , pseudoClass "focus-within"
                            [ Themes.backgroundColor Colors.cloudBlue
                            , Themes.color Colors.nordeaBlue
                            , borderWidth (rem 0.25)

                            -- we must adjust the padding after increasing the border to avoid movement
                            , padding2 (rem (0.5 - 0.1875)) (rem (0.75 - 0.1875))
                            ]
                            |> styleIf (not isDisabled)
                        ]

        notDisabledSpecificStyling =
            let
                boxShadow =
                    Css.property "box-shadow" ("0rem 0rem 0rem 0.0625rem " ++ Themes.colorVariable Colors.mediumBlue)
            in
            Css.batch
                [ pseudoClass "hover .nfe-radiomark" [ boxShadow ]
                , pseudoClass "focus-within .nfe-radiomark" [ boxShadow ]
                , cursor pointer
                ]
                |> styleIf (not isDisabled)
    in
    Html.label
        (css
            [ display inlineFlex
            , Css.property "gap" "0.5rem"
            , alignItems center
            , boxSizing borderBox
            , position relative
            , notDisabledSpecificStyling
            , appearanceStyle
            ]
            :: attrs
        )
        [ Html.input
            [ type_ "radio"
            , name config.name
            , Attrs.checked config.isSelected
            , Events.onCheck (\_ -> config.onCheck)
            , disabled isDisabled
            , css
                [ position absolute
                , opacity (num 0)
                , height (rem 0)
                , width (rem 0)

                -- when <input> is checked, show radiomark
                , pseudoClass "checked ~ .nfe-radiomark::after" [ display block ]
                ]
            ]
            []
        , radiomark |> showIf (config.appearance /= Standard)
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
