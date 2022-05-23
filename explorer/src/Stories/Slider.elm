module Stories.Slider exposing (..)

import Config exposing (Config, Msg(..))
import Nordea.Components.Slider as Slider
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI Config Msg {}
stories =
    styledStoriesOf
        "Slider"
        [ ( "Default"
          , \model ->
                Slider.init model.customModel.sliderInputValue 1 10 "Select loan period" "(1-10 years)" SliderMsg
                    |> Slider.view []
          , {}
          )
        ]
