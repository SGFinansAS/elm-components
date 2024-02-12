module Nordea.Components.DropdownFilter exposing
    ( Item
    , ItemGroup
    , init
    , view
    , withHasFocus
    , withIsLoading
    , withOnFocus
    , withSearchIcon
    )

import Css
    exposing
        ( absolute
        , alignItems
        , backgroundColor
        , borderBottom3
        , borderBottomLeftRadius
        , borderBottomRightRadius
        , borderBox
        , borderLeft3
        , borderRight3
        , boxSizing
        , center
        , color
        , column
        , cursor
        , deg
        , displayFlex
        , flexDirection
        , height
        , hover
        , justifyContent
        , listStyle
        , margin2
        , marginTop
        , maxHeight
        , none
        , outline
        , overflowY
        , padding
        , padding3
        , paddingRight
        , pct
        , pointer
        , pointerEvents
        , position
        , rem
        , right
        , rotate
        , scroll
        , solid
        , top
        , transforms
        , translateY
        , width
        )
import Css.Global exposing (class, descendants, typeSelector, withAttribute)
import Html.Events.Extra as Events
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attrs exposing (css, readonly, tabindex, value)
import Html.Styled.Events as Events
import Json.Decode as Decode
import Maybe.Extra as Maybe
import Nordea.Components.Spinner as Spinner
import Nordea.Components.Text as Text
import Nordea.Components.TextInput as TextInput
import Nordea.Components.Tooltip as Tooltip
import Nordea.Html as Html exposing (hideIf, showIf, styleIf)
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Icons as Icon
import Nordea.Themes as Themes


type alias Item a =
    { value : a
    , text : String
    }


type alias ItemGroup a =
    { header : String
    , items : List (Item a)
    }


type alias DropdownFilterProperties a msg =
    { items : List (ItemGroup a)
    , onInput : String -> msg
    , onSelect : Maybe (Item a) -> msg
    , input : String
    , onFocus : Maybe (Bool -> msg)
    , hasFocus : Bool
    , hasError : Bool
    , isLoading : Bool
    , hasSearchIcon : Bool
    , selectedValue : Maybe a
    }


type DropdownFilter a msg
    = DropdownFilter (DropdownFilterProperties a msg)


init :
    { onInput : String -> msg
    , input : String
    , onSelect : Maybe (Item a) -> msg
    , selectedValue : Maybe a
    , items : List (ItemGroup a)
    }
    -> DropdownFilter a msg
init { onInput, input, onSelect, items, selectedValue } =
    DropdownFilter
        { items = items
        , onInput = onInput
        , onSelect = onSelect
        , input = input
        , onFocus = Nothing
        , hasFocus = False
        , hasError = False
        , isLoading = False
        , hasSearchIcon = False
        , selectedValue = selectedValue
        }


