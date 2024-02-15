module Nordea.Components.DropdownFilter exposing
    ( Item
    , ItemGroup
    , init
    , view
    , withHasFocus
    , withIsLoading
    , withOnFocus
    , withSearchIcon
    , withSmallSize
    )

import Css
    exposing
        ( absolute
        , alignItems
        , backgroundColor
        , border
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
        , fontSize
        , height
        , hover
        , justifyContent
        , lineHeight
        , listStyle
        , margin2
        , marginTop
        , maxHeight
        , none
        , overflowY
        , padding
        , padding3
        , padding4
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
    , size : Size
    }


type Size
    = StandardSize
    | SmallSize


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
        , size = StandardSize
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

                sizeSpecificStyling =
                    case config.size of
                        StandardSize ->
                            [ height (rem 2.5), fontSize (rem 1), padding4 (rem 0.25) (rem 2.5) (rem 0.25) (rem 0.75), lineHeight (rem 1.4) ]

                        SmallSize ->
                            [ height (rem 1.6), fontSize (rem 0.75), padding4 (rem 0.25) (rem 0.25) (rem 0.25) (rem 0.5), lineHeight (rem 1) ]

                viewItem onSelectValue item =
                    Html.li
                        [ Events.onClick (onSelectValue (Just item))
                        , Attrs.fromUnstyled (Events.onEnter (onSelectValue (Just item)))
                        , tabindex 0
                        , css
                            ([ hover [ backgroundColor Colors.coolGray ]
                             , cursor pointer
                             ]
                                ++ sizeSpecificStyling
                            )
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
                    if hasSelectedValue dropdown then
                        [ Themes.backgroundColor Colors.cloudBlue
                        , border (rem 0)
                        , Css.property "box-shadow" ("0rem 0rem 0rem 0.0625rem " ++ Themes.colorVariable Colors.nordeaBlue) |> Css.important
                        ]

                    else
                        []

                componentBase =
                    TextInput.init config.input
                        |> TextInput.withError (config.hasError || showHasNoMatch)
                        |> TextInput.withOnInput config.onInput
                        |> TextInput.withSearchIcon config.hasSearchIcon

                componentWithSize =
                    if config.size == SmallSize then
                        componentBase |> TextInput.withSmallSize

                    else
                        componentBase
            in
            componentWithSize
                |> TextInput.view
                    [ readonly (hasSelectedValue dropdown)
                    , css
                        [ width (pct 100)
                        , borderBottomLeftRadius (pct 0) |> Css.important |> styleIf (config.hasFocus && not (hasSelectedValue dropdown))
                        , borderBottomRightRadius (pct 0) |> Css.important |> styleIf (config.hasFocus && not (hasSelectedValue dropdown))
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
                (case
                    config.size
                 of
                    StandardSize ->
                        Icon.chevronDownFilled

                    SmallSize ->
                        Icon.chevronDownFilledSmall
                )
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
                if hasSelectedValue dropdown then
                    Html.nothing

                else if config.isLoading then
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
                        |> showIf (not (List.isEmpty searchMatches))
            )
        |> Tooltip.view
            ((config.onFocus
                |> Maybe.map
                    (\onFocus ->
                        [ Events.on "focusout" (Decode.succeed (onFocus False))
                        , Events.on "focusin" (Decode.succeed (onFocus True))
                        ]
                    )
                |> Maybe.withDefault []
             )
                ++ (css [ descendants [ class "tooltip" [ width (pct 100) ] ] ] :: attrs)
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


withSmallSize : DropdownFilter a msg -> DropdownFilter a msg
withSmallSize (DropdownFilter config) =
    DropdownFilter { config | size = SmallSize }


hasSelectedValue : DropdownFilter a msg -> Bool
hasSelectedValue (DropdownFilter config) =
    Maybe.isJust config.selectedValue
