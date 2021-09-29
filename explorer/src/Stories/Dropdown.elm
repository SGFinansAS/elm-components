module Stories.Dropdown exposing (stories)

import Config exposing (Msg(..))
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
        [ ( "Default"
          , \_ ->
                Dropdown.init
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
        , ( "With error"
          , \_ ->
                Dropdown.init
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
