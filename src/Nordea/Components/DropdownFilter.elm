module Nordea.Components.DropdownFilter exposing
    ( Item
    , ItemGroup
    , init
    , view
    , withChevron
    , withDisabled
    , withHasError
    , withHasFocus
    , withIsLoading
    , withOnFocus
    , withPlaceholder
    , withRightIcon
    , withSearchIcon
    , withSmallSize
    )

import Css
    exposing
        ( absolute
        , alignItems
        , auto
        , backgroundColor
        , border3
        , borderBottom3
        , borderBottomLeftRadius
        , borderBottomRightRadius
        , borderBox
        , borderColor
        , borderTop
        , borderTop3
        , bottom
        , boxSizing
        , center
        , color
        , cursor
        , deg
        , fontSize
        , height
        , hidden
        , hover
        , justifyContent
        , lineHeight
        , listStyle
        , listStyleType
        , margin2
        , marginBottom
        , marginTop
        , maxHeight
        , none
        , outline
        , overflow
        , overflowY
        , padding3
        , padding4
        , paddingRight
        , pct
        , pointer
        , pointerEvents
        , position
        , pseudoClass
        , relative
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
import Css.Global exposing (class, descendants, typeSelector)
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attrs exposing (css, tabindex)
import Html.Styled.Events as Events
import Json.Decode as Decode
import Maybe.Extra as Maybe
import Nordea.Components.Spinner as Spinner
import Nordea.Components.Text as Text
import Nordea.Components.TextInput as TextInput
import Nordea.Components.Tooltip as Tooltip
import Nordea.Html as Html exposing (showIf, styleIf)
import Nordea.Html.Events as Events
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
    , onFocus : Maybe (Bool -> msg)
    , input : String
    , hasFocus : Bool
    , hasError : Bool
    , isLoading : Bool
    , hasSearchIcon : Bool
    , selectedValue : Maybe a
    , size : Size
    , placeholder : Maybe String
    , showChevron : Bool
    , uniqueId : String
    , disabled : Bool
    , hasRightIcon : Bool
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
    , uniqueId : String
    }
    -> DropdownFilter a msg
init { onInput, input, onSelect, items, selectedValue, uniqueId } =
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
        , placeholder = Nothing
        , showChevron = True
        , uniqueId = uniqueId
        , disabled = False
        , hasRightIcon = True
        }


