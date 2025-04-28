module Nordea.Components.MultiSelectDropdown exposing
    ( MultiSelectDropdown
    , init
    , view
    , withHasFocus
    , withHintText
    , withInput
    , withLabel
    , withOptionGroups
    , withOptions
    , withPlaceholder
    , withRequirednessHint
    )

import Css exposing (absolute, alignItems, backgroundColor, border3, borderBottomLeftRadius, borderBottomRightRadius, borderBox, borderRadius4, borderStyle, boxShadow, boxSizing, center, color, column, cursor, display, displayFlex, flexBasis, flexDirection, flexGrow, fontSize, height, hover, important, int, justifyContent, left, listStyle, margin, marginLeft, marginTop, maxHeight, minWidth, none, num, outline, overflowY, padding, padding4, paddingLeft, pct, pointer, pointerEvents, position, relative, rem, right, scroll, solid, spaceBetween, start, top, width, zIndex)
import Html.Styled as Html exposing (Attribute, Html, input)
import Html.Styled.Attributes as Attrs exposing (class, css, placeholder, tabindex, value)
import Html.Styled.Events as Events exposing (onInput)
import Json.Decode as Decode
import Maybe.Extra as Maybe
import Nordea.Components.Checkbox as Checkbox
import Nordea.Components.Label as Label exposing (RequirednessHint)
import Nordea.Components.OutsideEventSupport as OutsideEventSupport
import Nordea.Components.Text as Text
import Nordea.Html exposing (attrEmpty, attrIf, styleIf)
import Nordea.Html.Events as Events
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Icons as Icon
import Nordea.Themes as Themes
import Nordea.Utils.List as List


type alias OptionGroup msg =
    { groupLabel : Maybe String, options : List (Option msg) }


type alias InputProperties msg =
    { onInput : String -> msg
    , input : String
    , uniqueId : String
    }


type alias MultiSelectDropdown msg =
    { label : String
    , placeholder : String
    , hint : Maybe String
    , optionGroups : List (OptionGroup msg)
    , onFocus : Bool -> msg
    , hasFocus : Bool
    , requirednessHint : Maybe RequirednessHint
    , newOutsideClickListener : Bool
    , inputProperties : Maybe (InputProperties msg)
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
    , inputProperties = Nothing
    }


view : List (Attribute msg) -> MultiSelectDropdown msg -> Html msg
view attrs dropdown =
    let
        currentInput =
            dropdown.inputProperties |> Maybe.map .input |> Maybe.withDefault ""

        hasTextInput =
            dropdown.inputProperties |> Maybe.isJust

        viewInput inputProps =
            input
                [ css
                    [ outline none
                    , important (boxShadow none)
                    , borderStyle none
                    , fontSize (rem 1)
                    , height (rem 1.75)
                    , width (pct 100)
                    , minWidth (pct 70)
                    , flexGrow (num 1)
                    , flexBasis (rem 10)
                    , paddingLeft (rem 1)
                    ]
                , placeholder dropdown.placeholder
                , value currentInput
                , onInput inputProps.onInput
                , Attrs.attribute "aria-controls" inputProps.uniqueId
                , Attrs.attribute "role" "combobox"
                , Attrs.attribute "aria-expanded"
                    (if dropdown.hasFocus then
                        "true"

                     else
                        "false"
                    )
                ]
                []

        icon =
            case dropdown.inputProperties of
                Just _ ->
                    Icon.search
                        [ css
                            [ styleIf (Maybe.isJust dropdown.inputProperties) (position absolute)
                            , left (rem 0.5)
                            , pointerEvents none
                            , color Colors.gray
                            , width (rem 1)
                            , height (rem 1)
                            ]
                        ]

                Nothing ->
                    Icon.chevronDownFilled []

        selectItems =
            dropdown.optionGroups |> List.indexedMap (viewSelectItems dropdown) |> List.filterMap identity
    in
    Label.init
        dropdown.label
        Label.GroupLabel
        |> Label.withRequirednessHint dropdown.requirednessHint
        |> Label.withHintText dropdown.hint
        |> Label.view
            ([ Events.on "focusin" (Decode.succeed (dropdown.onFocus True))
                |> attrIf hasTextInput
             , css [ position relative ]
             ]
                ++ attrs
            )
            [ OutsideEventSupport.view { msg = dropdown.onFocus False, isActive = dropdown.hasFocus, eventTypes = [ OutsideEventSupport.OutsideClick, OutsideEventSupport.OutsideFocus ] }
            , Html.div
                [ attrIf (not hasTextInput) (Events.onClick (dropdown.onFocus (not dropdown.hasFocus)))
                , attrIf (not hasTextInput)
                    (Events.onKeyDown
                        (\key ->
                            case key of
                                Events.Enter ->
                                    dropdown.onFocus (not dropdown.hasFocus)

                                Events.Space ->
                                    dropdown.onFocus (not dropdown.hasFocus)

                                Events.Esc ->
                                    dropdown.onFocus False
                        )
                    )
                , attrIf (not hasTextInput) (tabindex 0)
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
                [ dropdown.inputProperties |> Maybe.map viewInput |> Maybe.withDefault (Html.text dropdown.placeholder)
                , icon
                ]
            , Html.ul
                [ case dropdown.inputProperties of
                    Just inputProps ->
                        Attrs.id inputProps.uniqueId

                    Nothing ->
                        attrEmpty
                , css
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
                    , border3
                        (if List.isNotEmpty selectItems then
                            rem 0.0625

                         else
                            rem 0
                        )
                        solid
                        Colors.mediumGray
                    , Themes.borderColor Colors.nordeaBlue
                    , borderBottomLeftRadius (rem 0.25)
                    , borderBottomRightRadius (rem 0.25)
                    , boxSizing borderBox
                    ]
                ]
                selectItems
            ]


viewSelectItems : MultiSelectDropdown msg -> Int -> OptionGroup msg -> Maybe (Html msg)
viewSelectItems dropdown index orgOptionGroup =
    let
        maybeFilteredOptionGroup : Maybe (OptionGroup msg)
        maybeFilteredOptionGroup =
            let
                isOk value =
                    case dropdown.inputProperties of
                        Nothing ->
                            True

                        Just inputProperties ->
                            value.label
                                |> String.toLower
                                |> String.contains (String.toLower inputProperties.input)

                matchingItems =
                    orgOptionGroup.options |> List.filter isOk
            in
            if List.isEmpty matchingItems then
                Nothing

            else
                Just { orgOptionGroup | options = matchingItems }

        viewOptionGroup optionGroup =
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
                ++ (optionGroup.options |> List.map viewOption)

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
    maybeFilteredOptionGroup
        |> Maybe.map
            (\filteredOptionGroup ->
                Html.li []
                    [ Html.ul
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
                        (viewOptionGroup filteredOptionGroup)
                    ]
            )


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


withInput : String -> (String -> msg) -> String -> MultiSelectDropdown msg -> MultiSelectDropdown msg
withInput input onInput uniqueId dropdown =
    { dropdown | inputProperties = Just { input = input, onInput = onInput, uniqueId = uniqueId } }
