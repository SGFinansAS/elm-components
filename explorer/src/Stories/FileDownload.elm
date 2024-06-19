module Stories.FileDownload exposing (..)

import Config exposing (Config, Msg)
import Nordea.Components.FileDownload as FileDownload
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI Config Msg {}
stories =
    styledStoriesOf
        "FileDownload"
        [ ( "Default"
          , \_ ->
                FileDownload.init .no "Leverandørdokumenter" ""
                    |> FileDownload.view []
          , {}
          )
        ]
