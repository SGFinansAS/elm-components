module Stories.Spinner exposing (..)

import Config exposing (Config, Msg(..))
import Css exposing (rem, width)
import Html.Styled.Attributes exposing (css)
import Nordea.Components.Spinner as Spinner
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI Config Msg {}
stories =
    styledStoriesOf
        "Spinner"
        [ ( "Small"
          , \_ -> Spinner.small []
          , {}
          )
        , ( "Custom"
          , \_ -> Spinner.custom [ css [ width (rem 1) ] ]
          , {}
          )
        ]
