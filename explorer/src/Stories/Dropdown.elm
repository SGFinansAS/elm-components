module Stories.Dropdown exposing (stories)

import Config exposing (Msg(..))
import Nordea.Components.Dropdown as Dropdown exposing (optionInit)
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
                    [ optionInit { value = Leasing, text = financingVariantToString Leasing }
                    , optionInit { value = Rent, text = financingVariantToString Rent }
                    , optionInit { value = Loan, text = financingVariantToString Loan }
                    , optionInit { value = HirePurchase, text = financingVariantToString HirePurchase }
                    ]
                    financingVariantToString
                    (\_ -> NoOp)
                    |> Dropdown.view []
          , {}
          )
        , ( "Standard with error"
          , \_ ->
                Dropdown.init
                    [ optionInit { value = Leasing, text = financingVariantToString Leasing }
                    , optionInit { value = Rent, text = financingVariantToString Rent }
                    , optionInit { value = Loan, text = financingVariantToString Loan }
                    , optionInit { value = HirePurchase, text = financingVariantToString HirePurchase }
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
        ]
