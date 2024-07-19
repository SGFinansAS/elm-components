module Stories.DropdownFilter exposing (stories)

import Config exposing (Config, FinancingVariant(..), Msg(..), OrganizationInfo)
import Css exposing (border3, borderRadius, column, displayFlex, flexDirection, hover, marginTop, none, outline, padding2, pseudoClass, rem, solid)
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes exposing (css, tabindex)
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


exampleOrgInfo =
    { name = "Murat", organizationNumber = "12345", enterpriseTypeId = Nothing, postalCode = Just "0556", postalPlace = Just "OSLO" }


maybeToHtml : (a -> Html msg) -> Maybe a -> Html msg
maybeToHtml element maybeVariable =
    maybeVariable |> Maybe.map element |> Maybe.withDefault (Html.text "")


viewOrganizationInfo : Bool -> Item OrganizationInfo -> Html msg
viewOrganizationInfo hasSelected organization =
    let
        textPostalCodeAndPlace =
            Maybe.map2 (\code place -> code ++ ", " ++ place)
                organization.value.postalCode
                organization.value.postalPlace
    in
    Html.column
        [ tabindex 0
        , css
            [ --padding2 (rem 1) (rem 2)
              border3 (rem 0.0625) solid Colors.mediumGray
            , padding2 (rem (0.25 + 1)) (rem (2 + 0.25))
            , borderRadius (rem 0.25)
            , hover [ Themes.backgroundColor Colors.coolGray ]
            , outline none
            , marginTop (rem 0.5)
            , pseudoClass "focus-within"
                [ -- we must adjust the padding after increasing the border to avoid movement
                  --  padding2 (rem (1 - 0.25 - 0.0625)) (rem (2 - 0.25 - 0.0625))
                  Themes.backgroundColor Colors.cloudBlue
                , border3 (rem 0.25) solid Colors.mediumGray

                --, padding2 (rem (1 - 0.25 + 0.0625)) (rem (2 - 0.25 + 0.0625))
                , outline none
                , padding2 (rem (0.0625 + 1)) (rem (2 + 0.0625))

                -- , borderColor Colors.mediumGray
                ]
            , Themes.backgroundColor Colors.cloudBlue |> styleIf hasSelected |> Css.important
            , Themes.color Colors.nordeaBlue |> styleIf hasSelected

            --  , Themes.borderColor Colors.nordeaBlue |> styleIf (config.selectedValue |> Maybe.isJust)
            , border3 (rem 0.0625) solid Colors.nordeaBlue |> styleIf hasSelected
            ]
        ]
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
                        |> DropdownFilter.withoutScroll
                        |> DropdownFilter.view []
                    ]
          , {}
          )
        , ( "With style specified for result"
          , \model ->
                Card.init
                    |> Card.withTitle "Card title"
                    |> Card.withShadow
                    |> Card.view []
                        [ Html.div [ css [ displayFlex, flexDirection column ] ]
                            [ DropdownFilter.init
                                { onInput = SearchComponentInput
                                , input = model.customModel.searchComponentInput
                                , onSelect = SearchComponentSelectedOrgInfo
                                , items = organizationInfoSearchResult
                                , selectedValue = model.customModel.selectedSearchComponentOrgInfo
                                }
                                |> DropdownFilter.withHasFocus model.customModel.searchHasFocus
                                |> DropdownFilter.withOnFocus SearchComponentFocus
                                |> DropdownFilter.withSearchResultRowMapper (Just (viewOrganizationInfo (model.customModel.selectedSearchComponentOrgInfo |> Maybe.isJust)))
                                |> DropdownFilter.withoutOverlay
                                |> DropdownFilter.withoutChevron
                                |> DropdownFilter.withoutScroll
                                --|> DropdownFilter.withSmallSize
                                |> DropdownFilter.view []
                            ]
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
