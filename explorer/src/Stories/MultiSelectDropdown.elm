module Stories.MultiSelectDropdown exposing (..)

import Config exposing (Msg(..))
import Nordea.Components.MultiSelectDropdown as MultiSelectDropdown
import Nordea.Components.Label as Label
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI Config.Config Msg {}
stories =
    styledStoriesOf
        "MultiSelectDropdown"
        [ ( "Standard"
          , \model ->
                MultiSelectDropdown.init { onFocus = FocusMultiSelectDropdown }
                    |> MultiSelectDropdown.withLabel "Label"
                    |> MultiSelectDropdown.withPlaceholder "Choose an option"
                    |> MultiSelectDropdown.withHasFocus model.customModel.hasMultiSelectDropdownFocus
                    |> MultiSelectDropdown.withRequirednessHint (Just (Label.Mandatory .no))
                    |> MultiSelectDropdown.withHintText (Just "Hint")
                    |> MultiSelectDropdown.withOptions
                        [ { name = "1", label = "Valg 1", isChecked = model.customModel.isChoice1, onCheck = \_ -> OnCheckChoice1 }
                        , { name = "2", label = "Valg 2", isChecked = model.customModel.isChoice2, onCheck = \_ -> OnCheckChoice2 }
                        , { name = "3", label = "Valg 3", isChecked = model.customModel.isChoice3, onCheck = \_ -> OnCheckChoice3 }
                        ]
                    |> MultiSelectDropdown.view []
          , {}
          )
        ]
