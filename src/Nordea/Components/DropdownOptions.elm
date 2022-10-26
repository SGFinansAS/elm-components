module Nordea.Components.DropdownOptions exposing
    ( DropdownOptions
    , init
    , view
    , withHasFocus
    , withHintText
    , withLabel
    , withOptions
    , withRequirednessHint
    )

import Css
    exposing
        ( absolute
        , after
        , alignItems
        , backgroundColor
        , block
        , border3
        , borderBottom3
        , borderBottomLeftRadius
        , borderBottomRightRadius
        , borderBox
        , borderLeft3
        , borderRadius
        , borderRadius4
        , borderRight3
        , borderWidth4
        , boxSizing
        , center
        , color
        , column
        , cursor
        , deg
        , display
        , displayFlex
        , flex
        , flexDirection
        , focus
        , fontSize
        , height
        , hover
        , inherit
        , justifyContent
        , left
        , lineHeight
        , listStyle
        , marginBottom
        , maxHeight
        , maxWidth
        , none
        , num
        , opacity
        , outline
        , overflowY
        , padding
        , padding3
        , padding4
        , pct
        , pointer
        , position
        , pseudoClass
        , relative
        , rem
        , right
        , rotate
        , row
        , scroll
        , solid
        , spaceBetween
        , top
        , transforms
        , transparent
        , width
        )
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attrs exposing (class, css, name, tabindex, type_)
import Html.Styled.Events as Events
import Json.Decode as Decode
import Nordea.Components.Checkbox as Checkbox
import Nordea.Components.Common as Common
import Nordea.Components.Util.Hint as Hint
import Nordea.Components.Util.RequirednessHint as RequirednessHint exposing (RequirednessHint)
import Nordea.Html as Html
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Icons as Icon
import Nordea.Themes as Themes


type alias DropdownOptions msg =
    { label : String
    , placeholder : String
    , hint : Maybe String
    , options : List (Option msg)
    , onFocus : Bool -> msg
    , hasFocus : Bool
    , requirednessHint : Maybe RequirednessHint
    }


type alias Option msg =
    { name : String, label : String, isChecked : Bool, onCheck : Bool -> msg }


init : { onFocus : Bool -> msg } -> DropdownOptions msg
init { onFocus } =
    { label = ""
    , placeholder = ""
    , hint = Nothing
    , options = []
    , onFocus = onFocus
    , hasFocus = True
    , requirednessHint = Nothing
    }


view : List (Attribute msg) -> DropdownOptions msg -> Html msg
view attrs dropdown =
    let
        viewSelectItems =
            let
                viewOption option =
                    Html.li
                        [ Events.onClick (option.onCheck (not option.isChecked))
                        , css
                            [ maxWidth (pct 100)
                            , cursor pointer
                            , hover [ backgroundColor Colors.coolGray ]
                            , displayFlex
                            , flexDirection row
                            , padding (rem 0.5)
                            , alignItems center
                            , Css.property "gap" "0.5rem"
                            ]
                        ]
                        [ Checkbox.init option.name (Html.text option.label) option.onCheck
                            |> Checkbox.withIsChecked option.isChecked
                            |> Checkbox.withAppearance Checkbox.Simple
                            |> Checkbox.view []
                        ]

                dropdownStyles =
                    Css.batch
                        [ backgroundColor Colors.white
                        , borderBottom3 (rem 0.0625) solid Colors.grayMedium
                        , borderLeft3 (rem 0.0625) solid Colors.grayMedium
                        , borderRight3 (rem 0.0625) solid Colors.grayMedium
                        , borderBottomLeftRadius (rem 0.25)
                        , borderBottomRightRadius (rem 0.25)
                        , boxSizing borderBox
                        , padding3 (rem 0.5) (rem 0) (rem 0.0)
                        ]
            in
            Html.div
                [ css
                    [ displayFlex
                    , flexDirection column
                    , position absolute
                    , top (pct 100)
                    , left (rem 0)
                    , right (rem 0)
                    , if dropdown.hasFocus then
                        display block

                      else
                        display none
                    ]
                ]
                [ Html.ul
                    [ css
                        [ overflowY scroll
                        , maxHeight (rem 16.75)
                        , dropdownStyles
                        , listStyle none
                        ]
                    ]
                    (dropdown.options |> List.map viewOption)
                ]
    in
    Html.column attrs
        [ Html.row [ css [ displayFlex, justifyContent spaceBetween, marginBottom (rem 0.2) ] ]
            [ Common.viewLabel { label = dropdown.label, isError = False } []
            , dropdown.requirednessHint |> Html.viewMaybe RequirednessHint.view
            ]
        , Html.div
            [ class "nordea-select"
            , Events.on "focusout" (Decode.succeed (dropdown.onFocus False))
            , Events.on "focusin" (Decode.succeed (dropdown.onFocus True))
            , css [ position relative ]
            , tabindex -1
            ]
            [ Html.select
                [ css [ display none ] ]
                (dropdown.options |> List.map (\option -> Html.option [ name option.name ] [ Html.text option.label ]))
            , Html.div
                [ class "select-selected"
                , tabindex -1
                , css
                    [ height (rem 3)
                    , width (pct 100)
                    , backgroundColor transparent
                    , padding4 (rem 0.5) (rem 1) (rem 0.5) (rem 1)
                    , border3 (rem 0.0625) solid Colors.grayMedium
                    , borderRadius4 (rem 0.25) (rem 0.25) (rem 0.0) (rem 0.0)
                    , fontSize (rem 1.0)
                    , lineHeight (rem 1.4)
                    , color inherit
                    , cursor pointer
                    , displayFlex
                    , alignItems center
                    , justifyContent spaceBetween
                    , focus
                        [ Css.property "box-shadow" ("0rem 0rem 0rem 0.0625rem " ++ Themes.colorVariable Themes.SecondaryColor Colors.blueNordea)
                        , outline none
                        ]
                    , Css.property "appearance" "none"
                    , Css.property "-moz-appearance" "none"
                    , Css.property "-webkit-appearance" "none"
                    ]
                ]
                [ Html.text "Select options"
                , Icon.chevronDownFilled [ css [ height (rem 1.5) ] ]
                ]
            , viewSelectItems
            ]
        , dropdown.hint |> Html.viewMaybe (\hint -> Hint.init { text = hint } |> Hint.view)
        ]


withLabel : String -> DropdownOptions msg -> DropdownOptions msg
withLabel label dropdown =
    { dropdown | label = label }


withOptions : List (Option msg) -> DropdownOptions msg -> DropdownOptions msg
withOptions options dropdown =
    { dropdown | options = options }


withHintText : Maybe String -> DropdownOptions msg -> DropdownOptions msg
withHintText hint dropdown =
    { dropdown | hint = hint }


withRequirednessHint : Maybe RequirednessHint -> DropdownOptions msg -> DropdownOptions msg
withRequirednessHint requirednessHint dropdown =
    { dropdown | requirednessHint = requirednessHint }


withHasFocus : Bool -> DropdownOptions msg -> DropdownOptions msg
withHasFocus hasFocus dropdown =
    { dropdown | hasFocus = hasFocus }
