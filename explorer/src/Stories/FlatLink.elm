module Stories.FlatLink exposing (stories)

import Html.Styled exposing (text)
import Html.Styled.Attributes exposing (href)
import Nordea.Components.FlatLink as FlatLink
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI a b {}
stories =
    styledStoriesOf
        "FlatLink"
        [ ( "Primary"
          , \_ ->
                FlatLink.primary
                    |> FlatLink.view [ href "/#Default/FlatLink/Primary" ] [ text "Click me" ]
          , {}
          )
        , ( "Primary (Disabled)"
          , \_ ->
                FlatLink.primary
                    |> FlatLink.withDisabled
                    |> FlatLink.view [] [ text "Click me" ]
          , {}
          )
        , ( "Mini"
          , \_ ->
                FlatLink.mini
                    |> FlatLink.view [ href "/#Default/FlatLink/Mini" ] [ text "Click me" ]
          , {}
          )
        ]
