module Nordea.Components.MultiSelectDropdown exposing
    ( MultiSelectDropdown
    , init
    , view
    , withError
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

import Browser.Dom as Browser
import Css exposing (absolute, alignItems, backgroundColor, border3, borderBottomLeftRadius, borderBottomRightRadius, borderBox, borderRadius, borderRadius4, borderStyle, boxShadow, boxSizing, center, color, column, cursor, display, displayFlex, flexBasis, flexDirection, flexGrow, flexWrap, fontSize, height, hover, important, int, justifyContent, left, listStyle, margin, margin4, marginLeft, marginTop, maxHeight, minWidth, noWrap, none, num, outline, overflowY, padding, padding2, padding4, pct, pointer, pointerEvents, position, relative, rem, right, scroll, solid, spaceBetween, start, top, whiteSpace, width, wrap, zIndex)
import Html.Styled as Html exposing (Attribute, Html, div, input, span, text)
import Html.Styled.Attributes as Attrs exposing (css, id, placeholder, tabindex, value)
import Html.Styled.Events as Events exposing (onClick, onInput)
import Json.Decode as Decode
import Maybe.Extra as Maybe
import Nordea.Components.Checkbox as Checkbox
import Nordea.Components.Label as Label exposing (RequirednessHint)
import Nordea.Components.OutsideEventSupport as OutsideEventSupport
import Nordea.Components.Text as Text
import Nordea.Css exposing (gap)
import Nordea.Html as Html exposing (attrEmpty, attrIf, styleIf)
import Nordea.Html.Events as Events
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Icons as Icon
import Nordea.Themes as Themes
import Nordea.Utils.List as List
import Task


type alias OptionGroup msg =
    { groupLabel : Maybe String, options : List (Option msg) }


type alias InputProperties msg =
    { onInput : String -> Cmd msg -> msg
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
    , inputProperties : Maybe (InputProperties msg)
    , errorMessage : Maybe String
    , showSelected : Bool
    }


type alias Option msg =
    { name : String
    , label : String
    , isChecked : Bool
    , onCheck : Bool -> msg
    }


init : { onFocus : Bool -> msg } -> MultiSelectDropdown msg
init { onFocus } =
    { label = ""
    , placeholder = ""
    , hint = Nothing
    , optionGroups = []
    , onFocus = onFocus
    , hasFocus = True
    , requirednessHint = Nothing
    , inputProperties = Nothing
    , errorMessage = Nothing
    , showSelected = False
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
                [ id (makeId inputProps)
                , css
                    [ outline none
                    , important (boxShadow none)
                    , borderStyle none
                    , fontSize (rem 1)
                    , height (rem 1.75)
                    , width (pct 100)
                    , minWidth (pct 97)
                    , flexGrow (num 1)
                    , flexBasis (rem 10)
                    ]
                , placeholder dropdown.placeholder
                , value currentInput
                , onInput (\str -> inputProps.onInput str Cmd.none)
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

        viewSelectedAndInput : InputProperties msg -> Html msg
        viewSelectedAndInput inputProperties =
            div
                [ css
                    [ displayFlex
                    , flexWrap wrap
                    , alignItems center
                    , gap (rem 0.5)
                    , width (pct 100)
                    ]
                , onClick (inputProperties.onInput inputProperties.input (focusInput inputProperties))
                ]
                (List.concat
                    [ dropdown.optionGroups
                        |> List.concatMap .options
                        |> List.filter .isChecked
                        |> List.map
                            (\option ->
                                div
                                    [ tabindex 0
                                    , Events.onKeyDownMaybe
                                        (\key ->
                                            case key of
                                                Events.Space ->
                                                    Just (option.onCheck False)

                                                _ ->
                                                    Nothing
                                        )
                                    , css
                                        [ color Colors.nordeaBlue
                                        , displayFlex
                                        , alignItems center
                                        , gap (rem 0.5)
                                        , backgroundColor Colors.lightBlue
                                        , borderRadius (rem 2)
                                        , padding2 (rem 0.25) (rem 0.75)
                                        ]
                                    ]
                                    [ span [ css [ whiteSpace noWrap ] ] [ Text.textLight |> Text.view [] [ text option.label ] ]
                                    , Icon.cross [ onClick (option.onCheck False), css [ width (rem 1), height (rem 1), cursor pointer ] ]
                                    ]
                            )
                    , [ Html.row [ css [ width (pct 100) ] ]
                            [ searchIcon
                            , viewInput inputProperties
                            ]
                      ]
                    ]
                )

        searchIcon =
            Icon.search
                [ css
                    [ pointerEvents none
                    , color Colors.gray
                    , width (rem 1)
                    , height (rem 1)
                    , margin4 (rem 0.4) (rem 0.4) (rem 0.4) (rem 0)
                    ]
                ]

        selectItems =
            dropdown.optionGroups |> List.indexedMap (viewSelectItems dropdown) |> List.filterMap identity
    in
    Label.init
        dropdown.label
        Label.GroupLabel
        |> Label.withRequirednessHint dropdown.requirednessHint
        |> Label.withHintText dropdown.hint
        |> Label.withErrorMessage dropdown.errorMessage
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
                    , styleIf (not hasTextInput) (cursor pointer)
                    , alignItems center
                    , justifyContent spaceBetween
                    , backgroundColor Colors.white
                    , padding4 (rem 0.25) (rem 0.25) (rem 0.25) (rem 0.5)
                    , border3 (rem 0.0625) solid Colors.mediumGray
                    , if dropdown.hasFocus then
                        Css.batch
                            [ borderRadius4 (rem 0.25) (rem 0.25) (rem 0.0) (rem 0.0)
                            , if Maybe.isJust dropdown.errorMessage then
                                Themes.borderColor Colors.darkRed

                              else
                                Themes.borderColor Colors.nordeaBlue
                            ]

                      else
                        borderRadius4 (rem 0.25) (rem 0.25) (rem 0.25) (rem 0.25)
                    ]
                ]
                (case dropdown.inputProperties of
                    Just inputProperties ->
                        [ viewSelectedAndInput inputProperties ]

                    Nothing ->
                        [ Html.text dropdown.placeholder
                        , Icon.chevronDownFilled []
                        ]
                )
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


focusInput : InputProperties msg -> Cmd msg
focusInput inputProperties =
    Task.attempt (\_ -> inputProperties.onInput inputProperties.input Cmd.none) (Browser.focus (makeId inputProperties))


makeId : InputProperties msg -> String
makeId inputProperties =
    "multiselectinput" ++ inputProperties.uniqueId


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


withInput : String -> (String -> Cmd msg -> msg) -> String -> MultiSelectDropdown msg -> MultiSelectDropdown msg
withInput input onInput uniqueId dropdown =
    { dropdown | inputProperties = Just { input = input, onInput = onInput, uniqueId = uniqueId } }


withError : Maybe String -> MultiSelectDropdown msg -> MultiSelectDropdown msg
withError error dropdown =
    { dropdown | errorMessage = error }


withSelected : MultiSelectDropdown msg -> MultiSelectDropdown msg
withSelected dropdown =
    { dropdown | showSelected = True }
