module Stories.Button exposing (stories)

import Components.Button as Button
import Html.Styled as Html exposing (Html)
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (StyledStory, styledStoriesOf)


stories : UI a b {}
stories =
    styledStoriesOf
        "Button"
        [ ( "Primary"
          , \_ -> Button.primary |> Button.view [] [ Html.text "Click me" ]
          , {}
          )
        , ( "Secondary"
          , \_ -> Button.secondary |> Button.view [] [ Html.text "Click me" ]
          , {}
          )
        , ( "Tertiary"
          , \_ -> Button.tertiary |> Button.view [] [ Html.text "Click me" ]
          , {}
          )
        ]