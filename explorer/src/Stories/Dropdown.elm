module Stories.Dropdown exposing (stories)

import Config exposing (Msg(..))
import Html.Styled.Attributes exposing (disabled)
import Nordea.Components.Dropdown as Dropdown
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


type FinancingVariant
    = Leasing
    | Rent
    | Loan
    | HirePurchase


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


stories : UI a Msg {}
stories =
    styledStoriesOf
        "Dropdown"
        [ ( "Standard"
          , \_ ->
                Dropdown.init
                    [ { value = Leasing, text = financingVariantToString Leasing, group = Nothing, isDisabled = False }
                    , { value = Rent, text = financingVariantToString Rent, group = Nothing, isDisabled = False }
                    , { value = Loan, text = financingVariantToString Loan, group = Nothing, isDisabled = False }
                    , { value = HirePurchase, text = financingVariantToString HirePurchase, group = Nothing, isDisabled = False }
                    ]
                    financingVariantToString
                    (\_ -> NoOp)
                    |> Dropdown.withPlaceholder "Choose financing variant"
                    |> Dropdown.view []
          , {}
          )
        , ( "Standard Small"
          , \_ ->
                Dropdown.init
                    [ { value = Leasing, text = financingVariantToString Leasing, group = Nothing, isDisabled = False }
                    , { value = Rent, text = financingVariantToString Rent, group = Nothing, isDisabled = False }
                    , { value = Loan, text = financingVariantToString Loan, group = Nothing, isDisabled = False }
                    , { value = HirePurchase, text = financingVariantToString HirePurchase, group = Nothing, isDisabled = False }
                    ]
                    financingVariantToString
                    (\_ -> NoOp)
                    |> Dropdown.withPlaceholder "Choose financing variant"
                    |> Dropdown.withSmallSize
                    |> Dropdown.view []
          , {}
          )
        , ( "Standard with error"
          , \_ ->
                Dropdown.init
                    [ { value = Leasing, text = financingVariantToString Leasing, group = Nothing, isDisabled = False }
                    , { value = Rent, text = financingVariantToString Rent, group = Nothing, isDisabled = False }
                    , { value = Loan, text = financingVariantToString Loan, group = Nothing, isDisabled = False }
                    , { value = HirePurchase, text = financingVariantToString HirePurchase, group = Nothing, isDisabled = False }
                    ]
                    financingVariantToString
                    (\_ -> NoOp)
                    |> Dropdown.withHasError True
                    |> Dropdown.view []
          , {}
          )
        , ( "Simple"
          , \_ ->
                Dropdown.simple
                    [ { value = Leasing, text = financingVariantToString Leasing }
                    , { value = Rent, text = financingVariantToString Rent }
                    , { value = Loan, text = financingVariantToString Loan }
                    , { value = HirePurchase, text = financingVariantToString HirePurchase }
                    ]
                    financingVariantToString
                    (\_ -> NoOp)
                    |> Dropdown.view []
          , {}
          )
        , ( "Simple Small"
          , \_ ->
                Dropdown.simple
                    [ { value = Leasing, text = financingVariantToString Leasing }
                    , { value = Rent, text = financingVariantToString Rent }
                    , { value = Loan, text = financingVariantToString Loan }
                    , { value = HirePurchase, text = financingVariantToString HirePurchase }
                    ]
                    financingVariantToString
                    (\_ -> NoOp)
                    |> Dropdown.withSmallSize
                    |> Dropdown.view []
          , {}
          )
        , ( "Simple with error"
          , \_ ->
                Dropdown.simple
                    [ { value = Leasing, text = financingVariantToString Leasing }
                    , { value = Rent, text = financingVariantToString Rent }
                    , { value = Loan, text = financingVariantToString Loan }
                    , { value = HirePurchase, text = financingVariantToString HirePurchase }
                    ]
                    financingVariantToString
                    (\_ -> NoOp)
                    |> Dropdown.withHasError True
                    |> Dropdown.view []
          , {}
          )
        , ( "Disabled"
          , \_ ->
                Dropdown.init
                    [ { value = Leasing, text = financingVariantToString Leasing, group = Nothing, isDisabled = False }
                    , { value = Rent, text = financingVariantToString Rent, group = Nothing, isDisabled = False }
                    , { value = Loan, text = financingVariantToString Loan, group = Nothing, isDisabled = False }
                    , { value = HirePurchase, text = financingVariantToString HirePurchase, group = Nothing, isDisabled = False }
                    ]
                    financingVariantToString
                    (\_ -> NoOp)
                    |> Dropdown.view [ disabled True ]
          , {}
          )
        , ( "With disabled options"
          , \_ ->
                Dropdown.init
                    [ { value = Leasing, text = financingVariantToString Leasing, group = Nothing, isDisabled = False }
                    , { value = Rent, text = financingVariantToString Rent, group = Nothing, isDisabled = True }
                    , { value = Loan, text = financingVariantToString Loan, group = Nothing, isDisabled = False }
                    , { value = HirePurchase, text = financingVariantToString HirePurchase, group = Nothing, isDisabled = True }
                    ]
                    financingVariantToString
                    (\_ -> NoOp)
                    |> Dropdown.withPlaceholder "Choose financing variant"
                    |> Dropdown.view []
          , {}
          )
        , ( "With grouped options"
          , \_ ->
                Dropdown.init
                    [ { value = Leasing, text = financingVariantToString Leasing, group = Just "Group 1", isDisabled = False }
                    , { value = Rent, text = financingVariantToString Rent, group = Just "Group 2", isDisabled = False }
                    , { value = Loan, text = financingVariantToString Loan, group = Just "Group 1", isDisabled = False }
                    , { value = HirePurchase, text = financingVariantToString HirePurchase, group = Just "Group 2", isDisabled = False }
                    ]
                    financingVariantToString
                    (\_ -> NoOp)
                    |> Dropdown.withPlaceholder "Choose financing variant"
                    |> Dropdown.view []
          , {}
          )
        ]
