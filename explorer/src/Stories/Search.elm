module Stories.Search exposing (stories)

import Config exposing (Config, FinancingVariant(..), Msg(..))
import Nordea.Components.Search as Search
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
                    ]
              }
            , { header = "Oor this"
              , items =
                    [ { value = Leasing, text = financingVariantToString Leasing }
                    , { value = Rent, text = financingVariantToString Rent }
                    ]
              }
            ]
    in
    styledStoriesOf
        "Search"
        [ ( "Default"
          , \model ->
                let
                    defaultOptions =
                        Search.init
                            SearchComponentInput
                            SearchComponentSelected
                            searchResult
                            (Maybe.withDefault "" model.customModel.searchComponentInput)
                in
                Search.view
                    defaultOptions
                    []
          , {}
          )
        , ( "with focus"
          , \model ->
                let
                    defaultOptions =
                        Search.init
                            SearchComponentInput
                            SearchComponentSelected
                            searchResult
                            (Maybe.withDefault "" model.customModel.searchComponentInput)
                            |> Search.withFocusHandling "explorer" model.customModel.searchHasFocus SearchComponentFocus
                in
                Search.view
                    defaultOptions
                    []
          , {}
          )
        ]
