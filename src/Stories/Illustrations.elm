module Stories.Illustrations exposing (stories)

import Css exposing (rem, width)
import Html.Styled.Attributes exposing (css)
import Nordea.Resources.Illustrations as Illustrations
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI a b {}
stories =
    styledStoriesOf
        "Illustrations"
        [ ( "Parachute"
          , \_ ->
                Illustrations.parachute [ css [ width (rem 10) ] ]
          , {}
          )
        , ( "InstructionalInfo"
          , \_ ->
                Illustrations.instructionalInfo [ css [ width (rem 5) ] ]
          , {}
          )
        , ( "InstructionalWarning"
          , \_ ->
                Illustrations.instructionalWarning [ css [ width (rem 5) ] ]
          , {}
          )
        ]
