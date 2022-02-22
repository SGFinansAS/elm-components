module Stories.FileUpload exposing (stories)

import Config exposing (Msg(..))
import Css exposing (column, displayFlex, flexDirection, marginTop, maxWidth, rem)
import Html.Styled as Html
import Html.Styled.Attributes exposing (css, disabled)
import Nordea.Components.FileUpload as FileUpload
import Nordea.Components.Label as Label
import Nordea.Html exposing (showIf)
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI Config.Config Msg {}
stories =
    styledStoriesOf
        "FileUpload"
        [ ( "Standard (Single file)"
          , \model ->
                Html.div [ css [ displayFlex, flexDirection column, maxWidth (rem 30) ] ]
                    [ Label.init "Some file document" Label.InputLabel
                        |> Label.withRequirednessHint (Just (Label.Optional .no))
                        |> Label.view []
                            [ FileUpload.init .no OnFilesSelected OnDragEnterFileUpload OnDragLeaveFileUpload
                                |> FileUpload.withIsHovering model.customModel.isHoveringFileUpload
                                |> FileUpload.withAcceptedFileTypes (FileUpload.Only [ FileUpload.Pdf, FileUpload.Jpeg, FileUpload.Png ])
                                |> FileUpload.view
                            ]
                    , FileUpload.uploadedFilesView model.customModel.selectedFiles RemoveFile .no [ css [ marginTop (rem 1) ] ]
                        |> showIf (not (List.isEmpty model.customModel.selectedFiles))
                    ]
          , {}
          )
        , ( "Standard (Multiple files)"
          , \model ->
                Html.div [ css [ displayFlex, flexDirection column, maxWidth (rem 30) ] ]
                    [ Label.init "Some file document" Label.InputLabel
                        |> Label.withRequirednessHint (Just (Label.Optional .no))
                        |> Label.view []
                            [ FileUpload.init .no OnFilesSelected OnDragEnterFileUpload OnDragLeaveFileUpload
                                |> FileUpload.withIsHovering model.customModel.isHoveringFileUpload
                                |> FileUpload.withAcceptedFileTypes (FileUpload.Only [ FileUpload.Pdf, FileUpload.Jpeg, FileUpload.Png ])
                                |> FileUpload.withAllowMultipleFiles True
                                |> FileUpload.view
                            ]
                    , FileUpload.uploadedFilesView model.customModel.selectedFiles RemoveFile .no [ css [ marginTop (rem 1) ] ]
                        |> showIf (not (List.isEmpty model.customModel.selectedFiles))
                    ]
          , {}
          )
        , ( "With error"
          , \model ->
                Html.div [ css [ displayFlex, flexDirection column, maxWidth (rem 30) ] ]
                    [ Label.init "Some file document" Label.InputLabel
                        |> Label.withRequirednessHint (Just (Label.Optional .no))
                        |> Label.withErrorMessage (Just "Some validation error")
                        |> Label.view []
                            [ FileUpload.init .no OnFilesSelected OnDragEnterFileUpload OnDragLeaveFileUpload
                                |> FileUpload.withIsHovering model.customModel.isHoveringFileUpload
                                |> FileUpload.withAcceptedFileTypes (FileUpload.Only [ FileUpload.Pdf, FileUpload.Jpeg, FileUpload.Png ])
                                |> FileUpload.withAllowMultipleFiles True
                                |> FileUpload.view
                            ]
                    , FileUpload.uploadedFilesView model.customModel.selectedFiles RemoveFile .no [ css [ marginTop (rem 1) ] ]
                        |> showIf (not (List.isEmpty model.customModel.selectedFiles))
                    ]
          , {}
          )
        ]
