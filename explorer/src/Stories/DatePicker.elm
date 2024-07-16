module Stories.DatePicker exposing (stories)

import Config exposing (Config, Msg)
import Nordea.Components.DatePicker as DatePicker
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI Config Msg {}
stories =
    styledStoriesOf
        "DatePicker"
        [ ( "Standard"
          , \model ->
                model.customModel.datePicker
                    |> DatePicker.view [] []
          , {}
          )
        ]
