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
                DatePicker.view []
                    { hasFocus = model.customModel.datePickerIsOpen
                    , onFocus = UpdateDatePickerState
                    , input = model.customModel.dateInput
                    , onInput = DateInputChange
                    , today = Date.fromCalendarDate 2024 May 1
                    , onSelect = DateSelected
                    , onMonthChange = UpdateDatePickerMonth
                    , selectedMonth = model.customModel.datePickerMonth
                    }
                    []
          , {}
          )
        ]
