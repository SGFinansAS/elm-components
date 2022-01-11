module Stories.DropdownFilter exposing (stories)

import Config exposing (Config, FinancingVariant(..), Msg(..))
import Css
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
            , { header = "Oor this"
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
                            (Maybe.withDefault "" model.customModel.searchComponentInput)
                            OnClickClearSearchComponentInput
                in
                DropdownFilter.view
                    defaultOptions
                    []
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
                            (Maybe.withDefault "" model.customModel.searchComponentInput)
                            OnClickClearSearchComponentInput
                            |> DropdownFilter.withFocusState True
                in
                DropdownFilter.view
                    defaultOptions
                    []
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
                            (Maybe.withDefault "" model.customModel.searchComponentInput)
                            OnClickClearSearchComponentInput
                            |> DropdownFilter.withFocusHandling "explorer" model.customModel.searchHasFocus SearchComponentFocus
                in
                Html.div [] [
                  (DropdownFilter.view defaultOptions [])
                  , Html.text "Some text"
                ]
          , {}
          )
        , ( "interactive with async"
          , \model ->
                Html.text "TODO debouncer and RemoteData"
          , {}
          )
        ]
