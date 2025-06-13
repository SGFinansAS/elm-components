module Stories.MultiSelectDropdown exposing (stories)

import Config exposing (Msg(..))
import Css exposing (rem, width)
import Html.Styled.Attributes exposing (css)
import Maybe.Extra as Maybe
import Nordea.Components.Label as Label
import Nordea.Components.MultiSelectDropdown as MultiSelectDropdown
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI Config.Config Msg {}
stories =
    styledStoriesOf
        "MultiSelectDropdown"
        [ ( "Standard"
          , \model ->
                MultiSelectDropdown.init { onFocus = FocusMultiSelectDropdown, uniqueId = "MultiSelectDropdown1" }
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
        , ( "With groups"
          , \model ->
                MultiSelectDropdown.init { onFocus = FocusMultiSelectDropdown, uniqueId = "MultiSelectDropdown2" }
                    |> MultiSelectDropdown.withLabel "Label"
                    |> MultiSelectDropdown.withPlaceholder "Choose an option"
                    |> MultiSelectDropdown.withHasFocus model.customModel.hasMultiSelectDropdownFocus
                    |> MultiSelectDropdown.withRequirednessHint (Just (Label.Mandatory .no))
                    |> MultiSelectDropdown.withOptionGroups
                        [ { options =
                                [ { name = "1", label = "Valg 1", isChecked = model.customModel.isChoice1, onCheck = \_ -> OnCheckChoice1 }
                                , { name = "2", label = "Valg 2", isChecked = model.customModel.isChoice2, onCheck = \_ -> OnCheckChoice2 }
                                ]
                          , groupLabel = Just "Group 1"
                          }
                        , { options =
                                [ { name = "3", label = "Valg 3", isChecked = model.customModel.isChoice3, onCheck = \_ -> OnCheckChoice3 }
                                ]
                          , groupLabel = Just "Group 2"
                          }
                        ]
                    |> MultiSelectDropdown.view []
          , {}
          )
        , ( "With filter"
          , \model ->
                MultiSelectDropdown.init { onFocus = FocusMultiSelectDropdown, uniqueId = "MultiSelectDropdown3" }
                    |> MultiSelectDropdown.withLabel "Label"
                    |> MultiSelectDropdown.withPlaceholder "Choose an option or type"
                    |> MultiSelectDropdown.withHasFocus model.customModel.hasMultiSelectDropdownFocus
                    |> MultiSelectDropdown.withRequirednessHint (Just (Label.Mandatory .no))
                    |> MultiSelectDropdown.withHintText (Just "Hint")
                    |> MultiSelectDropdown.withInput model.customModel.searchComponentInput SearchComponentInputWithCmd
                    |> MultiSelectDropdown.withOptionGroups
                        [ { options =
                                [ { name = "1", label = "Valg 1", isChecked = model.customModel.isChoice1, onCheck = \_ -> OnCheckChoice1 }
                                , { name = "2", label = "Valg 2", isChecked = model.customModel.isChoice2, onCheck = \_ -> OnCheckChoice2 }
                                ]
                          , groupLabel = Just "Group 1"
                          }
                        , { options =
                                [ { name = "3", label = "Valg 3", isChecked = model.customModel.isChoice3, onCheck = \_ -> OnCheckChoice3 }
                                ]
                          , groupLabel = Just "Group 2"
                          }
                        ]
                    |> MultiSelectDropdown.view [ css [ width (rem 40) ] ]
          , {}
          )
        , ( "With error (if input is non-empty)"
          , \model ->
                MultiSelectDropdown.init { onFocus = FocusMultiSelectDropdown, uniqueId = "MultiSelectDropdown4" }
                    |> MultiSelectDropdown.withLabel "Label"
                    |> MultiSelectDropdown.withPlaceholder "Choose an option or type"
                    |> MultiSelectDropdown.withHasFocus model.customModel.hasMultiSelectDropdownFocus
                    |> MultiSelectDropdown.withRequirednessHint (Just (Label.Mandatory .no))
                    |> MultiSelectDropdown.withInput model.customModel.searchComponentInput SearchComponentInputWithCmd
                    |> MultiSelectDropdown.withError (Just model.customModel.searchComponentInput |> Maybe.filter (String.isEmpty >> not))
                    |> MultiSelectDropdown.withOptionGroups
                        [ { options =
                                [ { name = "1", label = "Valg 1", isChecked = model.customModel.isChoice1, onCheck = \_ -> OnCheckChoice1 }
                                , { name = "2", label = "Valg 2", isChecked = model.customModel.isChoice2, onCheck = \_ -> OnCheckChoice2 }
                                ]
                          , groupLabel = Just "Group 1"
                          }
                        , { options =
                                [ { name = "3", label = "Valg 3", isChecked = model.customModel.isChoice3, onCheck = \_ -> OnCheckChoice3 }
                                ]
                          , groupLabel = Just "Group 2"
                          }
                        ]
                    |> MultiSelectDropdown.view []
          , {}
          )
        ]
