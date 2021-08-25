module Stories.Dropdown exposing (stories)

import Nordea.Components.Dropdown as Dropdown
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI a b {}
stories =
    styledStoriesOf
        "Dropdown"
        [ ( "Default"
          , \_ ->
                Dropdown.init
                    "no"
                    [ { value = "no", label = "Norway" }
                    , { value = "se", label = "Sweden" }
                    , { value = "dk", label = "Denmark" }
                    ]
                    |> Dropdown.view []
          , {}
          )
        , ( "Error"
          , \_ ->
                Dropdown.init
                    "no"
                    [ { value = "no", label = "Norway" }
                    , { value = "se", label = "Sweden" }
                    , { value = "dk", label = "Denmark" }
                    ]
                    |> Dropdown.withError True
                    |> Dropdown.view []
          , {}
          )
        ]
