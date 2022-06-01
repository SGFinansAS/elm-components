module Stories.FeatureBox exposing (stories)

import Config exposing (Msg(..))
import Html.Styled as Html
import Html.Styled.Events exposing (onClick)
import Nordea.Components.Button as Button
import Nordea.Components.FeatureBox as FeatureBox
import Nordea.Resources.Illustrations as Illustrations
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI Config.Config Msg {}
stories =
    styledStoriesOf
        "FeatureBox"
        [ ( "FeatureBox"
          , \model ->
                Html.div []
                    [ Button.primary
                        |> Button.view [ onClick ToggleFeatureBox ] [ Html.text "Show FeatureBox" ]
                    , if model.customModel.isFeatureBoxOpen then
                        FeatureBox.init model.customModel.isFeatureBoxOpen ToggleFeatureBox "New feature" "Place tolltip message here thats is over 2 lines max"
                            |> FeatureBox.withIcon Illustrations.confetti2
                            |> FeatureBox.withButton
                                (Button.primary
                                    |> Button.view [] [ Html.text "Click me" ]
                                )
                            |> FeatureBox.view

                      else
                        Html.text ""
                    ]
          , {}
          )
        ]
