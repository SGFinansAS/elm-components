module Stories.TextArea exposing (stories)

import Nordea.Components.TextArea as TextArea
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI a b {}
stories =
    styledStoriesOf
        "TextArea"
        [ ( "Default"
          , \_ ->
                TextArea.init "Label" "Text"
                    |> TextArea.withCharCounter { current = 30, max = 50 }
                    |> TextArea.view []
          , {}
          )
        , ( "Textarea with error"
          , \_ ->
                TextArea.init "Label" "Text"
                    |> TextArea.withErrorMessage "Some error here"
                    --|> TextArea.withCharCounter 30
                    |> TextArea.view []
          , {}
          )
        ]
