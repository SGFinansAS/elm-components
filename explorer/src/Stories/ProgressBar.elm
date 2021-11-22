module Stories.ProgressBar exposing (stories)

import Config exposing (Msg(..))
import Css exposing (column, displayFlex, flexDirection, marginBottom, rem)
import Css.Global exposing (children, everything)
import Html.Styled as Html exposing (text)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events exposing (onClick)
import Nordea.Components.Button as Button
import Nordea.Components.ProgressBar as ProgressBar
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI Config.Config Msg {}
stories =
    styledStoriesOf
        "ProgressBar"
        [ ( "Default"
          , \model ->
                Html.div [ css [ children [ everything [ marginBottom (rem 2) |> Css.important ] ] ] ]
                    [ Button.primary
                        |> Button.view [ onClick ToggleProgressBarCompleted ] [ Html.text "Toggle completed state" ]
                    , ProgressBar.init { progress = 30, isCompleted = model.customModel.isProgressBarCompleted }
                        |> ProgressBar.view []
                    ]
          , {}
          )
        ]
