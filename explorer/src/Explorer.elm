module Explorer exposing (main)

import Stories.Button as Button
import Stories.Checkbox as Checkbox
import Stories.Dropdown as Dropdown
import Stories.NumberInput as NumberInput
import Stories.RadioButton as RadioButton
import Stories.TextInput as TextInput
import Stories.FlatLink as FlatLink
import Stories.StepIndicator as StepIndicator
import UIExplorer
    exposing
        ( UIExplorerProgram
        , defaultConfig
        , explore
        )


main : UIExplorerProgram {} () {}
main =
    explore defaultConfig
        [ Button.stories
        , FlatLink.stories
        , TextInput.stories
        , NumberInput.stories
        , Dropdown.stories
        , Checkbox.stories
        , RadioButton.stories
        , StepIndicator.stories
        ]
