module Stories.RadioButton exposing (stories)

import Html.Styled as Html exposing (text)
import Nordea.Components.RadioButton as RadioButton
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI a b {}
stories =
    styledStoriesOf
        "RadioButton"
        [ ( "Default"
          , \_ -> Html.div [] [
                RadioButton.init False
                    |> RadioButton.view [] [ text "Click me" ]
                    ,
                RadioButton.init False
                    |> RadioButton.view [] [ text "Click me" ]
                    ]
          , {}
          )
        ]
