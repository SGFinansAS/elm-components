module Explorer exposing (main)

import Html.Styled as Html
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
        [ styledStoriesOf
            "Button"
            [ ( "Primary", \_ -> Html.text "Welcome to you explorer.", {} )
            , ( "Secondary", \_ -> Html.text "Welcome to you explorer.", {} )
            , ( "Tertiary", \_ -> Html.text "Welcome to you explorer.", {} )
            ]
        ]
