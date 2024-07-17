module Nordea.Components.DropdownFilter exposing
    ( Item
    , ItemGroup
    , SearchResultAppearance(..)
    , init
    , view
    , withHasError
    , withHasFocus
    , withIsLoading
    , withOnFocus
    , withPlaceholder
    , withSearchIcon
    , withSearchResultAppearance
    , withSearchResultRowMapper
    , withSmallSize
    , withoutChevron
    )

import Css
    exposing
        ( absolute
        , alignItems
        , auto
        , backgroundColor
        , border
        , border3
        , borderBottom3
        , borderBottomLeftRadius
        , borderBottomRightRadius
        , borderBox
        , borderLeft3
        , borderRadius
        , borderRight3
        , borderWidth
        , bottom
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
        , hidden
        , hover
        , justifyContent
        , lineHeight
        , listStyle
        , listStyleType
        , margin
        , margin2
        , marginRight
        , marginTop
        , maxHeight
        , minHeight
        , none
        , outline
        , overflow
        , overflowY
        , padding2
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
import Css.Global exposing (children, class, descendants, everything, typeSelector, withAttribute)
import Html.Events.Extra as Events
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attrs exposing (css, readonly, tabindex)
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
    , selectedValue : Maybe (Item a)
    , size : Size
    , placeholder : Maybe String
    , searchResultAppearance : SearchResultAppearance
    , itemMapper : Item a -> Html msg
    , showChevron : Bool
    }


type Size
    = StandardSize
    | SmallSize


type SearchResultAppearance
    = Default
    | Card


type DropdownFilter a msg
    = DropdownFilter (DropdownFilterProperties a msg)


init :
    { onInput : String -> msg
    , input : String
    , onSelect : Maybe (Item a) -> msg
    , selectedValue : Maybe (Item a)
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
        , placeholder = Nothing
        , searchResultAppearance = Default
        , itemMapper = \item -> Html.text item.text
        , showChevron = True
        }


