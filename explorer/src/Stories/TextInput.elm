module Stories.TextInput exposing (stories)

import Html.Styled.Attributes exposing (disabled)
import Nordea.Components.TextInput as TextInput
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI a b {}
stories =
    styledStoriesOf
        "TextInput"
        [ ( "Default"
          , \_ ->
                TextInput.init "Text"
                    |> TextInput.view []
          , {}
          )
        , ( "Default (Disabled)"
          , \_ ->
                TextInput.init "Text"
                    |> TextInput.view [ disabled True ]
          , {}
          )
        , ( "Placeholder"
          , \_ ->
                TextInput.init ""
                    |> TextInput.withPlaceholder "Text"
                    |> TextInput.view []
          , {}
          )
        , ( "Max length 3"
          , \_ ->
                TextInput.init ""
                    |> TextInput.withPlaceholder "Type something"
                    |> TextInput.withMaxLength 3
                    |> TextInput.view []
          , {}
          )
          , ( "Pattern only digits"
          , \_ ->
                TextInput.init ""
                    |> TextInput.withPlaceholder "Type something"
                    |> TextInput.withPattern "\\d*"
                    |> TextInput.view []
          , {}
          )
          , ( "Error"
          , \_ ->
                TextInput.init "Text"
                    |> TextInput.withError True
                    |> TextInput.view []
          , {}
          )
        ]
