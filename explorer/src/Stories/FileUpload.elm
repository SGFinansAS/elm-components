module Stories.FileUpload exposing (stories)

import Config exposing (Msg(..))
import Css exposing (column, displayFlex, flexDirection, marginTop, maxWidth, rem)
import Html.Styled as Html
import Html.Styled.Attributes exposing (css)
import Nordea.Components.FileUpload as FileUpload
import Nordea.Components.Label as Label
import Nordea.Html exposing (showIf)
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI Config.Config Msg {}
stories =
    let
        supportedFileTypes =
            FileUpload.Only [ FileUpload.Pdf, FileUpload.Jpeg, FileUpload.Png ]
    in
    styledStoriesOf
        "FileUpload"
        [ ( "Large (Single file)"
          , \model ->
                Html.div [ css [ displayFlex, flexDirection column, maxWidth (rem 30) ] ]
                    [ Label.init "Some file document" Label.InputLabel
                        |> Label.withRequirednessHint (Just (Label.Optional .no))
                        |> Label.view []
                            [ FileUpload.init .no OnFilesSelected OnDragEnterFileUpload OnDragLeaveFileUpload
                                |> FileUpload.withIsHovering model.customModel.isHoveringFileUpload
                                |> FileUpload.withAcceptedFileTypes supportedFileTypes
                                |> FileUpload.view
                            ]
                    , FileUpload.uploadedFilesView model.customModel.selectedFiles RemoveFile .no [ css [ marginTop (rem 1) ] ]
                        |> showIf (not (List.isEmpty model.customModel.selectedFiles))
                    ]
          , {}
          )
        , ( "Large (Multiple files)"
          , \model ->
                Html.div [ css [ displayFlex, flexDirection column, maxWidth (rem 30) ] ]
                    [ Label.init "Some file document" Label.InputLabel
                        |> Label.withRequirednessHint (Just (Label.Optional .no))
                        |> Label.view []
                            [ FileUpload.init .no OnFilesSelected OnDragEnterFileUpload OnDragLeaveFileUpload
                                |> FileUpload.withIsHovering model.customModel.isHoveringFileUpload
                                |> FileUpload.withAcceptedFileTypes supportedFileTypes
                                |> FileUpload.withAllowMultipleFiles True
                                |> FileUpload.view
                            ]
                    , FileUpload.uploadedFilesView model.customModel.selectedFiles RemoveFile .no [ css [ marginTop (rem 1) ] ]
                        |> showIf (not (List.isEmpty model.customModel.selectedFiles))
                    ]
          , {}
          )
        , ( "Large with error"
          , \model ->
                Html.div [ css [ displayFlex, flexDirection column, maxWidth (rem 30) ] ]
                    [ Label.init "Some file document" Label.InputLabel
                        |> Label.withRequirednessHint (Just (Label.Optional .no))
                        |> Label.withErrorMessage (Just "Some validation error")
                        |> Label.view []
                            [ FileUpload.init .no OnFilesSelected OnDragEnterFileUpload OnDragLeaveFileUpload
                                |> FileUpload.withIsHovering model.customModel.isHoveringFileUpload
                                |> FileUpload.withAcceptedFileTypes supportedFileTypes
                                |> FileUpload.withAllowMultipleFiles True
                                |> FileUpload.view
                            ]
                    , FileUpload.uploadedFilesView model.customModel.selectedFiles RemoveFile .no [ css [ marginTop (rem 1) ] ]
                        |> showIf (not (List.isEmpty model.customModel.selectedFiles))
                    ]
          , {}
          )
        , ( "Small"
          , \model ->
                Html.div [ css [ displayFlex, flexDirection column, maxWidth (rem 30) ] ]
                    [ Label.init "Some file document" Label.InputLabel
                        |> Label.withRequirednessHint (Just (Label.Optional .no))
                        |> Label.withHintText (FileUpload.supportedFileTypesText .no supportedFileTypes)
                        |> Label.view []
                            [ FileUpload.init .no OnFilesSelected OnDragEnterFileUpload OnDragLeaveFileUpload
                                |> FileUpload.withIsHovering model.customModel.isHoveringFileUpload
                                |> FileUpload.withAcceptedFileTypes supportedFileTypes
                                |> FileUpload.withAllowMultipleFiles True
                                |> FileUpload.withAppearance FileUpload.Small
                                |> FileUpload.view
                            ]
                    , FileUpload.uploadedFilesView model.customModel.selectedFiles RemoveFile .no [ css [ marginTop (rem 1) ] ]
                        |> showIf (not (List.isEmpty model.customModel.selectedFiles))
                    ]
          , {}
          )
        , ( "Small with error"
          , \model ->
                Html.div [ css [ displayFlex, flexDirection column, maxWidth (rem 30) ] ]
                    [ Label.init "Some file document" Label.InputLabel
                        |> Label.withRequirednessHint (Just (Label.Optional .no))
                        |> Label.withErrorMessage (FileUpload.supportedFileTypesText .no supportedFileTypes)
                        |> Label.view []
                            [ FileUpload.init .no OnFilesSelected OnDragEnterFileUpload OnDragLeaveFileUpload
                                |> FileUpload.withIsHovering model.customModel.isHoveringFileUpload
                                |> FileUpload.withAcceptedFileTypes supportedFileTypes
                                |> FileUpload.withAllowMultipleFiles True
                                |> FileUpload.withAppearance FileUpload.Small
                                |> FileUpload.view
                            ]
                    , FileUpload.uploadedFilesView model.customModel.selectedFiles RemoveFile .no [ css [ marginTop (rem 1) ] ]
                        |> showIf (not (List.isEmpty model.customModel.selectedFiles))
                    ]
          , {}
          )
        ]
