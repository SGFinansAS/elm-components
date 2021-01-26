module Stories.Button exposing (stories)

import Html.Styled as Html exposing (text)
import Html.Styled.Attributes exposing (disabled)
import Nordea.Components.Button as Button
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI a b {}
stories =
    styledStoriesOf
        "Button"
        [ ( "Primary"
          , \_ ->
                Button.primary
                    |> Button.view [] [ text "Click me" ]
          , {}
          )
        , ( "Primary (Disabled)"
          , \_ ->
                Button.primary
                    |> Button.view [ disabled True ] [ text "Click me" ]
          , {}
          )
        , ( "Secondary"
          , \_ ->
                Button.secondary
                    |> Button.view [] [ text "Click me" ]
          , {}
          )
        , ( "Tertiary"
          , \_ ->
                Button.tertiary
                    |> Button.view [] [ text "Click me" ]
          , {}
          )
        ]
