module Stories.DropdownFilter exposing (stories)

import Config exposing (Config, FinancingVariant(..), Msg(..))
import Css exposing (column, displayFlex, flexDirection)
import Html.Styled as Html
import Html.Styled.Attributes exposing (css)
import Nordea.Components.DropdownFilter as DropdownFilter
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
                        , selectedValue = model.customModel.selectedSearchComponent
                        }
                        |> DropdownFilter.withHasFocus model.customModel.searchHasFocus
                        |> DropdownFilter.withOnFocus SearchComponentFocus
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
                        , selectedValue = model.customModel.selectedSearchComponent
                        }
                        |> DropdownFilter.withHasFocus model.customModel.searchHasFocus
                        |> DropdownFilter.withOnFocus SearchComponentFocus
                        |> DropdownFilter.view []
                    ]
          , {}
          )
        , ( "interactive with focus"
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
        , ( "With search icon"
          , \model ->
                let
                    defaultOptions =
                        DropdownFilter.init
                            { onInput = SearchComponentInput
                            , input = model.customModel.searchComponentInput
                            , onSelect = SearchComponentSelected
                            , items = searchResult
                            , selectedValue = model.customModel.selectedSearchComponent
                            }
                            |> DropdownFilter.withHasFocus model.customModel.searchHasFocus
                            |> DropdownFilter.withOnFocus SearchComponentFocus
                            |> DropdownFilter.withSearchIcon True
                in
                Html.div [ css [ displayFlex, flexDirection column ] ]
                    [ DropdownFilter.view [] defaultOptions ]
          , {}
          )
        ]
