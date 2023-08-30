module Stories.Modal exposing (..)

import Config exposing (Msg(..))
import Css exposing (..)
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
                        Modal.default ToggleModal
                            |> Modal.withTitle "Title"
                            |> Modal.view
                                [ css [ width (rem 35) ] ]
                                [ Html.text "Suggested width is 560px (35rem)" ]

                      else
                        Html.text ""
                    ]
          , {}
          )
        , ( "News Modal"
          , \model ->
                Html.div []
                    [ Button.primary
                        |> Button.view [ onClick ToggleModal ] [ Html.text "Show modal" ]
                    , if model.customModel.isModalOpen then
                        Modal.newsModal ToggleModal
                            |> Modal.withTitle "Title"
                            |> Modal.withSubtitle "Subtitle | Subtitle"
                            |> Modal.view
                                [ css [ width (rem 35) ] ]
                                [ Html.text "Suggested width is 560px (35rem)" ]

                      else
                        Html.text ""
                    ]
          , {}
          )
        , ( "Responsive"
          , \model ->
                Html.div []
                    [ Button.primary
                        |> Button.view [ onClick ToggleModal ] [ Html.text "Show modal" ]
                    , if model.customModel.isModalOpen then
                        Modal.default ToggleModal
                            |> Modal.withTitle "Title"
                            |> Modal.view
                                [ css [ maxWidth (rem 35), width (pct 100) ] ]
                                [ Html.text "Max width is 560px (35rem)" ]

                      else
                        Html.text ""
                    ]
          , {}
          )
        ]