view : List (Html.Attribute msg) -> DropdownFilter a msg -> Html msg
view attrs ((DropdownFilter config) as dropdown) =
    let
        filterValues value =
            value
                |> String.toLower
                |> String.contains (String.toLower config.input)

        searchMatches =
            let
                viewHeader text =
                    Html.li
                        [ css [ color Colors.gray, margin2 (rem 0) (rem 0.625) ] ]
                        [ Text.textTinyLight |> Text.view [] [ Html.text text ] ]

                viewItem onSelectValue item =
                    Html.li
                        [ Events.onClick (onSelectValue (Just item))
                        , Attrs.fromUnstyled (Events.onEnter (onSelectValue (Just item)))
                        , tabindex 0
                        , css
                            [ padding (rem 0.75)
                            , hover [ backgroundColor Colors.coolGray ]
                            , cursor pointer
                            ]
                        ]
                        [ Html.text item.text ]
            in
            config.items
                |> List.concatMap
                    (\group ->
                        let
                            itemMatches =
                                group.items
                                    |> List.filter (.text >> filterValues)
                                    |> List.map (viewItem config.onSelect)
                        in
                        if not (List.isEmpty itemMatches) && not (String.isEmpty group.header) then
                            viewHeader group.header :: itemMatches

                        else
                            itemMatches
                    )

        showHasNoMatch =
            config.input /= "" && List.isEmpty searchMatches

        dropdownStyles =
            Css.batch
                [ backgroundColor Colors.white
                , borderBottom3 (rem 0.0625) solid Colors.mediumGray
                , borderLeft3 (rem 0.0625) solid Colors.mediumGray
                , borderRight3 (rem 0.0625) solid Colors.mediumGray
                , borderBottomLeftRadius (rem 0.25)
                , borderBottomRightRadius (rem 0.25)
                , boxSizing borderBox
                , padding3 (rem 0.5) (rem 0) (rem 0.0)
                , marginTop (rem 0)
                ]

        textInput =
            let
                selectedStyle =
                    if isSelected dropdown then
                        [ Themes.backgroundColor Colors.cloudBlue
                        , outline none
                        , Themes.borderColor Colors.nordeaBlue
                        ]

                    else
                        []
            in
            TextInput.init config.input
                |> TextInput.withError (config.hasError || showHasNoMatch)
                |> TextInput.withOnInput config.onInput
                |> TextInput.withSearchIcon config.hasSearchIcon
                |> TextInput.view
                    [ readonly (isSelected dropdown)
                    , css
                        [ width (pct 100)
                        , borderBottomLeftRadius (pct 0) |> Css.important |> styleIf (config.hasFocus && not (isSelected dropdown))
                        , borderBottomRightRadius (pct 0) |> Css.important |> styleIf (config.hasFocus && not (isSelected dropdown))
                        , descendants
                            [ typeSelector "input"
                                [ withAttribute "readonly"
                                    selectedStyle
                                , paddingRight (rem 2.5)
                                ]
                            ]
                        ]
                    ]

        iconRight =
            if String.length config.input > 0 then
                Icon.cross
                    [ Events.onClick (config.onSelect Nothing)
                    , css
                        [ position absolute
                        , top (pct 50)
                        , right (rem 0.75)
                        , transforms [ translateY (pct -50) ]
                        , width (rem 1)
                        , cursor pointer
                        ]
                    ]

            else
                Icon.chevronDownFilled
                    [ css
                        [ position absolute
                        , top (pct 50)
                        , right (rem 0.3125)
                        , if config.hasFocus then
                            transforms [ translateY (pct -50), rotate (deg 180) ]

                          else
                            transforms [ translateY (pct -50) ]
                        , pointerEvents none
                        , color Colors.coolGray
                        ]
                    ]
                    |> hideIf config.hasSearchIcon
    in
    Tooltip.init
        |> Tooltip.withPlacement Tooltip.Bottom
        |> Tooltip.withVisibility
            (if config.hasFocus then
                Tooltip.Show

             else
                Tooltip.Hidden
            )
        |> Tooltip.withContent
            (\_ ->
                if config.isLoading then
                    Html.div
                        [ css
                            [ height (rem 8)
                            , displayFlex
                            , flexDirection column
                            , justifyContent center
                            , dropdownStyles
                            , alignItems center
                            ]
                        ]
                        [ Spinner.small [] ]

                else
                    Html.ul
                        [ css
                            [ overflowY scroll
                            , maxHeight (rem 16.75)
                            , listStyle none
                            , dropdownStyles
                            ]
                        ]
                        searchMatches
                        |> showIf (not (List.isEmpty searchMatches) && not (isSelected dropdown))
            )
        |> Tooltip.view
            ((config.onFocus
                |> Maybe.map
                    (\onFocus ->
                        [ Events.on "focusout" (Decode.succeed (onFocus False))
                        , Events.on "focusin" (Decode.succeed (onFocus True))
                        , css [ descendants [ class "tooltip" [ width (pct 100) ] ] ]
                        ]
                    )
                |> Maybe.withDefault []
             )
                ++ attrs
            )
            [ textInput
            , iconRight
            ]


withHasFocus : Bool -> DropdownFilter a msg -> DropdownFilter a msg
withHasFocus hasFocus (DropdownFilter config) =
    DropdownFilter { config | hasFocus = hasFocus }


withOnFocus : (Bool -> msg) -> DropdownFilter a msg -> DropdownFilter a msg
withOnFocus onFocus (DropdownFilter config) =
    DropdownFilter { config | onFocus = Just onFocus }


withIsLoading : Bool -> DropdownFilter a msg -> DropdownFilter a msg
withIsLoading isLoading (DropdownFilter config) =
    DropdownFilter { config | isLoading = isLoading }


withSearchIcon : Bool -> DropdownFilter a msg -> DropdownFilter a msg
withSearchIcon hasSearchIcon (DropdownFilter config) =
    DropdownFilter { config | hasSearchIcon = hasSearchIcon }


isSelected : DropdownFilter a msg -> Bool
isSelected (DropdownFilter config) =
    Maybe.isJust config.selectedValue
