module Stories.Slider exposing (stories)

import Config exposing (Config, Msg(..))
import Nordea.Components.Slider as Slider
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI Config Msg {}
stories =
    styledStoriesOf
        "Slider"
        [ ( "Simple"
          , \model ->
                Slider.init model.customModel.sliderInputValue 1 10 "Select loan period" "(1-10 years)" SliderMsg
                    |> Slider.view []
          , {}
          )
        , ( "With NumberInput"
          , \model ->
                Slider.init model.customModel.sliderInputValue 1 10 "Select loan period" "(1-10 years)" SliderMsg
                    |> Slider.withShowNumberInput True
                    |> Slider.view []
          , {}
          )
        , ( "With Interval"
          , \model ->
                Slider.init model.customModel.sliderInputValue 1 10 "Select loan period" "(1-10 years)" SliderMsg
                    |> Slider.withShowInterval True
                    |> Slider.view []
          , {}
          )
        ]
