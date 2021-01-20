module Stories.Button exposing (stories)

import Components.Button as Button
import Html.Styled as Html exposing (text)
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI a b {}
stories =
    styledStoriesOf
        "Button"
        [ ( "Primary"
          , \_ -> Button.primary |> Button.view [] [ text "Click me" ]
          , {}
          )
        , ( "Secondary"
          , \_ -> Button.secondary |> Button.view [] [ text "Click me" ]
          , {}
          )
        , ( "Tertiary"
          , \_ -> Button.tertiary |> Button.view [] [ text "Click me" ]
          , {}
          )
        ]
