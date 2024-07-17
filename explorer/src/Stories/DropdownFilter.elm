module Stories.DropdownFilter exposing (stories)

import Config exposing (Config, FinancingVariant(..), Msg(..), OrganizationInfo)
import Css
    exposing
        ( column
        , displayFlex
        , flexDirection
        , padding2
        , rem
        )
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes exposing (css)
import Nordea.Components.DropdownFilter as DropdownFilter exposing (Item, ItemGroup, SearchResultAppearance(..))
import Nordea.Components.Text as Text
import Nordea.Css exposing (gap)
import Nordea.Html as Html
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


exampleOrgInfo =
    { name = "Murat", organizationNumber = "12345", enterpriseTypeId = Nothing, postalCode = Just "0556", postalPlace = Just "OSLO" }


maybeToHtml : (a -> Html msg) -> Maybe a -> Html msg
maybeToHtml element maybeVariable =
    maybeVariable |> Maybe.map element |> Maybe.withDefault (Html.text "")


viewOrganizationInfo : Item OrganizationInfo -> Html msg
viewOrganizationInfo organization =
    let
        textPostalCodeAndPlace =
            Maybe.map2 (\code place -> code ++ ", " ++ place)
                organization.value.postalCode
                organization.value.postalPlace
    in
    Html.column
        [ css [ padding2 (rem 1) (rem 2) ] ]
        [ Html.row [ css [ gap (rem 0.25) ] ]
            [ Text.textHeavy |> Text.view [] [ Html.text organization.value.name ]
            , Text.textLight |> Text.view [] [ Html.text organization.value.organizationNumber ]
            ]
        , textPostalCodeAndPlace
            |> maybeToHtml
                (\textPostalCodeAndPlace_ ->
                    Text.textLight |> Text.view [] [ Html.text textPostalCodeAndPlace_ ]
                )
        ]


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

        organizationInfoSearchResult : List (ItemGroup OrganizationInfo)
        organizationInfoSearchResult =
            [ { header = ""
              , items =
                    [ { value = exampleOrgInfo, text = exampleOrgInfo.name }
                    , { value = exampleOrgInfo, text = exampleOrgInfo.name }
                    , { value = exampleOrgInfo, text = exampleOrgInfo.name }
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
        , ( "With style specified for result"
          , \model ->
                Html.div [ css [ displayFlex, flexDirection column ] ]
                    [ DropdownFilter.init
                        { onInput = SearchComponentInput
                        , input = model.customModel.searchComponentInput
                        , onSelect = SearchComponentSelectedOrgInfo
                        , items = organizationInfoSearchResult
                        , selectedValue = model.customModel.selectedSearchComponentOrgInfo
                        }
                        |> DropdownFilter.withHasFocus model.customModel.searchHasFocus
                        |> DropdownFilter.withOnFocus SearchComponentFocus
                        |> DropdownFilter.withSearchResultAppearance Card
                        |> DropdownFilter.withSearchResultRowMapper viewOrganizationInfo
                        |> DropdownFilter.withoutChevron
                        --|> DropdownFilter.withSmallSize
                        |> DropdownFilter.view []
                    ]
          , {}
          )
        , ( "With placeholder"
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
                        |> DropdownFilter.withPlaceholder (Just "Placeholder")
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
                        , selectedValue = model.customModel.selectedSearchComponent
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
        , ( "Small"
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
                        , selectedValue = model.customModel.selectedSearchComponent
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
                        , selectedValue = model.customModel.selectedSearchComponent
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
