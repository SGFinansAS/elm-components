module Stories.DropdownOptions exposing (..)

import Config exposing (Msg(..))
import Nordea.Components.DropdownOptions as DropdownOptions
import Nordea.Components.Util.RequirednessHint as RequirednessHint
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI Config.Config Msg {}
stories =
    styledStoriesOf
        "DropdownOptions"
        [ ( "Standard"
          , \model ->
                DropdownOptions.init { onFocus = FocusDropdownOptions }
                    |> DropdownOptions.withLabel "Label"
                    |> DropdownOptions.withHasFocus model.customModel.hasDropdownOptionsFocus
                    |> DropdownOptions.withRequirednessHint (Just (RequirednessHint.Mandatory .no))
                    |> DropdownOptions.withOptions
                        [ { name = "1", label = "Valg 1", isChecked = model.customModel.isChoice1, onCheck = \_ -> OnCheckChoice1 }
                        , { name = "2", label = "Valg 2", isChecked = model.customModel.isChoice2, onCheck = \_ -> OnCheckChoice2 }
                        , { name = "3", label = "Valg 3", isChecked = model.customModel.isChoice3, onCheck = \_ -> OnCheckChoice3 }
                        ]
                    |> DropdownOptions.view []
          , {}
          )
        ]
