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
    , withSelected
    )

import Css exposing (absolute, alignItems, auto, backgroundColor, border, border3, borderBottomLeftRadius, borderBottomRightRadius, borderBox, borderRadius, borderRadius4, bottom, boxSizing, center, color, column, cursor, deg, display, displayFlex, ellipsis, flexBasis, flexDirection, flexGrow, fontSize, height, hidden, hover, inlineFlex, int, justifyContent, left, listStyle, margin, marginBottom, marginLeft, marginRight, marginTop, maxHeight, minWidth, noWrap, none, num, overflow, overflowY, padding, padding2, padding4, paddingRight, pct, pointer, pointerEvents, position, relative, rem, right, rotate, scroll, solid, spaceBetween, start, textOverflow, top, transforms, translateY, whiteSpace, width, zIndex)
import Css.Global exposing (descendants, typeSelector)
import Html.Extra as Html
import Html.Styled as Html exposing (Attribute, Html, div)
import Html.Styled.Attributes as Attrs exposing (css, tabindex)
import Html.Styled.Events as Events exposing (onClick)
import Json.Decode as Decode
import Maybe.Extra as Maybe
import Nordea.Components.Checkbox as Checkbox
import Nordea.Components.Label as Label exposing (RequirednessHint)
import Nordea.Components.OnClickOutsideSupport as OnClickOutsideSupport
import Nordea.Components.Text as Text
import Nordea.Components.TextInput as TextInput
import Nordea.Html exposing (showIf, styleIf)
import Nordea.Html.Events as Events
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Icons as Icon
import Nordea.Themes as Themes


type alias OptionGroup msg =
    { groupLabel : Maybe String, options : List (Option msg) }


type alias InputProperties msg =
    { onInput : String -> msg
    , input : String
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
    , input : Maybe (InputProperties msg)
    , selected : Maybe (List String)
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
    , input = Nothing
    , selected = Nothing
    }


view : List (Attribute msg) -> MultiSelectDropdown msg -> Html msg
view attrs dropdown =
    let
        textInput : InputProperties msg -> Html msg
        textInput inputProps =
            TextInput.init inputProps.input
                |> TextInput.withOnInput inputProps.onInput
                |> TextInput.withPlaceholder dropdown.placeholder
                |> TextInput.withoutBorder
                |> TextInput.withInputAttrs
                    [ Attrs.attribute "role" "combobox"
                    , Attrs.attribute "aria-expanded"
                        (if dropdown.hasFocus then
                            "true"

                         else
                            "false"
                        )
                    ]
                |> TextInput.view
                    [ css
                        [ width (pct 100)
                        , descendants
                            [ typeSelector "input"
                                [ paddingRight (rem 2.5) ]
                            ]
                        , minWidth (rem 5)
                        , flexGrow (num 1)
                        , flexBasis (rem 10)
                        ]
                    ]

        currentInput =
            dropdown.input |> Maybe.map .input |> Maybe.withDefault ""

        viewSelectItems : Int -> OptionGroup msg -> Html msg
        viewSelectItems index orgOptionGroup =
            let
                maybeFilteredOptionGroup : Maybe (OptionGroup msg)
                maybeFilteredOptionGroup =
                    let
                        isOk value =
                            value.label
                                |> String.toLower
                                |> String.contains (String.toLower currentInput)

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
            case maybeFilteredOptionGroup of
                Just filteredOptionGroup ->
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
                        (viewOptionGroup filteredOptionGroup)

                Nothing ->
                    Nordea.Html.nothing

        iconRight =
            case ( dropdown.input, String.isEmpty currentInput ) of
                ( Just inputs, False ) ->
                    Icon.cross
                        [ css
                            [ position absolute
                            , right (rem 0.75)
                            , top (rem 0)
                            , bottom (rem 0)
                            , width (rem 1)
                            , height (rem 1.875)
                            , cursor pointer
                            , marginTop auto
                            , marginBottom auto
                            ]
                        , tabindex 0
                        , Attrs.attribute "role" "button"
                        , onClick (inputs.onInput "")
                        , Attrs.attribute "aria-label" "Clear input"
                        ]

                _ ->
                    Icon.chevronDownFilled
                        [ css
                            [ if Maybe.isJust dropdown.input then
                                position absolute

                              else
                                Css.batch []
                            , right (rem 0.3125)
                            , if dropdown.hasFocus then
                                transforms [ rotate (deg 180) ]

                              else
                                transforms []
                            , pointerEvents none
                            , color Colors.coolGray
                            ]
                        ]

        viewInputOrText =
            dropdown.input |> Maybe.map textInput |> Maybe.withDefault (Html.text dropdown.placeholder)
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
                                dropdown.onFocus dropdown.hasFocus

                            -- Do nothing? need to avoid
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
                    , if Maybe.isJust dropdown.input then
                        Css.batch
                            [ padding4 (rem 0.25) (rem 0.25) (rem 0.25) (rem 0.75)
                            , border3 (rem 0.0625) solid Colors.mediumGray
                            ]

                      else
                        Css.batch []
                    , if dropdown.hasFocus then
                        Css.batch
                            [ borderRadius4 (rem 0.25) (rem 0.25) (rem 0.0) (rem 0.0)
                            , Themes.borderColor Colors.nordeaBlue
                            ]

                      else
                        borderRadius4 (rem 0.25) (rem 0.25) (rem 0.25) (rem 0.25)
                    ]
                ]
                [ viewInputOrText
                , iconRight
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


withInput : String -> (String -> msg) -> MultiSelectDropdown msg -> MultiSelectDropdown msg
withInput input onInput dropdown =
    { dropdown | input = Just { input = input, onInput = onInput } }


withSelected : List String -> MultiSelectDropdown msg -> MultiSelectDropdown msg
withSelected selected dropdown =
    { dropdown | selected = Just selected }
