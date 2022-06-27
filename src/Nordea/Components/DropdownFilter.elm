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
        , block
        , border3
        , borderBottom3
        , borderBottomLeftRadius
        , borderBottomRightRadius
        , borderBox
        , borderColor
        , borderLeft3
        , borderRadius4
        , borderRight3
        , boxShadow5
        , boxSizing
        , center
        , color
        , cursor
        , display
        , displayFlex
        , focus
        , fontSize
        , fontWeight
        , height
        , hover
        , inherit
        , inset
        , int
        , justifyContent
        , lineHeight
        , listStyle
        , margin
        , margin2
        , maxHeight
        , none
        , outline
        , overflowY
        , padding
        , padding3
        , padding4
        , paddingRight
        , pct
        , pointer
        , position
        , relative
        , rem
        , right
        , scroll
        , solid
        , top
        , transform
        , translateY
        , width
        )
import Html.Events.Extra as Events
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attrs exposing (css, tabindex, type_, value)
import Html.Styled.Events as Events
import Json.Decode as Decode
import Maybe.Extra as Maybe
import Nordea.Components.Spinner as Spinner
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


{-| Default Options, will give you empty dropdown with no empty item

  - TODO handle isSearching - use with RemoteData to show that new data is loading

-}
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
                            [ displayFlex
                            , justifyContent center
                            , alignItems center
                            , height (rem 8)
                            , backgroundColor Colors.white
                            , borderBottom3 (rem 0.0625) solid Colors.grayMedium
                            , borderLeft3 (rem 0.0625) solid Colors.grayMedium
                            , borderRight3 (rem 0.0625) solid Colors.grayMedium
                            , borderBottomLeftRadius (rem 0.25)
                            , borderBottomRightRadius (rem 0.25)
                            ]
                        ]
                        [ Spinner.small [] ]

                else
                    Html.ul
                        [ css
                            [ display block
                            , margin (rem 0)
                            , overflowY scroll
                            , maxHeight (rem 16.75)
                            , listStyle none
                            , boxSizing borderBox
                            , padding3 (rem 0.1875) (rem 0.0625) (rem 0.75)
                            , backgroundColor Colors.white
                            , borderBottom3 (rem 0.0625) solid Colors.grayMedium
                            , borderLeft3 (rem 0.0625) solid Colors.grayMedium
                            , borderRight3 (rem 0.0625) solid Colors.grayMedium
                            , borderBottomLeftRadius (rem 0.25)
                            , borderBottomRightRadius (rem 0.25)
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
            [ inputSearchView
                (config.hasError || showHasNoMatch)
                config.hasFocus
                config.rawInputString
                config.onSearchInput
                config.onClickClearInput
            ]


inputSearchView : Bool -> Bool -> String -> (String -> msg) -> msg -> Html msg
inputSearchView hasError hasFocus searchString onInput onClickClearInput =
    Html.div
        [ css
            [ displayFlex
            , position relative
            ]
        ]
        [ Html.input
            [ type_ "text"
            , Events.onInput onInput
            , value searchString
            , css
                [ padding4 (rem 0.25) (rem 0.25) (rem 0.25) (rem 1)
                , border3 (rem 0.0625) solid Colors.grayMedium
                , borderColor Colors.redDark |> styleIf hasError
                , width (pct 100)
                , boxSizing borderBox
                , backgroundColor Colors.white
                , focus
                    [ backgroundColor Colors.grayCool
                    , outline none
                    , border3 (rem 0.0625) solid Colors.blueNordea
                    ]
                , if hasFocus then
                    borderRadius4 (rem 0.25) (rem 0.25) (rem 0) (rem 0)

                  else
                    borderRadius4 (rem 0.25) (rem 0.25) (rem 0.25) (rem 0.25)
                , boxShadow5 inset (rem 0) (rem -0.0625) (rem 0) Colors.grayLight
                , height (rem 3)
                , paddingRight (rem 2)
                ]
            ]
            []
        , let
            attributes =
                [ css
                    [ position absolute
                    , top (pct 50)
                    , transform (translateY (pct -50))
                    , right (rem 0.75)
                    , width (rem 1.125) |> Css.important
                    , height (rem 1.125)
                    , cursor pointer
                    , color inherit
                    ]
                ]
          in
          if String.length searchString > 0 then
            Icon.cross (attributes ++ [ Events.onClick onClickClearInput, css [ width (rem 1.385) ] ])

          else if hasFocus then
            Icon.chevronUp attributes

          else
            Icon.chevronDown attributes
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
