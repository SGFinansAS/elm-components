module Nordea.Components.MultiSelectDropdown exposing
    ( MultiSelectDropdown
    , init
    , view
    , withError
    , withHasFocus
    , withHintText
    , withInput
    , withLabel
    , withNoReservedErrorSpace
    , withOptionGroups
    , withOptions
    , withPlaceholder
    , withRequirednessHint
    , withSelected
    )

import Css exposing (absolute, alignItems, backgroundColor, border3, borderBottomLeftRadius, borderBottomRightRadius, borderBox, borderRadius, borderRadius4, borderStyle, boxShadow, boxSizing, center, color, column, cursor, deg, display, displayFlex, flex, flexBasis, flexDirection, flexGrow, flexWrap, fontSize, height, hover, important, int, justifyContent, left, listStyle, margin, margin4, marginLeft, marginRight, marginTop, maxHeight, minHeight, minWidth, noWrap, none, num, outline, overflowY, padding, padding2, padding4, pct, pointer, pointerEvents, position, relative, rem, right, rotate, scroll, solid, spaceBetween, top, transforms, transparent, whiteSpace, width, wrap, zIndex)
import Html.Styled as Html exposing (Attribute, Html, input, span, text)
import Html.Styled.Attributes as Attrs exposing (attribute, css, id, placeholder, tabindex, type_, value)
import Html.Styled.Events as Events exposing (onClick, onInput)
import Json.Decode as Decode
import List.Extra as List
import Maybe.Extra as Maybe
import Nordea.Components.Checkbox as Checkbox
import Nordea.Components.Label as Label exposing (RequirednessHint)
import Nordea.Components.OutsideEventSupport as OutsideEventSupport
import Nordea.Components.Text as Text
import Nordea.Css exposing (gap)
import Nordea.Html as Html exposing (attrIf)
import Nordea.Html.Events as Events
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Icons as Icons
import Nordea.Themes as Themes
import Nordea.Utils.List as List
import Task


type alias OptionGroup msg =
    { groupLabel : Maybe String, options : List (Option msg) }


type alias InputProperties msg =
    { onInput : String -> Cmd msg -> msg
    , input : String
    }


type alias MultiSelectDropdown msg =
    { label : String
    , uniqueId : String
    , placeholder : String
    , hint : Maybe String
    , optionGroups : List (OptionGroup msg)
    , onFocus : Bool -> msg
    , hasFocus : Bool
    , requirednessHint : Maybe RequirednessHint
    , inputProperties : Maybe (InputProperties msg)
    , errorMessage : Maybe String
    , showSelected : Bool
    , reserveSpaceForError : Bool
    }


type alias Option msg =
    { name : String
    , label : String
    , isChecked : Bool
    , onCheck : Bool -> msg
    }


init : { onFocus : Bool -> msg, uniqueId : String } -> MultiSelectDropdown msg
init { onFocus, uniqueId } =
    { label = ""
    , uniqueId = uniqueId
    , placeholder = ""
    , hint = Nothing
    , optionGroups = []
    , onFocus = onFocus
    , hasFocus = True
    , requirednessHint = Nothing
    , inputProperties = Nothing
    , errorMessage = Nothing
    , showSelected = False
    , reserveSpaceForError = True
    }


