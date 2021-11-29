module Stories.LottiePlayer exposing (stories)

import Css exposing (px)
import Html.Styled.Attributes as Attrs
import Nordea.Components.LottiePlayer as LottiePlayer
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI a b {}
stories =
    styledStoriesOf
        "LottiePlayer"
        [ ( "Primary"
          , \_ ->
                LottiePlayer.init "https://assets5.lottiefiles.com/datafiles/zc3XRzudyWE36ZBJr7PIkkqq0PFIrIBgp4ojqShI/newAnimation.json"
                    |> LottiePlayer.view [ Attrs.css [ Css.width (px 200) ] ]
          , {}
          )
        ]
