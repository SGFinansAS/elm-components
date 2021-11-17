module Nordea.Components.DropdownFilter exposing
    ( Item
    , ItemGroup
    , init
    , view
    , withFocusHandling
    , withFocusState
    , withIsLoading
    )

import Css
import Html.Events.Extra as Events
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attr
import Html.Styled.Events as Events
import Json.Decode as Decode
import Maybe.Extra as Maybe
import Nordea.Components.Spinner as Spinner
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
    , onInput : String -> msg
    , onSelectedValue : Item a -> msg
    , rawInputString : String
    , filterValues : String -> String -> Bool
    , onFocus : Maybe ( String, Bool -> msg )
    , hasFocus : Bool
    , hasError : Bool
    , isLoading : Bool -- data might be fetching
    }


type DropdownFilter a msg
    = DropdownFilter (DropdownFilterProperties a msg)


{-| Default Options, will give you empty dropdown with no empty item

  - TODO handle isSearching - use with RemoteData to show that new data is loading

-}
init : (String -> msg) -> (Item a -> msg) -> List (ItemGroup a) -> String -> DropdownFilter a msg
init onSearchHandler onSelectedValue searchItems rawInputString =
    DropdownFilter
        { searchItems = searchItems
        , onInput = onSearchHandler
        , onSelectedValue = onSelectedValue
        , filterValues = \searchString -> \value -> String.contains (String.toLower searchString) (String.toLower value)
        , rawInputString = rawInputString
        , onFocus = Nothing
        , hasFocus = True
        , hasError = False
        , isLoading = False
        }


view : DropdownFilter a msg -> List (Html.Attribute msg) -> Html msg
view (DropdownFilter options) attributes =
    let
        filteredSearchResult =
            options.searchItems
                |> List.map
                    (\group ->
                        let
                            newItems =
                                List.filter (\item -> options.filterValues options.rawInputString item.text) group.items
                        in
                        { group | items = newItems }
                    )

        searchResultToShow =
            if options.hasFocus || Maybe.isNothing options.onFocus then
                filteredSearchResult

            else
                []

        showHasNoMatch =
            List.all identity
                [ not options.hasFocus || Maybe.isNothing options.onFocus
                , options.rawInputString /= ""
                , not
                    (List.any
                        (\item -> item.text == options.rawInputString)
                        (List.concatMap .items filteredSearchResult)
                    )
                ]
    in
    Html.div
        ([ Attr.css
            [ Css.displayFlex
            , Css.flexDirection Css.column
            , Css.position Css.relative
            , Css.border3 (Css.rem 0.0625) Css.solid Colors.grayMedium
            , Css.borderColor Colors.redDark |> styleIf (options.hasError || showHasNoMatch)
            , Css.borderRadius (Css.rem 0.25)
            , Css.overflow Css.hidden
            ]
         ]
            ++ attributes
        )
        [ inputSearchView options.hasFocus options.rawInputString options.onInput options.onFocus
        , if options.isLoading then
            Spinner.small []

          else if List.isEmpty searchResultToShow then
            Html.nothing

          else
            Html.ul
                [ Attr.css
                    [ Css.listStyle Css.none
                    , Css.padding3 (Css.px 3) (Css.px 1) (Css.px 12)
                    ]
                ]
                (List.concatMap
                    (\header ->
                        let
                            subResultView =
                                List.map (itemView (groupIdAttributeToItemAttrs options.onFocus) options.onSelectedValue)
                                    header.items
                        in
                        -- Do not show header if there are no results to view
                        if List.length subResultView > 0 then
                            -- Do not show header without text
                            if not (String.isEmpty header.header) then
                                headerView header.header :: subResultView

                            else
                                subResultView

                        else
                            []
                    )
                    searchResultToShow
                )
        ]


{-| TODO fix height of input field
-}
inputSearchView : Bool -> String -> (String -> msg) -> Maybe ( String, Bool -> msg ) -> Html msg
inputSearchView hasFocus searchString onInput onFocus =
    Html.div
        [ Attr.css
            [ Css.position Css.relative
            ]
        ]
        [ Html.input
            ([ Attr.type_ "text"
             , Events.onInput onInput
             , Attr.value searchString
             , Attr.css
                [ Css.padding4 (Css.px 4) (Css.px 4) (Css.px 4) (Css.px 16)
                , Css.border3 (Css.px 1) Css.solid Colors.grayMedium
                , Css.width (Css.pct 100)

                -- Style
                , Css.backgroundColor Colors.grayCool
                , Css.focus
                    [ Css.outline Css.none
                    , Css.border3 (Css.px 1) Css.solid Colors.blueNordea
                    ]
                , Css.borderRadius4 (Css.px 4) (Css.px 4) (Css.px 0) (Css.px 0)
                , Css.boxShadow5 Css.inset (Css.px 0) (Css.px -1) (Css.px 0) Colors.grayLight

                --, Css.fontSize (Css.rem 1.0)
                --, Css.lineHeight (Css.rem 1.4)
                ]
             ]
                ++ onFocusAttrs onFocus
            )
            []
        , let
            attributes =
                [ Attr.css
                    [ Css.position Css.absolute
                    , Css.top (Css.pct 50)
                    , Css.transform (Css.translateY (Css.pct -50))
                    , Css.right (Css.rem 0.75)
                    , Css.width (Css.rem 1.125) |> Css.important
                    , Css.height (Css.rem 1.125)
                    , Css.pointerEvents Css.none
                    , Css.color Css.inherit
                    ]
                ]
          in
          if hasFocus then
            Icon.chevronUp attributes

          else
            Icon.chevronDown attributes
        ]


