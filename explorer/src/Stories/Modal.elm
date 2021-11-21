module Stories.Modal exposing (..)

import Config exposing (Msg(..))
import Css exposing (rem, width)
import Html.Styled as Html
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events exposing (onClick)
import Nordea.Components.Button as Button
import Nordea.Components.Modal as Modal
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI Config.Config Msg {}
stories =
    styledStoriesOf
        "Modal"
        [ ( "Default"
          , \model ->
                Html.div []
                    [ Button.primary
                        |> Button.view [ onClick ToggleModal ] [ Html.text "Show modal" ]
                    , if model.customModel.isModalOpen then
                        Modal.view
                            { onClickClose = ToggleModal
                            , title = "Header"
                            }
                            [ css [ width (rem 35) ] ]
                            [ Html.text "Suggested width is 560px (35rem)" ]

                      else
                        Html.text ""
                    ]
          , {}
          )
        ]
