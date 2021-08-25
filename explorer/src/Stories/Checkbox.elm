module Stories.Checkbox exposing (stories)

import Html.Styled exposing (text)
import Nordea.Components.Checkbox as Checkbox
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI a b {}
stories =
    styledStoriesOf
        "Checkbox"
        [ ( "Default"
          , \_ ->
                Checkbox.init False
                    |> Checkbox.view [] [ text "Click me" ]
          , {}
          )
        , ( "Error"
          , \_ ->
                Checkbox.init False
                    |> Checkbox.withError True
                    |> Checkbox.view [] [ text "Click me" ]
          , {}
          )
        ]
