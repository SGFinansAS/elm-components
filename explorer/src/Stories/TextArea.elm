module Stories.TextArea exposing (stories)

import Html.Styled.Attributes exposing (disabled)
import Nordea.Components.TextInput as TextInput
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI a b {}
stories =
    styledStoriesOf
        "TextArea"
        [ ( "Empty"
          , \_ ->
                TextInput.init "Text"
                    |> TextInput.view []
          , {}
          )
        , ( "Focus"
          , \_ ->
                TextInput.init "Text"
                    |> TextInput.view [ disabled True ]
          , {}
          )
        , ( "Filled"
          , \_ ->
                TextInput.init ""
                    |> TextInput.withPlaceholder "Text"
                    |> TextInput.view []
          , {}
          )
        , ( "Error"
          , \_ ->
                TextInput.init ""
                    |> TextInput.withPlaceholder "Type something"
                    |> TextInput.withMaxLength 3
                    |> TextInput.view []
          , {}
          )
        , ( "Disabled"
          , \_ ->
                TextInput.init ""
                    |> TextInput.withPlaceholder "Type something"
                    |> TextInput.withPattern "\\d*"
                    |> TextInput.view []
          , {}
          )
        ]
