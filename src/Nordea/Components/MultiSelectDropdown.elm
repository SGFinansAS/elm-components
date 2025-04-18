module Nordea.Components.MultiSelectDropdown exposing
    ( MultiSelectDropdown
    , init
    , view
    , withHasFocus
    , withHintText
    , withLabel
    , withOptionGroups
    , withOptions
    , withPlaceholder
    , withRequirednessHint
    )

import Css exposing (absolute, alignItems, backgroundColor, border3, borderBottomLeftRadius, borderBottomRightRadius, borderBox, borderRadius4, boxSizing, center, color, column, cursor, display, displayFlex, flexDirection, height, hover, int, justifyContent, left, listStyle, margin, marginLeft, marginTop, maxHeight, none, overflowY, padding, padding4, pct, pointer, position, relative, rem, right, scroll, solid, spaceBetween, start, top, width, zIndex)
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes exposing (css, tabindex)
import Html.Styled.Events as Events
import Json.Decode as Decode
import Nordea.Components.Checkbox as Checkbox
import Nordea.Components.Label as Label exposing (RequirednessHint)
import Nordea.Components.OnClickOutsideSupport as OnClickOutsideSupport
import Nordea.Components.Text as Text
import Nordea.Html.Events as Events
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Icons as Icon
import Nordea.Themes as Themes


type alias OptionGroup msg =
    { groupLabel : Maybe String, options : List (Option msg) }


type alias MultiSelectDropdown msg =
    { label : String
    , placeholder : String
    , hint : Maybe String
    , optionGroups : List (OptionGroup msg)
    , onFocus : Bool -> msg
    , hasFocus : Bool
    , requirednessHint : Maybe RequirednessHint
    , newOutsideClickListener : Bool
    }


type alias Option msg =
    { name : String
    , label : String
    , isChecked : Bool
    , onCheck : Bool -> msg
    }


init : { onFocus : Bool -> msg, newOutsideClickListener : Bool } -> MultiSelectDropdown msg
init { onFocus, newOutsideClickListener } =
    { label = ""
    , placeholder = ""
    , hint = Nothing
    , optionGroups = []
    , onFocus = onFocus
    , hasFocus = True
    , requirednessHint = Nothing
    , newOutsideClickListener = newOutsideClickListener
    }


