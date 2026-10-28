module Stories.Tag exposing (stories)

import Nordea.Components.Tag as Tag
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI a b {}
stories =
    styledStoriesOf
        "Tag"
        [ ( "Beta"
          , \_ -> Tag.beta []
          , {}
          )
        ]
