module Stories.Snackbar exposing (..)

import Config exposing (Msg(..))
import Html.Styled exposing (text)
import Nordea.Components.Snackbar as Snackbar
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI a Msg {}
stories =
    styledStoriesOf
        "Snackbar"
        [ ( "Info"
          , \_ -> Snackbar.info SnackbarMsg |> Snackbar.view [] [ text "Hello" ]
          , {}
          )
        , ( "Success"
          , \_ -> Snackbar.init Snackbar.Success SnackbarMsg |> Snackbar.view [] [ text "Hello" ]
          , {}
          )
        , ( "Warning"
          , \_ -> Snackbar.init Snackbar.Warning SnackbarMsg |> Snackbar.view [] [ text "Hello" ]
          , {}
          )
        ]