view : List (Attribute msg) -> MultiSelectDropdown msg -> Html msg
view attrs dropdown =
    let
        viewSelectItems index optionGroup =
            let
                viewOptionGroup =
                    (case optionGroup.groupLabel of
                        Nothing ->
                            []

                        Just groupLabel ->
                            [ Html.li
                                [ css
                                    [ displayFlex
                                    , height (rem 1.5)
                                    , alignItems center
                                    , justifyContent start
                                    , marginLeft (rem 0.75)
                                    , if index == 0 then
                                        marginTop (rem 0.75)

                                      else
                                        marginTop (rem 0)
                                    ]
                                ]
                                [ Text.textTinyLight
                                    |> Text.view [ css [ color Colors.darkGray ] ] [ Html.text groupLabel ]
                                ]
                            ]
                    )
                        ++ List.map viewOption optionGroup.options

                viewOption option =
                    Html.li
                        []
                        [ Checkbox.init option.name (Html.text option.label) option.onCheck
                            |> Checkbox.withIsChecked option.isChecked
                            |> Checkbox.withAppearance Checkbox.Simple
                            |> Checkbox.view
                                [ css
                                    [ width (pct 100)
                                    , hover [ backgroundColor Colors.coolGray ]
                                    , padding (rem 0.5)
                                    ]
                                ]
                        ]
            in
            Html.ul
                [ css
                    [ left (rem 0)
                    , margin (rem 0)
                    , padding (rem 0)
                    , listStyle none
                    , if dropdown.hasFocus then
                        displayFlex

                      else
                        display none
                    , flexDirection column
                    , backgroundColor Colors.white
                    ]
                ]
                viewOptionGroup
    in
    Label.init
        dropdown.label
        Label.GroupLabel
        |> Label.withRequirednessHint dropdown.requirednessHint
        |> Label.withHintText dropdown.hint
        |> Label.view
            (Events.on "outsideclick" (Decode.succeed (dropdown.onFocus False))
                :: css [ position relative ]
                :: attrs
            )
            [ OnClickOutsideSupport.view { isActive = dropdown.hasFocus, useNewBehaviour = dropdown.newOutsideClickListener }
            , Html.div
                [ Events.onClick (dropdown.onFocus (not dropdown.hasFocus))
                , Events.onKeyDown
                    (\key ->
                        case key of
                            Events.Enter ->
                                dropdown.onFocus (not dropdown.hasFocus)

                            Events.Space ->
                                dropdown.onFocus (not dropdown.hasFocus)

                            Events.Esc ->
                                dropdown.onFocus False
                    )
                , tabindex 0
                , css
                    [ width (pct 100)
                    , displayFlex
                    , cursor pointer
                    , alignItems center
                    , justifyContent spaceBetween
                    , backgroundColor Colors.white
                    , padding4 (rem 0.25) (rem 0.25) (rem 0.25) (rem 0.75)
                    , border3 (rem 0.0625) solid Colors.mediumGray
                    , if dropdown.hasFocus then
                        Css.batch
                            [ borderRadius4 (rem 0.25) (rem 0.25) (rem 0.0) (rem 0.0)
                            , Themes.borderColor Colors.nordeaBlue
                            ]

                      else
                        borderRadius4 (rem 0.25) (rem 0.25) (rem 0.25) (rem 0.25)
                    ]
                ]
                [ Html.text dropdown.placeholder
                , Icon.chevronDownFilled []
                ]
            , Html.ul
                [ css
                    [ position absolute
                    , top (pct 100)
                    , left (rem 0)
                    , right (rem 0)
                    , zIndex (int 1)
                    , overflowY scroll
                    , maxHeight (rem 16.75)
                    , listStyle none
                    , margin (rem 0)
                    , padding (rem 0)
                    , if dropdown.hasFocus then
                        displayFlex

                      else
                        display none
                    , flexDirection column
                    , backgroundColor Colors.white
                    , border3 (rem 0.0625) solid Colors.mediumGray
                    , Themes.borderColor Colors.nordeaBlue
                    , borderBottomLeftRadius (rem 0.25)
                    , borderBottomRightRadius (rem 0.25)
                    , boxSizing borderBox
                    ]
                ]
                (List.indexedMap viewSelectItems dropdown.optionGroups)
            ]


withLabel : String -> MultiSelectDropdown msg -> MultiSelectDropdown msg
withLabel label dropdown =
    { dropdown | label = label }


withPlaceholder : String -> MultiSelectDropdown msg -> MultiSelectDropdown msg
withPlaceholder placeholder dropdown =
    { dropdown | placeholder = placeholder }


withOptionGroups : List (OptionGroup msg) -> MultiSelectDropdown msg -> MultiSelectDropdown msg
withOptionGroups optionGroups dropdown =
    { dropdown | optionGroups = optionGroups }


withOptions : List (Option msg) -> MultiSelectDropdown msg -> MultiSelectDropdown msg
withOptions options dropdown =
    { dropdown | optionGroups = [ { groupLabel = Nothing, options = options } ] }


withHintText : Maybe String -> MultiSelectDropdown msg -> MultiSelectDropdown msg
withHintText hint dropdown =
    { dropdown | hint = hint }


withRequirednessHint : Maybe RequirednessHint -> MultiSelectDropdown msg -> MultiSelectDropdown msg
withRequirednessHint requirednessHint dropdown =
    { dropdown | requirednessHint = requirednessHint }


withHasFocus : Bool -> MultiSelectDropdown msg -> MultiSelectDropdown msg
withHasFocus hasFocus dropdown =
    { dropdown | hasFocus = hasFocus }
