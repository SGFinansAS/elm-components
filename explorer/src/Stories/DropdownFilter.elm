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
                let
                    defaultOptions =
                        DropdownFilter.init
                            SearchComponentInput
                            SearchComponentSelected
                            searchResult
                            model.customModel.searchComponentInput
                            OnClickClearSearchComponentInput
                in
                Html.div [ css [ displayFlex, flexDirection column ] ]
                    [ DropdownFilter.view [] defaultOptions ]
          , {}
          )
        , ( "focused without group"
          , \model ->
                let
                    removedGroups =
                        List.map (\v -> { v | header = "" }) searchResult

                    defaultOptions =
                        DropdownFilter.init
                            SearchComponentInput
                            SearchComponentSelected
                            removedGroups
                            model.customModel.searchComponentInput
                            OnClickClearSearchComponentInput
                            |> DropdownFilter.withHasFocus True
                in
                Html.div [ css [ displayFlex, flexDirection column ] ]
                    [ DropdownFilter.view [] defaultOptions ]
          , {}
          )
        , ( "interactive with focus"
          , \model ->
                let
                    defaultOptions =
                        DropdownFilter.init
                            SearchComponentInput
                            SearchComponentSelected
                            searchResult
                            model.customModel.searchComponentInput
                            OnClickClearSearchComponentInput
                            |> DropdownFilter.withHasFocus model.customModel.searchHasFocus
                            |> DropdownFilter.withOnFocus SearchComponentFocus
                in
                Html.div [ css [ displayFlex, flexDirection column ] ]
                    [ DropdownFilter.view [] defaultOptions ]
          , {}
          )
        , ( "Loading"
          , \model ->
                let
                    defaultOptions =
                        DropdownFilter.init
                            SearchComponentInput
                            SearchComponentSelected
                            searchResult
                            model.customModel.searchComponentInput
                            OnClickClearSearchComponentInput
                            |> DropdownFilter.withIsLoading True
                            |> DropdownFilter.withHasFocus True
                in
                Html.div [ css [ displayFlex, flexDirection column ] ]
                    [ DropdownFilter.view [] defaultOptions ]
          , {}
          )
        , ( "interactive with async"
          , \_ ->
                Html.text "TODO debouncer and RemoteData"
          , {}
          )
        ]
