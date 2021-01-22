module Stories.TextInput exposing (stories)

import Components.TextInput as TextInput
import Html.Styled.Attributes exposing (disabled)
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
        ]
