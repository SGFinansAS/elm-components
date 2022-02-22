module Stories.Feedback exposing (stories)

import Config exposing (Msg(..))
import Css exposing (column, displayFlex, flexDirection, marginBottom, rem)
import Css.Global exposing (children, everything)
import Html.Styled as Html exposing (text)
import Html.Styled.Attributes exposing (css)
import Nordea.Components.Feedback as Feedback
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI a Msg {}
stories =
    styledStoriesOf
        "Feedback"
        [ ( "Standard"
          , \_ ->
                Html.div [ css [ children [ everything [ marginBottom (rem 2) ] ] ] ]
                    [ Feedback.floatingButton .no NoOp
                    ]
          , {}
          )
        ]
