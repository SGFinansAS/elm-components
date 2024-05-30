module Stories.DatePicker exposing (stories)

import Config exposing (Config, Msg(..))
import Date
import Nordea.Components.DatePicker as DatePicker
import Time exposing (Month(..))
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI Config Msg {}
stories =
    styledStoriesOf
        "DatePicker"
        [ ( "Standard"
          , \model ->
                DatePicker.init
                    { today = Date.fromCalendarDate 2024 May 1
                    , internalState = model.customModel.datePickerInternalState
                    , onInternalStateChange = UpdateDatePickerInternalState
                    , onSelect = DateSelected
                    , currentValue = model.customModel.currentDatePickerValue
                    }
                    |> DatePicker.view [] []
          , {}
          )
        ]
