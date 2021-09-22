module Stories.Spinner exposing (..)

import Config exposing (Config, Msg(..))
import Css exposing (alignSelf, center, color, height, rem, width)
import Html.Styled.Attributes exposing (css)
import Nordea.Components.Spinner as Spinner
import Nordea.Resources.Colors as Colors
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI Config Msg {}
stories =
    styledStoriesOf
        "Spinner"
        [ ( "Default"
          , \_ ->
                Spinner.view
                    [ css
                        [ color Colors.blueDeep
                        , width (rem 3.75)
                        , height (rem 3.75)
                        , alignSelf center
                        ]
                    ]
          , {}
          )
        ]