view : List (Html.Attribute msg) -> DropdownFilter a msg -> Html msg
view attrs ((DropdownFilter config) as dropdown) =
    let
        clickableStyling isClickable =
            if isClickable then
                [ cursor pointer ]

            else
                []

        commonStyling =
            [ overflow hidden, width (pct 100), listStyleType none ]

        sizeSpecificStyling =
            case config.size of
                StandardSize ->
                    [ minHeight (rem 2.5), fontSize (rem 1), padding4 (rem 0.25) (rem 2.5) (rem 0.25) (rem 0.75), lineHeight (rem 1.4) ]

                SmallSize ->
                    [ height (rem 1.6), fontSize (rem 0.75), padding4 (rem 0.25) (rem 0.25) (rem 0.25) (rem 0.5), lineHeight (rem 1) ]

        variationSpecificStyling =
            case config.searchResultAppearance of
                Card ->
                    [ padding2 (rem (0.25 - 0.0625)) (rem (0.25 - 0.0625))

                    --, justifyContent spaceBetween
                    , pseudoClass "focus-within"
                        [ -- we must adjust the padding after increasing the border to avoid movement
                          padding2 (rem 0) (rem 0)
                        , Themes.backgroundColor Colors.cloudBlue
                        , borderWidth (rem 0.25)
                        , outline none
                        ]
                    , border3 (rem 0.0625) solid Colors.mediumGray
                    , borderRadius (rem 0.25)
                    , hover [ Themes.backgroundColor Colors.cloudBlue ]
                    , Themes.backgroundColor Colors.cloudBlue
                        |> styleIf (config.selectedValue |> Maybe.isJust)
                    , Themes.color Colors.nordeaBlue |> styleIf (config.selectedValue |> Maybe.isJust)
                    , Themes.borderColor Colors.nordeaBlue |> styleIf (config.selectedValue |> Maybe.isJust)
                    ]

                Default ->
                    [ hover [ backgroundColor Colors.coolGray ] ]

        viewHeader text =
            Html.li
                [ css [ color Colors.gray, margin2 (rem 0) (rem 0.625) ] ]
                [ Text.textTinyLight |> Text.view [] [ Html.text text ] ]

        clickableAttrs item =
            [ Events.onClick (config.onSelect (Just item))
            , Attrs.fromUnstyled (Events.onEnter (config.onSelect (Just item)))
            ]

        commonAttrs =
            [ tabindex 0 ]

        viewItem item isClickable =
            Html.li
                (commonAttrs
                    ++ [ css (commonStyling ++ clickableStyling isClickable ++ sizeSpecificStyling ++ variationSpecificStyling) ]
                    ++ (if isClickable then
                            clickableAttrs item

                        else
                            [ css [ cursor auto ] ]
                       )
                )
                [ config.itemMapper item ]

        viewItemClickable item =
            viewItem item True

        viewItemNonClickable item =
            viewItem item False

        viewItemGroup group =
            if not (List.isEmpty group.items) && not (String.isEmpty group.header) then
                viewHeader group.header :: (group.items |> List.map viewItemClickable)

            else
                group.items |> List.map viewItemClickable

        searchMatches =
            let
                filterValues value =
                    value
                        |> String.toLower
                        |> String.contains (String.toLower config.input)
            in
            config.items
                |> List.concatMap
                    (\group ->
                        viewItemGroup
                            { group
                                | items = group.items |> List.filter (.text >> filterValues)
                            }
                    )

        showHasNoMatch =
            config.input /= "" && List.isEmpty searchMatches

        dropdownStyles =
            Css.batch
                (case config.searchResultAppearance of
                    Card ->
                        [ padding3 (rem 0.5) (rem 0) (rem 0.0)
                        , children [ everything [ pseudoClass "not(:first-child)" [ marginTop (rem 0.5) ] ] ]
                        ]

                    Default ->
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
                )

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

                addPlaceholder =
                    config.placeholder
                        |> Maybe.map TextInput.withPlaceholder
                        |> Maybe.withDefault identity

                componentBase =
                    TextInput.init config.input
                        |> TextInput.withError (config.hasError || showHasNoMatch)
                        |> TextInput.withOnInput config.onInput
                        |> TextInput.withSearchIcon config.hasSearchIcon
                        |> addPlaceholder

                componentWithSize =
                    if config.size == SmallSize then
                        componentBase |> TextInput.withSmallSize

                    else
                        componentBase
            in
            componentWithSize
                |> TextInput.view
                    [ readonly (hasSelectedValue dropdown)
                    , Attrs.attribute "role" "combobox"
                    , Attrs.attribute "aria-expanded"
                        (if not config.hasFocus then
                            "false"

                         else
                            "true"
                        )
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

        cardCross attrs_ =
            Icon.cross
                ([ Events.onClick (config.onSelect Nothing)
                 , css
                    [ width (rem 1)
                    , height (rem 1)
                    , cursor pointer
                    ]
                 , tabindex 0
                 , Attrs.fromUnstyled (Events.onEnter (config.onSelect Nothing))
                 , Attrs.attribute "role" "button"
                 , Attrs.attribute "aria-label"
                    (if config.selectedValue |> Maybe.isJust then
                        "Clear selection"

                     else
                        "Clear input"
                    )
                 ]
                    ++ attrs_
                )

        iconRight =
            if String.length config.input > 0 then
                cardCross
                    [ Events.onClick (config.onSelect Nothing)
                    , css
                        [ position absolute
                        , top (pct 50)
                        , right (rem 0.75)
                        , transforms [ translateY (pct -50) ]
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
                    |> hideIf (config.hasSearchIcon || not config.showChevron)
    in
    Html.column []
        [ Tooltip.init
            |> Tooltip.withPlacement Tooltip.Bottom
            |> Tooltip.withVisibility
                ({- if config.hasFocus then -}
                 Tooltip.Show
                 {-
                    else
                       Tooltip.Hidden
                 -}
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
            |> hideIf (config.searchResultAppearance == Card && (config.selectedValue |> Maybe.isJust))
        , if config.searchResultAppearance == Card then
            config.selectedValue
                |> Maybe.map
                    (\v ->
                        Html.row [ css [ position relative ] ]
                            [ viewItemNonClickable v
                            , cardCross
                                [ css
                                    [ margin auto
                                    , top (rem 0)
                                    , bottom (rem 0)
                                    , position absolute
                                    , right (rem 0)
                                    , marginRight (rem 2)
                                    ]
                                ]
                            ]
                    )
                |> Maybe.withDefault Html.nothing

          else
            Html.nothing
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


hasSelectedValue : DropdownFilter a msg -> Bool
hasSelectedValue (DropdownFilter config) =
    Maybe.isJust config.selectedValue


withSearchResultAppearance : SearchResultAppearance -> DropdownFilter a msg -> DropdownFilter a msg
withSearchResultAppearance searchResultAppearance (DropdownFilter config) =
    DropdownFilter { config | searchResultAppearance = searchResultAppearance }


withSearchResultRowMapper : (Item a -> Html msg) -> DropdownFilter a msg -> DropdownFilter a msg
withSearchResultRowMapper f (DropdownFilter config) =
    DropdownFilter { config | itemMapper = f }


withoutChevron : DropdownFilter a msg -> DropdownFilter a msg
withoutChevron (DropdownFilter config) =
    DropdownFilter { config | showChevron = False }
