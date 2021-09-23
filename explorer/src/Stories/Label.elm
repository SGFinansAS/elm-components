module Stories.Label exposing (stories)

import Config exposing (Msg(..))
import Nordea.Components.Dropdown as Dropdown
import Nordea.Components.Label as Label
import Nordea.Components.RadioButton as RadioButton
import Nordea.Components.TextInput as TextInput
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI a Msg {}
stories =
    styledStoriesOf
        "Label"
        [ ( "With dropdown"
          , \_ ->
                Label.init "Choose financingVariant" Label.InputLabel
                    |> Label.view []
                        [ Dropdown.init
                            [ { value = "Leasing", text = "Leasing" }
                            , { value = "Rent", text = "Rent" }
                            , { value = "Loan", text = "Loan" }
                            , { value = "HirePurchase", text = "HirePurchase" }
                            ]
                            identity
                            (\_ -> NoOp)
                            |> Dropdown.view []
                        ]
          , {}
          )
        , ( "With dropdown and error"
          , \_ ->
                Label.init "Choose financingVariant" Label.InputLabel
                    |> Label.withErrorMessage (Just "The input is invalid")
                    |> Label.view []
                        [ Dropdown.init
                            [ { value = "Leasing", text = "Leasing" }
                            , { value = "Rent", text = "Rent" }
                            , { value = "Loan", text = "Loan" }
                            , { value = "HirePurchase", text = "HirePurchase" }
                            ]
                            identity
                            (\_ -> NoOp)
                            |> Dropdown.withHasError True
                            |> Dropdown.view []
                        ]
          , {}
          )
        ]
