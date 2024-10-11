module Stories.FiveStarRating exposing (stories)

import Config exposing (Config, Msg(..))
import Nordea.Components.FiveStarRating as FiveStarRating
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI Config Msg {}
stories =
    styledStoriesOf
        "FiveStarRating"
        [ ( "Primary"
          , \config ->
                FiveStarRating.init SetRating SetRating
                    |> FiveStarRating.view config.customModel.fiveStarRating []
          , {}
          )
        ]
