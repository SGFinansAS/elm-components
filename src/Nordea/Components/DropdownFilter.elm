module Nordea.Components.DropdownFilter exposing
    ( Item
    , ItemGroup
    , init
    , view
    , withChevron
    , withCross
    , withHasError
    , withHasFocus
    , withIsLoading
    , withItemContainerStyles
    , withItemViewMapper
    , withOnFocus
    , withOnPaste
    , withPlaceholder
    , withResultsAlwaysShowing
    , withResultsOverlaying
    , withScroll
    , withSearchIcon
    , withSmallSize
    )

import Css
    exposing
        ( Style
        , absolute
        , alignItems
        , backgroundColor
        , border
        , borderBottom3
        , borderBottomLeftRadius
        , borderBottomRightRadius
        , borderBox
        , borderColor
        , borderLeft3
        , borderRadius
        , borderRight3
        , borderTop3
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
        , margin2
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
import Html.Events.Extra as Events
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attrs exposing (css, tabindex)
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
    , onFocus : Maybe (Bool -> msg)
    , onPaste : Maybe msg
    , input : String
    , hasFocus : Bool
    , hasError : Bool
    , isLoading : Bool
    , hasSearchIcon : Bool
    , selectedValue : Maybe (Item a)
    , size : Size
    , placeholder : Maybe String
    , itemMapper : Maybe (Item a -> Html msg)
    , itemStyles : Maybe (List Style)
    , showResultsAlways : Bool
    , showChevron : Bool
    , showCross : Bool
    , showOverlay : Bool
    , withScroll : Bool
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
        , onPaste = Nothing
        , hasFocus = False
        , hasError = False
        , isLoading = False
        , hasSearchIcon = False
        , selectedValue = selectedValue
        , size = StandardSize
        , placeholder = Nothing
        , itemMapper = Nothing
        , itemStyles = Nothing
        , showChevron = True
        , showCross = True
        , showOverlay = True
        , showResultsAlways = False
        , withScroll = True
        }


