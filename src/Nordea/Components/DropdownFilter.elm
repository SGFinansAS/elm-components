module Nordea.Components.DropdownFilter exposing
    ( Item
    , ItemGroup
    , init
    , view
    , withHasFocus
    , withIsLoading
    , withOnFocus
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
        , fontSize
        , fontWeight
        , height
        , hover
        , int
        , justifyContent
        , lineHeight
        , listStyle
        , margin
        , margin2
        , maxHeight
        , none
        , overflowY
        , padding
        , padding3
        , paddingRight
        , pct
        , pointer
        , pointerEvents
        , position
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
import Css.Global exposing (descendants, typeSelector)
import Html.Events.Extra as Events
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attrs exposing (css, tabindex, value)
import Html.Styled.Events as Events
import Json.Decode as Decode
import Maybe.Extra as Maybe
import Nordea.Components.Spinner as Spinner
import Nordea.Components.TextInput as TextInput
import Nordea.Components.Tooltip as Tooltip
import Nordea.Html as Html exposing (styleIf)
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Icons as Icon


type alias Item a =
    { value : a
    , text : String
    }


type alias ItemGroup a =
    { header : String
    , items : List (Item a)
    }


type alias DropdownFilterProperties a msg =
    { searchItems : List (ItemGroup a)
    , onSearchInput : String -> msg
    , onSelectValue : Item a -> msg
    , onClickClearInput : msg
    , rawInputString : String
    , filterValues : String -> String -> Bool
    , onFocus : Maybe (Bool -> msg)
    , hasFocus : Bool
    , hasError : Bool
    , isLoading : Bool -- data might be fetching
    }


type DropdownFilter a msg
    = DropdownFilter (DropdownFilterProperties a msg)


init : (String -> msg) -> (Item a -> msg) -> List (ItemGroup a) -> String -> msg -> DropdownFilter a msg
init onSearchInput onSelectValue searchItems rawInputString onClickClearInput =
    DropdownFilter
        { searchItems = searchItems
        , onSearchInput = onSearchInput
        , onSelectValue = onSelectValue
        , onClickClearInput = onClickClearInput
        , filterValues = \searchString value -> String.contains (String.toLower searchString) (String.toLower value)
        , rawInputString = rawInputString
        , onFocus = Nothing
        , hasFocus = True
        , hasError = False
        , isLoading = False
        }


view : List (Html.Attribute msg) -> DropdownFilter a msg -> Html msg
view attrs (DropdownFilter config) =
    let
        searchMatches =
            config.searchItems
                |> List.concatMap
                    (\group ->
                        let
                            itemMatches =
                                group.items
                                    |> List.filter (.text >> config.filterValues config.rawInputString)
                                    |> List.map (itemView config.onSelectValue)
                        in
                        if not (List.isEmpty itemMatches) && not (String.isEmpty group.header) then
                            headerView group.header :: itemMatches

                        else
                            itemMatches
                    )

        showHasNoMatch =
            config.rawInputString /= "" && List.isEmpty searchMatches

        dropdownStyles =
            Css.batch
                [ backgroundColor Colors.white
                , borderBottom3 (rem 0.0625) solid Colors.grayMedium
                , borderLeft3 (rem 0.0625) solid Colors.grayMedium
                , borderRight3 (rem 0.0625) solid Colors.grayMedium
                , borderBottomLeftRadius (rem 0.25)
                , borderBottomRightRadius (rem 0.25)
                , boxSizing borderBox
                , padding3 (rem 0.1875) (rem 0.0625) (rem 0.75)
                ]
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
                            [ margin (rem 0)
                            , overflowY scroll
                            , maxHeight (rem 16.75)
                            , listStyle none
                            , dropdownStyles
                            ]
                        ]
                        searchMatches
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
                ++ attrs
            )
            [ TextInput.init config.rawInputString
                |> TextInput.withError (config.hasError || showHasNoMatch)
                |> TextInput.withOnInput config.onSearchInput
                |> TextInput.view
                    [ css
                        [ width (pct 100)
                        , borderBottomLeftRadius (pct 0) |> Css.important |> styleIf config.hasFocus
                        , borderBottomRightRadius (pct 0) |> Css.important |> styleIf config.hasFocus
                        , descendants [ typeSelector "input" [ paddingRight (rem 3) ] ]
                        ]
                    ]
            , if String.length config.rawInputString > 0 then
                Icon.cross
                    [ Events.onClick config.onClickClearInput
                    , css
                        [ position absolute
                        , top (pct 50)
                        , right (rem 0.75)
                        , transforms [ translateY (pct -50) ]
                        , width (rem 1.125)
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
                        , color Colors.grayCool
                        ]
                    ]
            ]


headerView : String -> Html msg
headerView text =
    Html.li
        [ css
            [ color Colors.gray
            , margin2 (rem 0) (rem 0.625)
            , fontSize (rem 0.75)
            , fontWeight (int 400)
            , lineHeight (rem 1)
            ]
        ]
        [ Html.text text ]


itemView : (Item a -> msg) -> Item a -> Html msg
itemView onSelectValue item =
    Html.li
        [ Events.onClick (onSelectValue item)
        , Attrs.fromUnstyled (Events.onEnter (onSelectValue item))
        , tabindex 0
        , css
            [ padding (rem 0.75)
            , hover [ backgroundColor Colors.blueCloud ]
            , cursor pointer
            ]
        ]
        [ Html.text item.text ]


withHasFocus : Bool -> DropdownFilter a msg -> DropdownFilter a msg
withHasFocus hasFocus (DropdownFilter config) =
    DropdownFilter { config | hasFocus = hasFocus }


withOnFocus : (Bool -> msg) -> DropdownFilter a msg -> DropdownFilter a msg
withOnFocus onFocus (DropdownFilter config) =
    DropdownFilter { config | onFocus = Just onFocus }


withIsLoading : Bool -> DropdownFilter a msg -> DropdownFilter a msg
withIsLoading isLoading (DropdownFilter config) =
    DropdownFilter { config | isLoading = isLoading }
