module Stories.Label exposing (stories)

import Config exposing (Msg(..))
import Css exposing (column, displayFlex, flexDirection, marginRight, maxWidth, rem)
import Html.Styled as Html exposing (text)
import Html.Styled.Attributes exposing (css)
import Nordea.Components.Checkbox as Checkbox
import Nordea.Components.Dropdown as Dropdown exposing (optionInit)
import Nordea.Components.Label as Label
import Nordea.Components.RadioButton as RadioButton
import Nordea.Components.TextInput as TextInput
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI a Msg {}
stories =
    styledStoriesOf
        "Label"
        [ ( "With text input"
          , \_ ->
                Html.div [ css [ displayFlex, flexDirection column, maxWidth (rem 20), Css.property "gap" "2rem" ] ]
                    [ Label.init "Customer name" Label.InputLabel
                        |> Label.view []
                            [ TextInput.init "Text"
                                |> TextInput.view []
                            ]
                    , Label.init "Customer name (with error)" Label.InputLabel
                        |> Label.withErrorMessage (Just "The input is invalid")
                        |> Label.view []
                            [ TextInput.init "Text"
                                |> TextInput.withError True
                                |> TextInput.view []
                            ]
                    , Label.init "Customer name (with hint)" Label.InputLabel
                        |> Label.withHintText (Just "This is some extra hint")
                        |> Label.view []
                            [ TextInput.init "Text"
                                |> TextInput.view []
                            ]
                    , Label.init "Customer name (with error and hint)" Label.InputLabel
                        |> Label.withHintText (Just "This is some extra hint")
                        |> Label.withErrorMessage (Just "The input is invalid")
                        |> Label.view []
                            [ TextInput.init "Text"
                                |> TextInput.withError True
                                |> TextInput.view []
                            ]
                    , Label.init "Customer name (with requiredness)" Label.InputLabel
                        |> Label.withRequirednessHint (Just (Label.Mandatory .no))
                        |> Label.view []
                            [ TextInput.init "Text"
                                |> TextInput.view []
                            ]
                    , Label.init "Customer name (with requiredness)" Label.InputLabel
                        |> Label.withRequirednessHint (Just (Label.Optional .no))
                        |> Label.view []
                            [ TextInput.init "Text"
                                |> TextInput.withError True
                                |> TextInput.view []
                            ]
                    , Label.init "Customer name (with max char counter view)" Label.InputLabel
                        |> Label.withCharCounter (Just { current = String.length "Text", max = 100 })
                        |> Label.view []
                            [ TextInput.init "Text"
                                |> TextInput.view []
                            ]
                    ]
          , {}
          )
        , ( "With dropdown"
          , \_ ->
                Html.div [ css [ displayFlex, flexDirection column, maxWidth (rem 20), Css.property "gap" "2rem" ] ]
                    [ Label.init "Choose financingVariant" Label.InputLabel
                        |> Label.view []
                            [ Dropdown.init
                                [ optionInit { value = Leasing, text = financingVariantToString Leasing }
                                , optionInit { value = Rent, text = financingVariantToString Rent }
                                , optionInit { value = Loan, text = financingVariantToString Loan }
                                , optionInit { value = HirePurchase, text = financingVariantToString HirePurchase }
                                ]
                                financingVariantToString
                                (\_ -> NoOp)
                                |> Dropdown.view []
                            ]
                    , Label.init "Choose financingVariant" Label.InputLabel
                        |> Label.withErrorMessage (Just "Financing variant is required")
                        |> Label.view []
                            [ Dropdown.init
                                [ optionInit { value = Leasing, text = financingVariantToString Leasing }
                                , optionInit { value = Rent, text = financingVariantToString Rent }
                                , optionInit { value = Loan, text = financingVariantToString Loan }
                                , optionInit { value = HirePurchase, text = financingVariantToString HirePurchase }
                                ]
                                financingVariantToString
                                (\_ -> NoOp)
                                |> Dropdown.withHasError True
                                |> Dropdown.view []
                            ]
                    ]
          , {}
          )
        , ( "With radio buttons"
          , \_ ->
                Html.div [ css [ displayFlex, flexDirection column, maxWidth (rem 30), Css.property "gap" "2rem" ] ]
                    [ Label.init "State of object" Label.GroupLabel
                        |> Label.view []
                            [ RadioButton.init
                                "simple"
                                (text "New")
                                NoOp
                                |> RadioButton.view [ css [ marginRight (rem 1) ] ]
                            , RadioButton.init
                                "simple"
                                (text "Used")
                                NoOp
                                |> RadioButton.withIsSelected True
                                |> RadioButton.view []
                            ]
                    , Label.init "State of object (with error)" Label.GroupLabel
                        |> Label.withErrorMessage (Just "State of object is required")
                        |> Label.view []
                            [ RadioButton.init
                                "simple"
                                (text "Click me")
                                NoOp
                                |> RadioButton.withHasError True
                                |> RadioButton.view [ css [ marginRight (rem 1) ] ]
                            , RadioButton.init
                                "simple"
                                (text "Click me")
                                NoOp
                                |> RadioButton.withHasError True
                                |> RadioButton.view []
                            ]
                    , Label.init "State of object" Label.GroupLabel
                        |> Label.view []
                            (List.range 0 5
                                |> List.map
                                    (\i ->
                                        RadioButton.init
                                            "simple"
                                            (text ("Click me: " ++ String.fromInt i))
                                            NoOp
                                            |> RadioButton.withAppearance RadioButton.ListStyle
                                            |> RadioButton.withIsSelected (i == 2)
                                            |> RadioButton.view []
                                    )
                            )
                    , Label.init "State of object (with error)" Label.GroupLabel
                        |> Label.withErrorMessage (Just "State of object is required")
                        |> Label.view []
                            (List.range 0 5
                                |> List.map
                                    (\i ->
                                        RadioButton.init
                                            "simple"
                                            (text ("Click me: " ++ String.fromInt i))
                                            NoOp
                                            |> RadioButton.withAppearance RadioButton.ListStyle
                                            |> RadioButton.withHasError True
                                            |> RadioButton.view []
                                    )
                            )
                    ]
          , {}
          )
        , ( "With checkboxes"
          , \_ ->
                Html.div [ css [ displayFlex, flexDirection column, maxWidth (rem 30), Css.property "gap" "2rem" ] ]
                    [ Label.init "State of object" Label.GroupLabel
                        |> Label.view []
                            [ Checkbox.init
                                "simple"
                                (text "New")
                                (\_ -> NoOp)
                                |> Checkbox.view [ css [ marginRight (rem 1) ] ]
                            , Checkbox.init
                                "simple"
                                (text "Used")
                                (\_ -> NoOp)
                                |> Checkbox.withIsChecked True
                                |> Checkbox.view []
                            ]
                    , Label.init "State of object" Label.GroupLabel
                        |> Label.withErrorMessage (Just "State of object is required")
                        |> Label.view []
                            [ Checkbox.init
                                "simple"
                                (text "Click me")
                                (\_ -> NoOp)
                                |> Checkbox.withHasError True
                                |> Checkbox.view [ css [ marginRight (rem 1) ] ]
                            , Checkbox.init
                                "simple"
                                (text "Click me")
                                (\_ -> NoOp)
                                |> Checkbox.withHasError True
                                |> Checkbox.view []
                            ]
                    , Label.init "State of object" Label.GroupLabel
                        |> Label.view []
                            (List.range 0 5
                                |> List.map
                                    (\i ->
                                        Checkbox.init
                                            "simple"
                                            (text ("Click me: " ++ String.fromInt i))
                                            (\_ -> NoOp)
                                            |> Checkbox.withAppearance Checkbox.ListStyle
                                            |> Checkbox.withIsChecked (i == 2)
                                            |> Checkbox.view []
                                    )
                            )
                    , Label.init "State of object (with error)" Label.GroupLabel
                        |> Label.withErrorMessage (Just "State of object is required")
                        |> Label.view []
                            (List.range 0 5
                                |> List.map
                                    (\i ->
                                        Checkbox.init
                                            "simple"
                                            (text ("Click me: " ++ String.fromInt i))
                                            (\_ -> NoOp)
                                            |> Checkbox.withAppearance Checkbox.ListStyle
                                            |> Checkbox.withHasError True
                                            |> Checkbox.view []
                                    )
                            )
                    ]
          , {}
          )
        ]


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