view : List (Html.Attribute msg) -> DropdownFilter a msg -> Html msg
view attrs ((DropdownFilter config) as dropdown) =
    let
        defaultMapper =
            \item -> Html.text item.text

        mapper =
            config.itemMapper |> Maybe.withDefault defaultMapper

        defaultStyles =
            let
                sizeStyles =
                    case config.size of
                        StandardSize ->
                            [ height (rem 2.5), fontSize (rem 1), padding4 (rem 0.25) (rem 2.5) (rem 0.25) (rem 0.75), lineHeight (rem 1.9) ]

                        SmallSize ->
                            [ height (rem 1.6), fontSize (rem 0.75), padding4 (rem 0.25) (rem 0.25) (rem 0.25) (rem 0.5), lineHeight (rem 1) ]

                focusPadding =
                    case config.size of
                        StandardSize ->
                            if config.selectedValue |> Maybe.isNothing then
                                padding4 (rem (0.25 - 0.1)) (rem 2.5) (rem (0.25 - 0.1)) (rem 0.75)

                            else
                                padding4 (rem 0.25) (rem 2.5) (rem 0.25) (rem 0.75)

                        SmallSize ->
                            padding4 (rem 0.25) (rem 0.25) (rem 0.25) (rem 0.5)

                focusStyles =
                    [ pseudoClass "focus-within"
                        [ Themes.backgroundColor Colors.cloudBlue
                        , borderBottom3 (rem 0.1) solid Colors.mediumGray
                        , borderTop3 (rem 0.1) solid Colors.mediumGray
                        , focusPadding
                        , outline none
                        , borderColor Colors.mediumGray
                        ]
                    ]

                hoverStyles =
                    [ hover [ backgroundColor Colors.coolGray ] ]

                selectedStyle =
                    if hasSelectedValue dropdown then
                        [ Themes.backgroundColor Colors.cloudBlue |> Css.important
                        , border (rem 0) |> Css.important
                        , Css.property "box-shadow" ("0rem 0rem 0rem 0.0625rem " ++ Themes.colorVariable Colors.nordeaBlue) |> Css.important
                        , borderRadius (rem 0.25)
                        ]

                    else
                        []
            in
            sizeStyles ++ focusStyles ++ hoverStyles ++ selectedStyle

        styles =
            config.itemStyles |> Maybe.withDefault defaultStyles

        textInput =
            let
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
                    ([ Attrs.attribute "role" "combobox"
                     , Attrs.attribute "aria-controls" "searchMatches"
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
                                [ paddingRight (rem 2.5)
                                ]
                            ]
                        ]
                     ]
                        ++ ([ config.onPaste |> Maybe.map (\m -> Events.on "paste" (Decode.succeed m)) ]
                                |> List.filterMap identity
                           )
                    )

        viewHeader text =
            Html.li
                [ css [ color Colors.gray, margin2 (rem 0) (rem 0.625) ] ]
                [ Text.textTinyLight |> Text.view [] [ Html.text text ] ]

        viewItem item isClickable =
            let
                commonStyles =
                    [ overflow hidden, width (pct 100), listStyleType none ]
                        ++ (if isClickable then
                                [ cursor pointer ]

                            else
                                []
                           )

                attrs_ =
                    css (commonStyles ++ styles)
                        :: (if isClickable then
                                [ Events.onClick (config.onSelect (Just item))
                                , Attrs.fromUnstyled (Events.onEnter (config.onSelect (Just item)))
                                ]

                            else
                                []
                           )
                        ++ [ tabindex 0
                           , Attrs.attribute "role" "option"
                           , Attrs.attribute "aria-selected"
                                (if Just item == config.selectedValue then
                                    "true"

                                 else
                                    "false"
                                )
                           ]
            in
            Html.li
                attrs_
                [ mapper item ]

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

        dropdownStyles =
            Css.batch
                ((if config.itemMapper |> Maybe.isJust then
                    []

                  else
                    [ backgroundColor Colors.white
                    , borderBottom3 (rem 0.0625) solid Colors.mediumGray
                    , borderLeft3 (rem 0.0625) solid Colors.mediumGray
                    , borderRight3 (rem 0.0625) solid Colors.mediumGray
                    , borderBottomLeftRadius (rem 0.25)
                    , borderBottomRightRadius (rem 0.25)
                    , boxSizing borderBox
                    , marginTop (rem 0)
                    ]
                 )
                    ++ [ padding3 (rem 0.0) (rem 0) (rem 0.0) ]
                )

        cross =
            Icon.cross
                [ Events.onClick (config.onSelect Nothing)
                , css
                    [ width (rem 1)
                    , height (rem 1)
                    , cursor pointer
                    , position absolute
                    , top (pct 50)
                    , right (rem 0.75)
                    , transforms [ translateY (pct -50) ]
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

        iconRight =
            if String.length config.input > 0 && config.showCross then
                cross

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

        content =
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
                    [ Attrs.id "searchMatches"
                    , Attrs.attribute "role" "listbox"
                    , css
                        ([ listStyle none
                         , dropdownStyles
                         , marginTop (rem 0.25)
                         ]
                            ++ (if config.withScroll then
                                    [ overflowY scroll
                                    , maxHeight (rem 16.75)
                                    ]

                                else
                                    []
                               )
                        )
                    ]
                    viewSearchMatches
                    |> showIf (not (List.isEmpty viewSearchMatches))

        isShown =
            config.showResultsAlways || config.hasFocus
    in
    Html.column []
        [ if config.showOverlay then
            Tooltip.init
                |> Tooltip.withPlacement Tooltip.Bottom
                |> Tooltip.withVisibility
                    (if isShown then
                        Tooltip.Show

                     else
                        Tooltip.Hidden
                    )
                |> Tooltip.withContent
                    (\_ -> content)
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
                |> hideIf (config.selectedValue |> Maybe.isJust)

          else
            -- one can alternatively remove position absolute, left, and transform on the ".tooltip" but it would be dirtier
            Html.column
                ((config.onFocus
                    |> Maybe.map
                        (\onFocus ->
                            [ Events.on "focusout" (Decode.succeed (onFocus False))
                            , Events.on "focusin" (Decode.succeed (onFocus True))
                            ]
                        )
                    |> Maybe.withDefault []
                 )
                    ++ attrs
                )
                [ Html.row
                    [ css [ position relative ] ]
                    [ textInput, iconRight ]
                    |> hideIf (config.selectedValue |> Maybe.isJust)
                , content |> showIf isShown
                ]
        , config.selectedValue
            |> Maybe.map
                (\v ->
                    Html.row [ css [ position relative ] ]
                        [ viewItemNonClickable v
                        , cross |> showIf config.showCross
                        ]
                )
            |> Maybe.withDefault Html.nothing
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



-- by default, dropdown shows Item.text, this lets you use Item.value


withItemViewMapper : Maybe (Item a -> Html msg) -> DropdownFilter a msg -> DropdownFilter a msg
withItemViewMapper f (DropdownFilter config) =
    DropdownFilter { config | itemMapper = f }


withItemContainerStyles : Maybe (List Style) -> DropdownFilter a msg -> DropdownFilter a msg
withItemContainerStyles s (DropdownFilter config) =
    DropdownFilter { config | itemStyles = s }


withChevron : Bool -> DropdownFilter a msg -> DropdownFilter a msg
withChevron bool (DropdownFilter config) =
    DropdownFilter { config | showChevron = bool }


withCross : Bool -> DropdownFilter a msg -> DropdownFilter a msg
withCross bool (DropdownFilter config) =
    DropdownFilter { config | showCross = bool }



--the results will actually occupy space, i.e. they won't "pop-up"


withResultsOverlaying : Bool -> DropdownFilter a msg -> DropdownFilter a msg
withResultsOverlaying bool (DropdownFilter config) =
    DropdownFilter { config | showOverlay = bool }


withScroll : Bool -> DropdownFilter a msg -> DropdownFilter a msg
withScroll bool (DropdownFilter config) =
    DropdownFilter { config | withScroll = bool }


withOnPaste : msg -> DropdownFilter a msg -> DropdownFilter a msg
withOnPaste msg (DropdownFilter config) =
    DropdownFilter { config | onPaste = Just msg }


withResultsAlwaysShowing : Bool -> DropdownFilter a msg -> DropdownFilter a msg
withResultsAlwaysShowing b (DropdownFilter config) =
    DropdownFilter { config | showResultsAlways = b }