view : List (Html.Attribute msg) -> DropdownFilter a msg -> Html msg
view attrs (DropdownFilter config) =
    let
        ( maybeResetEvents, maybeSelectEventsForItem ) =
            if config.disabled then
                ( [], \_ -> [] )

            else
                ( [ Events.onClick (config.onSelect Nothing), Events.onEnterOrSpacePress (config.onSelect Nothing) ]
                , \item ->
                    [ Events.onClick (config.onSelect (Just item))
                    , Events.onEnterOrSpacePress (config.onSelect (Just item))
                    ]
                )

        textInput =
            let
                conditionallyWithPlaceholder =
                    config.placeholder
                        |> Maybe.map TextInput.withPlaceholder
                        |> Maybe.withDefault identity

                conditionallyWithSmallSize =
                    if config.size == SmallSize then
                        TextInput.withSmallSize

                    else
                        identity
            in
            TextInput.init config.input
                |> TextInput.withError (config.hasError || showHasNoMatch)
                |> TextInput.withOnInput config.onInput
                |> TextInput.withSearchIcon config.hasSearchIcon
                |> conditionallyWithPlaceholder
                |> conditionallyWithSmallSize
                |> TextInput.withInputAttrs
                    [ Attrs.attribute "role" "combobox"
                    , Attrs.attribute "aria-controls" config.uniqueId
                    , Attrs.attribute "aria-expanded"
                        (if config.hasFocus then
                            "true"

                         else
                            "false"
                        )
                    , Attrs.disabled config.disabled
                    ]
                |> TextInput.view
                    [ css
                        [ width (pct 100)
                        , borderBottomLeftRadius (pct 0) |> Css.important |> styleIf dropdownShowing
                        , borderBottomRightRadius (pct 0) |> Css.important |> styleIf dropdownShowing
                        , descendants
                            [ typeSelector "input"
                                [ paddingRight (rem 2.5) |> styleIf config.hasRightIcon ]
                            ]
                        ]
                    ]

        viewHeader text =
            Html.li
                [ css [ color Colors.gray, margin2 (rem 0) (rem 0.625) ] ]
                [ Text.textTinyLight |> Text.view [] [ Html.text text ] ]

        viewItem item =
            let
                sizeStyles =
                    case config.size of
                        StandardSize ->
                            Css.batch
                                [ height (rem 2.5)
                                , fontSize (rem 1)
                                , padding4 (rem 0.25) (rem 2.5) (rem 0.25) (rem 0.75)
                                , lineHeight (rem 1.9)
                                ]

                        SmallSize ->
                            Css.batch
                                [ height (rem 1.6)
                                , fontSize (rem 0.75)
                                , padding4 (rem 0.25) (rem 0.25) (rem 0.25) (rem 0.5)
                                , lineHeight (rem 1)
                                ]

                focusStyles =
                    Css.batch
                        [ pseudoClass "focus-within"
                            [ Themes.backgroundColor Colors.cloudBlue
                            , borderBottom3 (rem 0.1) solid Colors.mediumGray
                            , borderTop3 (rem 0.1) solid Colors.mediumGray
                            , outline none
                            , borderColor Colors.mediumGray
                            , case config.size of
                                StandardSize ->
                                    padding4 (rem 0.25) (rem 2.5) (rem 0.25) (rem 0.75)

                                SmallSize ->
                                    padding4 (rem 0.25) (rem 0.25) (rem 0.25) (rem 0.5)
                            ]
                        ]

                hoverStyles =
                    Css.batch [ hover [ backgroundColor Colors.coolGray ] ]
            in
            Html.li
                ([ css
                    [ overflow hidden
                    , width (pct 100)
                    , listStyleType none
                    , cursor pointer
                    , sizeStyles
                    , focusStyles
                    , hoverStyles
                    ]
                 , tabindex 0
                 , Attrs.attribute "role" "option"
                 , Attrs.attribute "aria-selected"
                    (if Just item.value == config.selectedValue then
                        "true"

                     else
                        "false"
                    )
                 ]
                    ++ maybeSelectEventsForItem item
                )
                [ Html.text item.text ]

        viewItemGroup group =
            if not (List.isEmpty group.items) && not (String.isEmpty group.header) then
                viewHeader group.header :: (group.items |> List.map viewItem)

            else
                group.items |> List.map viewItem

        searchMatches =
            let
                filterValues value =
                    value
                        |> String.toLower
                        |> String.contains (String.toLower config.input)
            in
            config.items
                |> List.map
                    (\group ->
                        { group
                            | items = group.items |> List.filter (.text >> filterValues)
                        }
                    )

        viewSearchMatches =
            searchMatches |> List.concatMap viewItemGroup

        showHasNoMatch =
            config.input /= "" && List.isEmpty searchMatches

        iconRight =
            if String.length config.input > 0 then
                Icon.cross
                    ([ css
                        [ position absolute
                        , right (rem 0.75)
                        , top (rem 0)
                        , bottom (rem 0)
                        , width (rem 1)
                        , height (rem 1)
                        , cursor pointer
                        , marginTop auto
                        , marginBottom auto
                        ]
                     , tabindex 0
                     , Attrs.disabled config.disabled
                     , Attrs.attribute "role" "button"
                     , Attrs.attribute "aria-label"
                        (if config.selectedValue |> Maybe.isJust then
                            "Clear selection"

                         else
                            "Clear input"
                        )
                     ]
                        ++ maybeResetEvents
                    )

            else
                let
                    icon =
                        case
                            config.size
                        of
                            StandardSize ->
                                Icon.chevronDownFilled

                            SmallSize ->
                                Icon.chevronDownFilledSmall
                in
                icon
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
                    |> showIf (config.showChevron && not config.hasSearchIcon)

        dropdownShowing =
            config.hasFocus && viewSearchMatches /= []

        dropdownContent =
            let
                styles =
                    Css.batch
                        [ backgroundColor Colors.white
                        , border3 (rem 0.0625) solid Colors.mediumGray
                        , borderTop (rem 0)
                        , borderBottomLeftRadius (rem 0.25)
                        , borderBottomRightRadius (rem 0.25)
                        , boxSizing borderBox
                        , marginTop (rem 0)
                        , padding3 (rem 0.0) (rem 0) (rem 0.0)
                        , overflowY scroll
                        , maxHeight (rem 16.75)
                        ]
            in
            if config.isLoading then
                Html.row
                    [ css
                        [ height (rem 8)
                        , justifyContent center
                        , alignItems center
                        , styles
                        ]
                    ]
                    [ Spinner.small [] ]

            else
                Html.ul
                    [ Attrs.id config.uniqueId
                    , Attrs.attribute "role" "listbox"
                    , css [ listStyle none, styles ]
                    ]
                    viewSearchMatches
                    |> showIf dropdownShowing

        focusAttrs =
            config.onFocus
                |> Maybe.filter (\_ -> not config.disabled)
                |> Maybe.map
                    (\onFocus ->
                        [ Events.on "focusout" (Decode.succeed (onFocus False))
                        , Events.on "focusin" (Decode.succeed (onFocus True))
                        ]
                    )
                |> Maybe.withDefault []
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
            (\_ -> dropdownContent)
        |> Tooltip.view
            (css
                [ position relative
                , descendants [ class "tooltip" [ width (pct 100) ] ]
                ]
                :: attrs
                ++ focusAttrs
            )
            [ textInput
            , iconRight |> showIf config.hasRightIcon
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


withHasError : Bool -> DropdownFilter a msg -> DropdownFilter a msg
withHasError hasError (DropdownFilter config) =
    DropdownFilter { config | hasError = hasError }


withPlaceholder : Maybe String -> DropdownFilter a msg -> DropdownFilter a msg
withPlaceholder placeholder (DropdownFilter config) =
    DropdownFilter { config | placeholder = placeholder }


withSearchIcon : Bool -> DropdownFilter a msg -> DropdownFilter a msg
withSearchIcon hasSearchIcon (DropdownFilter config) =
    DropdownFilter { config | hasSearchIcon = hasSearchIcon }


withSmallSize : DropdownFilter a msg -> DropdownFilter a msg
withSmallSize (DropdownFilter config) =
    DropdownFilter { config | size = SmallSize }


withChevron : Bool -> DropdownFilter a msg -> DropdownFilter a msg
withChevron bool (DropdownFilter config) =
    DropdownFilter { config | showChevron = bool }


withDisabled : Bool -> DropdownFilter a msg -> DropdownFilter a msg
withDisabled disabled (DropdownFilter config) =
    DropdownFilter { config | disabled = disabled }


withRightIcon : Bool -> DropdownFilter a msg -> DropdownFilter a msg
withRightIcon hasRightIcon (DropdownFilter config) =
    DropdownFilter { config | hasRightIcon = hasRightIcon }
