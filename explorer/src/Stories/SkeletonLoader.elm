module Stories.SkeletonLoader exposing (stories)

import Config exposing (Config, Msg(..))
import Css exposing (rem, width)
import Html.Styled.Attributes exposing (css)
import Css
    exposing
        ( rem
        , height
        , pct
        , width
        , borderRadius)
import Nordea.Components.SkeletonLoader as SkeletonLoader
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI Config Msg {}
stories =
    styledStoriesOf
        "SkeletonLoader"
        [ ( "Default"
          , \_ -> SkeletonLoader.view [css [ width (pct 50), height (rem 2.5), borderRadius (rem 0.25) ]]
          , {}
          )
        , ( "Button"
          , \_ -> SkeletonLoader.view [ css [borderRadius (rem 2), width (rem 6), height (rem 2.5)] ]
          , {}
          )
        ]
