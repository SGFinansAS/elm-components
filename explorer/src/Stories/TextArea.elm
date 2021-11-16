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
                TextArea.init "Text"
                    |> TextArea.view []
          , {}
          )
        ]