view : List (Attribute msg) -> MultiSelectDropdown msg -> Html msg
view attrs dropdown =
    let
        currentInput =
            dropdown.inputProperties |> Maybe.map .input |> Maybe.withDefault ""

        hasTextInput =
            dropdown.inputProperties |> Maybe.isJust

        toggleButtonAttrs =
            [ Attrs.attribute "aria-controls" dropdown.uniqueId
            , Attrs.attribute "aria-haspopup" "true"
            , Attrs.attribute "aria-expanded"
                (if dropdown.hasFocus then
                    "true"

                 else
                    "false"
                )
            ]

        viewInput inputProps =
            input
                [ id ("multiselectinput-" ++ dropdown.uniqueId)
                , css
                    [ outline none
                    , important (boxShadow none)
                    , borderStyle none
                    , fontSize (rem 1)
                    , width (pct 100)
                    , height (pct 100)
                    , fontSize (rem 1)
                    , flexGrow (num 1)
                    , flexBasis (rem 10)
                    ]
                , placeholder dropdown.placeholder
                , value currentInput
                , onInput (\str -> inputProps.onInput str (Task.succeed (dropdown.onFocus True) |> Task.perform identity))
                , Attrs.attribute "aria-controls" dropdown.uniqueId
                ]
                []

        viewInputBar inputProperties =
            Html.row [ css [ flex (int 1), height (rem 1.875), alignItems center, minWidth (rem 15) ] ]
                [ Icons.search
                    [ css
                        [ pointerEvents none
                        , color Colors.gray
                        , width (rem 1)
                        , height (rem 1)
                        , margin4 (rem 0) (rem 0.4) (rem 0) (rem 0)
                        ]
                    , attribute "aria-hidden" "true"
                    ]
                , viewInput inputProperties
                , if inputProperties.input /= "" then
                    Html.button
                        (Events.onClick (inputProperties.onInput "" (Task.attempt (\_ -> dropdown.onFocus False) (Task.succeed ())))
                            :: css
                                [ displayFlex
                                , borderStyle none
                                , backgroundColor transparent
                                , marginRight (rem 0.25)
                                , cursor pointer
                                ]
                            :: type_ "button"
                            :: toggleButtonAttrs
                        )
                        [ Icons.roundedCross
                            [ attribute "aria-hidden" "true"
                            , css [ width (rem 1.3), color Colors.mediumGray ]
                            ]
                        ]

                  else
                    Html.button
                        (Events.onClick (dropdown.onFocus (not dropdown.hasFocus))
                            :: css
                                [ displayFlex
                                , borderStyle none
                                , backgroundColor transparent
                                , cursor pointer
                                ]
                            :: attribute "aria-label" dropdown.placeholder
                            :: type_ "button"
                            :: toggleButtonAttrs
                        )
                        [ Icons.chevronDownFilled
                            [ attribute "aria-hidden" "true"
                            , css
                                [ cursor pointer
                                , color Colors.coolGray
                                , if dropdown.hasFocus then
                                    transforms [ rotate (deg 180) ]

                                  else
                                    Css.batch []
                                ]
                            ]
                        ]
                ]

        controlElementStyle =
            css
                [ width (pct 100)
                , displayFlex
                , alignItems center
                , backgroundColor Colors.white
                , borderStyle none
                , padding4 (rem 0.25) (rem 0.25) (rem 0.25) (rem 0.5)
                , border3 (rem 0.0625) solid Colors.mediumGray
                , boxSizing borderBox
                , minHeight (rem 2.5)
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

        selectItems =
            viewSelectItems dropdown

        dropdownListView =
            Html.ul
                [ Attrs.id dropdown.uniqueId
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

        selectedBubbles =
            if dropdown.showSelected then
                dropdown.optionGroups
                    |> List.concatMap .options
                    |> List.filter .isChecked
                    |> List.map
                        (\option ->
                            Html.div
                                [ attribute "aria-hidden" "true"
                                , tabindex -1
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
                                , Icons.cross [ onClick (option.onCheck False), css [ width (rem 1), height (rem 1), cursor pointer ] ]
                                ]
                        )

            else
                []
    in
    Label.init
        dropdown.label
        Label.GroupLabel
        |> Label.withRequirednessHint dropdown.requirednessHint
        |> Label.withHintText dropdown.hint
        |> Label.withErrorMessage dropdown.errorMessage
        |> (if dropdown.reserveSpaceForError then
                identity

            else
                Label.withNoReservedErrorSpace
           )
        |> Label.view
            ((Events.on "focusin" (Decode.succeed (dropdown.onFocus True)) |> attrIf hasTextInput)
                :: Events.onKeyDownMaybe
                    (\key ->
                        case key of
                            Events.Enter ->
                                -- already handled
                                Nothing

                            Events.Space ->
                                -- already handled
                                Nothing

                            Events.Esc ->
                                dropdown.onFocus False |> Just
                    )
                :: attrs
            )
            [ OutsideEventSupport.view
                { msg = dropdown.onFocus False
                , isActive = dropdown.hasFocus
                , eventTypes = [ OutsideEventSupport.OutsideClick, OutsideEventSupport.OutsideFocus ]
                }
            , Html.div [ controlElementStyle, css [ position relative, width (pct 100), gap (rem 0.5), flexWrap wrap ] ]
                (selectedBubbles
                    ++ [ case dropdown.inputProperties of
                            Just inputProperties ->
                                viewInputBar inputProperties

                            Nothing ->
                                Html.button
                                    (css [ backgroundColor Colors.white, borderStyle none, justifyContent spaceBetween, alignItems center, cursor pointer, displayFlex, flex (int 1), minWidth (rem 15), padding4 (rem 0.25) (rem 0.25) (rem 0.25) (rem 0.5), margin4 (rem -0.25) (rem -0.25) (rem -0.25) (rem -0.5) ]
                                        :: Events.onClick (dropdown.onFocus (not dropdown.hasFocus))
                                        :: type_ "button"
                                        :: toggleButtonAttrs
                                    )
                                    [ Text.bodyTextSmall |> Text.view [] [ Html.text dropdown.placeholder ]
                                    , Icons.chevronDownFilled [ attribute "aria-hidden" "true" ]
                                    ]
                       , dropdownListView
                       ]
                )
            ]


viewSelectItems : MultiSelectDropdown msg -> List (Html msg)
viewSelectItems dropdown =
    let
        maybeFilteredOptionGroup group =
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
                    group.options |> List.filter isOk
            in
            if List.isEmpty matchingItems then
                Nothing

            else
                Just { group | options = matchingItems }

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

        groups =
            dropdown.optionGroups
                |> List.groupWhile (\g1 g2 -> g1.groupLabel == g2.groupLabel)
                |> List.map
                    (\( first, rest ) ->
                        { groupLabel = first.groupLabel
                        , options = first.options ++ (rest |> List.concatMap .options)
                        }
                    )
    in
    case groups of
        [] ->
            []

        [ one ] ->
            one
                |> maybeFilteredOptionGroup
                |> Maybe.map (.options >> List.map viewOption)
                |> Maybe.withDefault []

        multiple ->
            multiple
                |> List.filterMap maybeFilteredOptionGroup
                |> List.map
                    (\group ->
                        Html.li
                            []
                            [ Text.textTinyLight
                                |> Text.withHtmlTag Html.h3
                                |> Text.view
                                    [ css
                                        [ marginTop (rem 0.75)
                                        , marginLeft (rem 0.75)
                                        , color Colors.darkGray
                                        , Css.property "text-align" "initial"
                                        ]
                                    ]
                                    [ group.groupLabel |> Maybe.withDefault "-" |> Html.text ]
                            , Html.ul
                                [ css
                                    [ margin (rem 0)
                                    , padding (rem 0)
                                    , listStyle none
                                    , flexDirection column
                                    ]
                                ]
                                (group.options |> List.map viewOption)
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


withInput : String -> (String -> Cmd msg -> msg) -> MultiSelectDropdown msg -> MultiSelectDropdown msg
withInput input onInput dropdown =
    { dropdown | inputProperties = Just { input = input, onInput = onInput } }


withError : Maybe String -> MultiSelectDropdown msg -> MultiSelectDropdown msg
withError error dropdown =
    { dropdown | errorMessage = error }


withSelected : MultiSelectDropdown msg -> MultiSelectDropdown msg
withSelected dropdown =
    { dropdown | showSelected = True }


withNoReservedErrorSpace : MultiSelectDropdown msg -> MultiSelectDropdown msg
withNoReservedErrorSpace config =
    { config | reserveSpaceForError = False }
