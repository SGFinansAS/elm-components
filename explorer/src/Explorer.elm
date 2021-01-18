module Explorer exposing (main)

import Html as Html exposing (Html)
import Stories.Button as Button
import UIExplorer
    exposing
        ( UIExplorerProgram
        , defaultConfig
        , explore
        )


main : UIExplorerProgram {} () {}
main =
    explore defaultConfig [ Button.stories ]
