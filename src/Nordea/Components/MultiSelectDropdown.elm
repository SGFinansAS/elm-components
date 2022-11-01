module Nordea.Components.MultiSelectDropdown exposing
    ( MultiSelectDropdown
    , init
    , view
    , withHasFocus
    , withHintText
    , withLabel
    , withOptions
    , withPlaceholder
    , withRequirednessHint
    )

import Css
    exposing
        ( absolute
        , alignItems
        , backgroundColor
        , block
        , border3
        , borderBottom3
        , borderBottomLeftRadius
        , borderBottomRightRadius
        , borderBox
        , borderLeft3
        , borderRadius4
        , borderRight3
        , boxSizing
        , center
        , color
        , column
        , cursor
        , display
        , displayFlex
        , fitContent
        , flexDirection
        , fontSize
        , height
        , hover
        , inherit
        , int
        , justifyContent
        , left
        , lineHeight
        , listStyle
        , margin
        , marginBottom
        , maxHeight
        , maxWidth
        , minWidth
        , none
        , overflowY
        , padding
        , padding3
        , padding4
        , pct
        , pointer
        , position
        , relative
        , rem
        , right
        , row
        , scroll
        , solid
        , spaceBetween
        , top
        , transparent
        , zIndex
        )
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes exposing (css, name, tabindex)
import Html.Styled.Events as Events
import Json.Decode as Decode
import Maybe.Extra as Maybe
import Nordea.Components.Checkbox as Checkbox
import Nordea.Components.Util.Hint as Hint
import Nordea.Components.Util.Label as Label
import Nordea.Components.Util.RequirednessHint as RequirednessHint exposing (RequirednessHint)
import Nordea.Html as Html
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Icons as Icon


type alias MultiSelectDropdown msg =
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


init : { onFocus : Bool -> msg } -> MultiSelectDropdown msg
init { onFocus } =
    { label = ""
    , placeholder = ""
    , hint = Nothing
    , options = []
    , onFocus = onFocus
    , hasFocus = True
    , requirednessHint = Nothing
    }


view : List (Attribute msg) -> MultiSelectDropdown msg -> Html msg
view attrs dropdown =
    let
        isLabel =
            not (String.isEmpty dropdown.label)

        isRequirednessHint =
            Maybe.isJust dropdown.requirednessHint

        viewSelectItems =
            let
                viewOption option =
                    Html.li
                        [ Events.custom "click"
                            (Decode.succeed
                                { message = option.onCheck (not option.isChecked)
                                , stopPropagation = True
                                , preventDefault = True
                                }
                            )
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
                        , margin (rem 0)
                        , padding (rem 0)
                        ]
                    ]
                    (dropdown.options |> List.map viewOption)
                ]
    in
    Html.fieldset
        ([ Events.on "focusout" (Decode.succeed (dropdown.onFocus False))
         , Events.onClick (dropdown.onFocus (not dropdown.hasFocus))
         , tabindex 0
         , css
            [ minWidth fitContent
            , zIndex (int 1)
            , displayFlex
            , flexDirection column
            , margin (rem 0)
            , padding (rem 0)
            , Css.property "border" "none"
            , position relative
            ]
         ]
            ++ attrs
        )
        [ Html.row [ css [ displayFlex, justifyContent spaceBetween, marginBottom (rem 0.2) ] ]
            [ Label.init { label = dropdown.label } |> Label.withAsLegend |> Label.view []
            , dropdown.requirednessHint |> Html.viewMaybe RequirednessHint.view
            ]
            |> Html.showIf (isLabel || isRequirednessHint)
        , Html.select [ css [ display none ] ]
            (dropdown.options |> List.map (\option -> Html.option [ name option.name ] [ Html.text option.label ]))
        , Html.div
            [ css
                [ backgroundColor transparent
                , padding4 (rem 0.5) (rem 0.75) (rem 0.5) (rem 0.75)
                , border3 (rem 0.0625) solid Colors.grayMedium
                , if dropdown.hasFocus then
                    borderRadius4 (rem 0.25) (rem 0.25) (rem 0.0) (rem 0.0)

                  else
                    borderRadius4 (rem 0.25) (rem 0.25) (rem 0.25) (rem 0.25)
                , fontSize (rem 1.0)
                , lineHeight (rem 1.4)
                , color inherit
                , cursor pointer
                , displayFlex
                , alignItems center
                , justifyContent spaceBetween
                , Css.property "appearance" "none"
                ]
            ]
            [ Html.text dropdown.placeholder
            , Icon.chevronDownFilled [ css [ height (rem 1.5) ] ]
            ]
        , viewSelectItems
        , dropdown.hint |> Html.viewMaybe (\hint -> Hint.init { text = hint } |> Hint.view)
        ]


withLabel : String -> MultiSelectDropdown msg -> MultiSelectDropdown msg
withLabel label dropdown =
    { dropdown | label = label }


withPlaceholder : String -> MultiSelectDropdown msg -> MultiSelectDropdown msg
withPlaceholder placeholder dropdown =
    { dropdown | placeholder = placeholder }


withOptions : List (Option msg) -> MultiSelectDropdown msg -> MultiSelectDropdown msg
withOptions options dropdown =
    { dropdown | options = options }


withHintText : Maybe String -> MultiSelectDropdown msg -> MultiSelectDropdown msg
withHintText hint dropdown =
    { dropdown | hint = hint }


withRequirednessHint : Maybe RequirednessHint -> MultiSelectDropdown msg -> MultiSelectDropdown msg
withRequirednessHint requirednessHint dropdown =
    { dropdown | requirednessHint = requirednessHint }


withHasFocus : Bool -> MultiSelectDropdown msg -> MultiSelectDropdown msg
withHasFocus hasFocus dropdown =
    { dropdown | hasFocus = hasFocus }
