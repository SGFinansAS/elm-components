module Explorer exposing (main)

import Stories.Button as Button
import Stories.TextInput as TextInput
import UIExplorer
    exposing
        ( UIExplorerProgram
        , defaultConfig
        , explore
        )


main : UIExplorerProgram {} () {}
main =
    explore defaultConfig [ Button.stories, TextInput.stories ]
