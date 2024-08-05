module Stories.DropdownFilter exposing (stories)

import Config exposing (Config, FinancingVariant(..), Msg(..), OrganizationInfo)
import Css exposing (border3, borderRadius, column, displayFlex, flexDirection, hover, marginTop, none, outline, padding2, pseudoClass, rem, solid)
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes exposing (css)
import Maybe.Extra as Maybe
import Nordea.Components.Card as Card
import Nordea.Components.DropdownFilter as DropdownFilter exposing (Item, ItemGroup)
import Nordea.Components.Text as Text
import Nordea.Css exposing (gap)
import Nordea.Html as Html exposing (styleIf)
import Nordea.Resources.Colors as Colors
import Nordea.Themes as Themes
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


financingVariantToString : FinancingVariant -> String
financingVariantToString financingVariant =
    case financingVariant of
        Leasing ->
            "Leasing"

        Rent ->
            "Rent"

        Loan ->
            "Leie"

        HirePurchase ->
            "HirePurchase"


stories : UI Config Msg {}
stories =
    let
        searchResult =
            [ { header = "Try this"
              , items =
                    [ { value = Loan, text = financingVariantToString Loan }
                    , { value = HirePurchase, text = financingVariantToString HirePurchase }
                    , { value = HirePurchase, text = financingVariantToString HirePurchase }
                    , { value = HirePurchase, text = financingVariantToString HirePurchase }
                    ]
              }
            , { header = "Or this"
              , items =
                    [ { value = Leasing, text = financingVariantToString Leasing }
                    , { value = Rent, text = financingVariantToString Rent }
                    , { value = Rent, text = financingVariantToString Rent }
                    , { value = Rent, text = financingVariantToString Rent }
                    ]
              }
            ]
    in
    styledStoriesOf
        "DropdownFilter"
        [ ( "Default"
          , \model ->
                Html.div [ css [ displayFlex, flexDirection column ] ]
                    [ DropdownFilter.init
                        { onInput = SearchComponentInput
                        , input = model.customModel.searchComponentInput
                        , onSelect = SearchComponentSelected
                        , items = searchResult
                        , selectedValue = model.customModel.selectedSearchComponent |> Maybe.map .value
                        }
                        |> DropdownFilter.withHasFocus model.customModel.searchHasFocus
                        |> DropdownFilter.withOnFocus SearchComponentFocus
                        |> DropdownFilter.withScroll True
                        |> DropdownFilter.view []
                    ]
          , {}
          )
        , ( "focused without group"
          , \model ->
                let
                    removedGroups =
                        List.map (\v -> { v | header = "" }) searchResult
                in
                Html.div [ css [ displayFlex, flexDirection column ] ]
                    [ DropdownFilter.init
                        { onInput = SearchComponentInput
                        , input = model.customModel.searchComponentInput
                        , onSelect = SearchComponentSelected
                        , items = removedGroups
                        , selectedValue = model.customModel.selectedSearchComponent |> Maybe.map .value
                        }
                        |> DropdownFilter.withHasFocus model.customModel.searchHasFocus
                        |> DropdownFilter.withOnFocus SearchComponentFocus
                        |> DropdownFilter.view []
                    ]
          , {}
          )
        , ( "Loading"
          , \model ->
                Html.div [ css [ displayFlex, flexDirection column ] ]
                    [ DropdownFilter.init
                        { onInput = SearchComponentInput
                        , input = model.customModel.searchComponentInput
                        , onSelect = SearchComponentSelected
                        , items = searchResult
                        , selectedValue = Nothing
                        }
                        |> DropdownFilter.withHasFocus model.customModel.searchHasFocus
                        |> DropdownFilter.withOnFocus SearchComponentFocus
                        |> DropdownFilter.withIsLoading True
                        |> DropdownFilter.view []
                    ]
          , {}
          )
        , ( "With hasError"
          , \model ->
                Html.div [ css [ displayFlex, flexDirection column ] ]
                    [ DropdownFilter.init
                        { onInput = SearchComponentInput
                        , input = model.customModel.searchComponentInput
                        , onSelect = SearchComponentSelected
                        , items = searchResult
                        , selectedValue = Nothing
                        }
                        |> DropdownFilter.withHasFocus model.customModel.searchHasFocus
                        |> DropdownFilter.withOnFocus SearchComponentFocus
                        |> DropdownFilter.withIsLoading True
                        |> DropdownFilter.withHasError True
                        |> DropdownFilter.view []
                    ]
          , {}
          )
        , ( "With search icon"
          , \model ->
                let
                    defaultOptions =
                        DropdownFilter.init
                            { onInput = SearchComponentInput
                            , input = model.customModel.searchComponentInput
                            , onSelect = SearchComponentSelected
                            , items = searchResult
                            , selectedValue = model.customModel.selectedSearchComponent |> Maybe.map .value
                            }
                            |> DropdownFilter.withHasFocus model.customModel.searchHasFocus
                            |> DropdownFilter.withOnFocus SearchComponentFocus
                            |> DropdownFilter.withSearchIcon True
                in
                Html.div [ css [ displayFlex, flexDirection column ] ]
                    [ DropdownFilter.view [] defaultOptions ]
          , {}
          )
        , ( "Small"
          , \model ->
                Html.div [ css [ displayFlex, flexDirection column ] ]
                    [ DropdownFilter.init
                        { onInput = SearchComponentInput
                        , input = model.customModel.searchComponentInput
                        , onSelect = SearchComponentSelected
                        , items = searchResult
                        , selectedValue = model.customModel.selectedSearchComponent |> Maybe.map .value
                        }
                        |> DropdownFilter.withHasFocus model.customModel.searchHasFocus
                        |> DropdownFilter.withOnFocus SearchComponentFocus
                        |> DropdownFilter.withSmallSize
                        |> DropdownFilter.view []
                    ]
          , {}
          )
        , ( "Small with search icon"
          , \model ->
                Html.div [ css [ displayFlex, flexDirection column ] ]
                    [ DropdownFilter.init
                        { onInput = SearchComponentInput
                        , input = model.customModel.searchComponentInput
                        , onSelect = SearchComponentSelected
                        , items = searchResult
                        , selectedValue = model.customModel.selectedSearchComponent |> Maybe.map .value
                        }
                        |> DropdownFilter.withHasFocus model.customModel.searchHasFocus
                        |> DropdownFilter.withOnFocus SearchComponentFocus
                        |> DropdownFilter.withSmallSize
                        |> DropdownFilter.withSearchIcon True
                        |> DropdownFilter.view []
                    ]
          , {}
          )
        , ( "Small with loading"
          , \model ->
                Html.div [ css [ displayFlex, flexDirection column ] ]
                    [ DropdownFilter.init
                        { onInput = SearchComponentInput
                        , input = model.customModel.searchComponentInput
                        , onSelect = SearchComponentSelected
                        , items = searchResult
                        , selectedValue = model.customModel.selectedSearchComponent |> Maybe.map .value
                        }
                        |> DropdownFilter.withHasFocus model.customModel.searchHasFocus
                        |> DropdownFilter.withOnFocus SearchComponentFocus
                        |> DropdownFilter.withSmallSize
                        |> DropdownFilter.withIsLoading True
                        |> DropdownFilter.view []
                    ]
          , {}
          )
        ]
