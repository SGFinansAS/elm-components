module Stories.Range exposing (stories)

import Config exposing (Config, Msg(..))
import Nordea.Components.Range as Range
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI Config Msg {}
stories =
    styledStoriesOf
        "Range"
        [ ( "Simple"
          , \model ->
                Range.init model.customModel.rangeInputValue 1 10 RangeMsg
                    |> Range.view []
          , {}
          )
        , ( "With Interval"
          , \model ->
                Range.init model.customModel.rangeInputValue 1 10 RangeMsg
                    |> Range.withShowInterval True
                    |> Range.view []
          , {}
          )
        ]