headerView : String -> Html msg
headerView text =
    Html.li
        [ Attr.css
            [ Css.color Colors.gray
            , Css.margin2 (Css.px 0) (Css.px 10)
            , Css.fontSize (Css.px 12)
            , Css.fontWeight (Css.int 900)
            , Css.lineHeight (Css.px 16)
            ]
        ]
        [ Html.text text ]


itemView : List (Html.Attribute msg) -> (Item a -> msg) -> Item a -> Html msg
itemView itemAttributes onSelectedValue item =
    Html.li
        ([ Events.onClick (onSelectedValue item)
         , Attr.fromUnstyled (Events.onEnter (onSelectedValue item))
         , Attr.tabindex 0
         , Attr.style "cursor" "pointer"
         , Attr.css
            [ Css.padding (Css.px 12)
            , Css.hover [ Css.backgroundColor Colors.blueCloud ]
            ]
         ]
            ++ itemAttributes
        )
        [ Html.text item.text ]


withFocusHandling : String -> Bool -> (Bool -> msg) -> DropdownFilter a msg -> DropdownFilter a msg
withFocusHandling uniqueName hasFocus onFocus (DropdownFilter config) =
    DropdownFilter { config | hasFocus = hasFocus, onFocus = Just ( uniqueName, onFocus ) }


withFocusState : Bool -> DropdownFilter a msg -> DropdownFilter a msg
withFocusState hasFocus (DropdownFilter config) =
    DropdownFilter { config | hasFocus = hasFocus }


withIsLoading : Bool -> DropdownFilter a msg -> DropdownFilter a msg
withIsLoading isLoading (DropdownFilter config) =
    DropdownFilter { config | isLoading = isLoading }



--
-- Focus handling
--


onFocusAttrs : Maybe ( String, Bool -> msg ) -> List (Attribute msg)
onFocusAttrs hasFocusAndId =
    let
        hasFocus =
            Maybe.map Tuple.second hasFocusAndId

        groupAttr =
            Maybe.map Tuple.first hasFocusAndId
                |> Maybe.map groupIdAttribute
                |> Maybe.map List.singleton
                |> Maybe.withDefault []

        onFocusAttribute =
            hasFocus
                |> Maybe.map (\f -> f True)
                |> Maybe.map Events.onFocus
                |> Maybe.map List.singleton
                |> Maybe.withDefault []

        onBlurAttribute =
            hasFocus
                |> Maybe.map (\f -> f False)
                |> Maybe.map onGroupBlur
                |> Maybe.map List.singleton
                |> Maybe.withDefault []
    in
    onFocusAttribute ++ onBlurAttribute ++ groupAttr


groupIdAttributeToItemAttrs : Maybe ( String, Bool -> msg ) -> List (Attribute msg)
groupIdAttributeToItemAttrs groupId =
    Maybe.map Tuple.first groupId
        |> Maybe.map groupIdAttribute
        |> Maybe.map List.singleton
        |> Maybe.withDefault []


onGroupBlur : msg -> Attribute msg
onGroupBlur msg =
    Events.on "blur" (decodeGroupIdChanged msg)


groupIdAttribute : String -> Attribute msg
groupIdAttribute groupId =
    Attr.attribute "data-group-id" groupId


{-| Concept taken from:
<https://stackoverflow.com/questions/52375939/in-elm-how-can-i-detect-if-focus-will-be-lost-from-a-group-of-elements>
-}
decodeGroupIdChanged : msg -> Decode.Decoder msg
decodeGroupIdChanged msg =
    Decode.oneOf
        [ Decode.map2
            (\a b ->
                if a /= b then
                    Just a

                else
                    Nothing
            )
            (Decode.at [ "target", "dataset", "groupId" ] Decode.string)
            (Decode.at [ "relatedTarget", "dataset", "groupId" ] Decode.string)
        , Decode.at [ "target", "dataset", "groupId" ] Decode.string
            |> Decode.andThen (\a -> Decode.succeed (Just a))
        ]
        |> Decode.andThen
            (\maybeChanged ->
                case maybeChanged of
                    Just _ ->
                        Decode.succeed msg

                    Nothing ->
                        Decode.fail "no change"
            )
