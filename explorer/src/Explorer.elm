module Explorer exposing (main)

import Html
import UIExplorer
    exposing
        ( UIExplorerProgram
        , defaultConfig
        , explore
        , storiesOf
        )




main : UIExplorerProgram {} () {}
main =
    explore
        defaultConfig
        [ storiesOf
            "Button"
            [ ( "Primary", \_ -> Html.text "Welcome to you explorer.", {} )
            , ( "Secondary", \_ -> Html.text "Welcome to you explorer.", {} )
            , ( "Tertiary", \_ -> Html.text "Welcome to you explorer.", {} )
            ]
        ]
