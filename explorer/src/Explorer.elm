module Explorer exposing (main)

import Button
import UIExplorer
    exposing
        ( UIExplorerProgram
        , defaultConfig
        , explore
        )
import UIExplorer.Styled exposing (styledStoriesOf)


main : UIExplorerProgram {} () {}
main =
    explore
        defaultConfig
        [ Button.stories
        ]
