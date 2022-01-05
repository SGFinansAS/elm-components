module Stories.TextArea exposing (stories)

import Html.Styled.Attributes exposing (disabled)
import Nordea.Components.TextArea as TextArea
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI a b {}
stories =
    styledStoriesOf
        "TextArea"
        [ ( "Empty"
          , \_ ->
                TextArea.init "Text"
                    |> TextArea.view []
          , {}
          )
        , ( "Focus"
          , \_ ->
                TextArea.init "Text"
                    |> TextArea.view [ disabled True ]
          , {}
          )
        , ( "Filled"
          , \_ ->
                TextArea.init ""
                    |> TextArea.view []
          , {}
          )
        , ( "Error"
          , \_ ->
                TextArea.init ""
                    |> TextArea.view []
          , {}
          )
        , ( "Disabled"
          , \_ ->
                TextArea.init ""
                    |> TextArea.view []
          , {}
          )
        ]
