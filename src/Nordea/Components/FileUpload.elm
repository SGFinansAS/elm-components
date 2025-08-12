module Nordea.Components.FileUpload exposing
    ( AcceptFileType(..)
    , Appearance(..)
    , FileUpload
    , FileUploadStatus
    , MimeType(..)
    , init
    , supportedFileTypesText
    , uploadedFilesView
    , view
    , withAcceptedFileTypes
    , withAllowMultipleFiles
    , withAppearance
    , withFiles
    , withIsHovering
    )

import Css
    exposing
        ( absolute
        , alignItems
        , backgroundColor
        , border3
        , borderRadius
        , borderStyle
        , borderWidth
        , center
        , color
        , column
        , cursor
        , dashed
        , default
        , displayFlex
        , flex
        , flexDirection
        , height
        , hover
        , inherit
        , justifyContent
        , left
        , listStyle
        , listStyleType
        , margin2
        , marginBottom
        , marginRight
        , marginTop
        , none
        , num
        , opacity
        , padding
        , padding2
        , pct
        , pointer
        , position
        , pseudoClass
        , px
        , relative
        , rem
        , row
        , top
        , width
        )
import Css.Global as Global
import File exposing (File)
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attributes exposing (accept, attribute, css, multiple, type_, value)
import Html.Styled.Events as Events
import Json.Decode as Decode
import Maybe.Extra as Maybe
import Nordea.Components.Spinner as Spinner
import Nordea.Components.Text as Text
import Nordea.Components.Tooltip as Tooltip
import Nordea.Html as Html exposing (attrIf, showIf, styleIf)
import Nordea.Resources.Colors as Colors
import Nordea.Resources.I18N exposing (Translation)
import Nordea.Resources.Icons as Icon
import Nordea.Themes as Themes
import Nordea.Utils.List as List
import RemoteData exposing (RemoteData)
import Round


type MimeType
    = Pdf
    | Jpeg
    | Png


type AcceptFileType
    = Any
    | Only (List MimeType)


type Appearance
    = Large
    | Small
    | Tiny


type alias Translate =
    Translation -> String


type FileUpload msg
    = FileUpload (Config msg)


type alias FileUploadStatus =
    RemoteData Translation ()


type alias Config msg =
    { isHovering : Bool
    , onDragEnter : msg
    , onDragLeave : msg
    , files : List ( File, FileUploadStatus )
    , translate : Translate
    , allowMultiple : Bool
    , onFilesSelected : List File -> msg
    , onFileRemoval : Maybe (File -> msg)
    , accept : AcceptFileType
    , appearance : Appearance
    }


init : Translate -> (List File -> msg) -> msg -> msg -> FileUpload msg
init translate onFilesSelected onDragEnter onDragLeave =
    FileUpload
        { isHovering = False
        , onDragEnter = onDragEnter
        , onDragLeave = onDragLeave
        , files = []
        , translate = translate
        , allowMultiple = False
        , onFilesSelected = onFilesSelected
        , onFileRemoval = Nothing
        , accept = Any
        , appearance = Large
        }


view : FileUpload msg -> Html msg
view (FileUpload config) =
    let
        attrs =
            let
                styleAppearance =
                    case config.appearance of
                        Large ->
                            Css.batch
                                [ flexDirection column
                                , justifyContent center
                                , height (rem 8.375)
                                , padding2 (rem 1.5) (rem 2)
                                ]

                        Small ->
                            Css.batch
                                [ flexDirection row
                                , padding2 (rem 0.75) (rem 1)
                                , justifyContent center |> styleIf config.isHovering
                                ]

                        Tiny ->
                            Css.batch
                                [ flexDirection row
                                , padding2 (rem 0.3) (rem 0.4)
                                , justifyContent center |> styleIf config.isHovering
                                ]

                styleOnHover =
                    if config.isHovering then
                        Css.batch
                            [ border3 (rem 0.0625) dashed Colors.deepBlue
                            , Themes.backgroundColor Colors.cloudBlue
                            ]

                    else
                        Css.batch
                            [ border3 (rem 0.0625) dashed Colors.mediumGray
                            , hover [ backgroundColor Colors.coolGray ]
                            ]
            in
            [ css
                [ displayFlex
                , styleAppearance
                , alignItems center
                , borderRadius (rem 0.25)
                , cursor pointer
                , styleOnHover
                ]
            ]

        iconUpload =
            Icon.upload
                [ attribute "aria-hidden" "true"
                , css
                    ([ Themes.color Colors.nordeaBlue
                     , case config.appearance of
                        Large ->
                            marginBottom (rem 1)

                        Small ->
                            marginRight (rem 1)

                        Tiny ->
                            marginRight (rem 1)
                     ]
                        ++ (if config.appearance == Tiny then
                                [ Css.important (Css.width (rem 0.75)) ]

                            else
                                []
                           )
                    )
                ]

        textType =
            if config.appearance == Tiny then
                Text.textTiny

            else
                Text.bodyTextSmall

        description =
            textType
                |> Text.view
                    [ attribute "aria-hidden" "true"
                    , css [ color Colors.darkGray ]
                    ]
                    [ Html.text (config.translate strings.uploadDescription1)
                    , Html.span
                        [ css [ Themes.color Colors.nordeaBlue ] ]
                        [ Html.text (config.translate strings.uploadDescription2) ]
                    , Html.text (config.translate strings.uploadDescription3)
                    ]

        viewSupportedFileTypesText =
            supportedFileTypesText config.translate config.accept
                |> Html.viewMaybe
                    (\supportedFileTypes ->
                        Text.textTinyLight
                            |> Text.view
                                [ attribute "aria-hidden" "true"
                                , css [ color Colors.darkGray, marginTop (rem 0.5) ]
                                ]
                                [ Html.text supportedFileTypes ]
                    )

        mimeTypesAsString =
            case config.accept of
                Any ->
                    "*"

                Only mimeTypes ->
                    mimeTypes
                        |> List.map toMimeTypeString
                        |> String.join ","

        inputFile =
            let
                isDisabled =
                    not config.allowMultiple && List.isNotEmpty config.files
            in
            Html.input
                [ type_ "file"
                , onSelectFiles config.accept config.onFilesSelected
                , multiple config.allowMultiple
                , accept mimeTypesAsString
                , value ""
                , Attributes.disabled True |> attrIf isDisabled
                , Attributes.attribute "aria-description" (config.translate strings.ariaNoMoreFiles) |> attrIf isDisabled
                , css [ opacity (num 0), position absolute, height (rem 0), width (rem 0) ]
                ]
                []
    in
    -- Inline is currently only supported with one file; feel free to enhance :)
    config.onFileRemoval
        |> Maybe.filter (\_ -> not config.allowMultiple && List.isNotEmpty config.files && config.appearance == Large)
        |> Maybe.map
            (\onFileRemoval ->
                Html.div []
                    [ inputFile
                    , fileList
                        config.files
                        onFileRemoval
                        config.translate
                        (attrs
                            ++ [ css
                                    [ borderWidth (px 0) |> Css.important
                                    , cursor default |> Css.important
                                    , Global.children [ Global.typeSelector ":first-child" [ height inherit, width (pct 100) ] ]

                                    -- 2024-08-22 Elm css first-child is b0rken! ^
                                    ]
                               ]
                        )
                    ]
            )
        |> Maybe.withDefault
            (Html.div
                (attrs
                    ++ [ css [ pseudoClass "focus-within" [ border3 (rem 0.0625) dashed Colors.deepBlue ] ]
                       , onFilesDropped
                            config.accept
                            (\files ->
                                config.onFilesSelected
                                    (if config.allowMultiple then
                                        files

                                     else
                                        files |> List.take 1
                                    )
                            )
                       , preventDefaultOn "dragover" config.onDragEnter
                       , preventDefaultOn "dragleave" config.onDragLeave
                       ]
                )
                [ iconUpload |> showIf (not config.isHovering)
                , description |> showIf (not config.isHovering)
                , viewSupportedFileTypesText
                    |> showIf (not config.isHovering && config.appearance == Large)
                , textType
                    |> Text.view [ css [ Themes.color Colors.nordeaBlue ] ]
                        [ Html.text (config.translate strings.dropToUploadFile) ]
                    |> showIf config.isHovering
                , inputFile
                ]
            )


uploadedFilesView : List File -> (File -> msg) -> Translate -> List (Attribute msg) -> Html msg
uploadedFilesView files onClickRemove translate attrs =
    Html.section attrs
        [ Text.textSmallLight
            |> Text.withHtmlTag Html.h1
            |> Text.view [ css [ marginBottom (rem 0.25) ] ] [ Html.text (translate strings.uploadedFiles) ]
        , fileList
            (files |> List.map (\f -> ( f, RemoteData.NotAsked )))
            onClickRemove
            translate
            []
        ]


fileList : List ( File, FileUploadStatus ) -> (File -> msg) -> Translate -> List (Attribute msg) -> Html msg
fileList files onClickRemove translate attrs =
    let
        fileSizeToString fileSize =
            if fileSize < 1000 then
                String.fromInt fileSize ++ " bytes"

            else if fileSize < 1000 ^ 2 then
                (toFloat fileSize / 1024)
                    |> Round.round 0
                    |> (\str -> str ++ " KB")

            else if fileSize < 1000 ^ 3 then
                (toFloat fileSize / (1000 ^ 2))
                    |> Round.round 1
                    |> String.replace "." ","
                    |> (\str -> str ++ " MB")

            else
                (toFloat fileSize / (1000 ^ 3))
                    |> Round.round 2
                    |> String.replace "." ","
                    |> (\str -> str ++ " GB")

        statusOverlay status =
            (case status of
                RemoteData.NotAsked ->
                    Html.nothing

                RemoteData.Loading ->
                    Spinner.custom [ css [ color Colors.nordeaBlue, width (rem 2) ] ]

                RemoteData.Success _ ->
                    Html.nothing

                RemoteData.Failure translation ->
                    Tooltip.init
                        |> Tooltip.withContent
                            (Tooltip.infoTooltip [] [ translation |> translate |> Html.text ])
                        |> Tooltip.view []
                            [ Icon.warning
                                [ css [ backgroundColor Colors.redStatus, borderRadius (pct 50), width (rem 2) ] ]
                            ]
            )
                |> List.singleton
    in
    Html.ul (css [ listStyleType none, padding (rem 0) ] :: attrs)
        (files
            |> List.map
                (\( file, status ) ->
                    Html.li
                        [ css
                            [ displayFlex
                            , alignItems center
                            , listStyle none
                            , padding2 (rem 0.75) (rem 1.25)
                            , backgroundColor Colors.coolGray
                            , borderRadius (rem 0.5)
                            , pseudoClass "not(:last-child)" [ marginBottom (rem 1) ]
                            ]
                        ]
                        [ Html.div
                            [ attribute "aria-hidden" "true"
                            , css [ position relative ]
                            ]
                            [ Html.div [ css [ position absolute, top (rem -0.4), left (rem -0.45) ] ]
                                (statusOverlay status)
                            , Icon.pdf [ css [ color Colors.black, marginRight (rem 1) ] ]
                            ]
                        , Html.div [ css [ displayFlex, flexDirection column, flex (num 1), marginRight (rem 1) ] ]
                            [ Text.bodyTextSmall
                                |> Text.view [] [ Html.text (File.name file) ]
                            , Text.textTinyLight
                                |> Text.view [] [ file |> File.size |> fileSizeToString |> Html.text ]
                            ]
                        , Html.button
                            [ preventDefaultOn "click" (onClickRemove file)
                            , Attributes.attribute "aria-label" <| translate strings.ariaRemove
                            , Attributes.attribute "aria-description" <| (translate strings.ariaRemoveFromList ++ File.name file)
                            , css
                                [ borderStyle none
                                , Css.property "appearance" "none"
                                , cursor pointer
                                , padding2 (rem 0.75) (rem 1.25)
                                , margin2 (rem -0.75) (rem -1.25)
                                , backgroundColor Colors.transparent
                                ]
                            ]
                            [ Icon.trash
                                [ Attributes.attribute "aria-hidden" "true"
                                , css [ Themes.color Colors.deepBlue ]
                                ]
                            ]
                        ]
                )
        )


supportedFileTypesText : Translate -> AcceptFileType -> Maybe String
supportedFileTypesText translate accept =
    case accept of
        Any ->
            Nothing

        Only mimeTypes ->
            mimeTypes
                |> List.map
                    (\mimeType ->
                        case mimeType of
                            Pdf ->
                                "PDF"

                            Jpeg ->
                                "JPEG"

                            Png ->
                                "PNG"
                    )
                |> List.indexedMap
                    (\i e ->
                        if i > 0 && i + 1 == List.length mimeTypes then
                            translate strings.and ++ e

                        else
                            e
                    )
                |> String.join ", "
                |> (\fileTypes -> translate strings.acceptedFileTypes ++ fileTypes)
                |> Just


withAcceptedFileTypes : AcceptFileType -> FileUpload msg -> FileUpload msg
withAcceptedFileTypes accept (FileUpload config) =
    FileUpload { config | accept = accept }


withIsHovering : Bool -> FileUpload msg -> FileUpload msg
withIsHovering isHovering (FileUpload config) =
    FileUpload { config | isHovering = isHovering }


withAllowMultipleFiles : Bool -> FileUpload msg -> FileUpload msg
withAllowMultipleFiles allowMultiple (FileUpload config) =
    FileUpload { config | allowMultiple = allowMultiple }


withAppearance : Appearance -> FileUpload msg -> FileUpload msg
withAppearance appearance (FileUpload config) =
    FileUpload { config | appearance = appearance }


{-| Make FileUpload aware of already selected files and upload status.

Care should be taken when using this in combination with Labels; Label must be updated to indicate the file upload status
from the file list (e.g. do we have files in the list, uploading, etc) for accessibility purposes.

-}
withFiles : List ( File, FileUploadStatus ) -> (File -> msg) -> FileUpload msg -> FileUpload msg
withFiles files onFileRemoval (FileUpload config) =
    FileUpload
        { config
            | files = files
            , onFileRemoval = Just onFileRemoval
        }


filterFiles : AcceptFileType -> List File -> List File
filterFiles acceptFileType files =
    case acceptFileType of
        Any ->
            files

        Only mimeTypes ->
            files |> List.filter (\file -> List.member (File.mime file) (List.map toMimeTypeString mimeTypes))


onFilesDropped : AcceptFileType -> (List File -> msg) -> Attribute msg
onFilesDropped acceptFileType msg =
    let
        filesDroppedDecoder =
            Decode.at [ "dataTransfer", "files" ] (Decode.list File.decoder)
                |> Decode.map (filterFiles acceptFileType)
                |> Decode.andThen
                    (\files -> Decode.succeed ( msg files, True ))
    in
    Events.preventDefaultOn "drop" filesDroppedDecoder


preventDefaultOn : String -> msg -> Attribute msg
preventDefaultOn event msg =
    Events.preventDefaultOn event (Decode.succeed ( msg, True ))


onSelectFiles : AcceptFileType -> (List File -> msg) -> Attribute msg
onSelectFiles acceptFileType msg =
    let
        filesDecoder =
            Decode.at [ "target", "files" ] (Decode.list File.decoder)
                |> Decode.map (filterFiles acceptFileType)
                |> Decode.andThen
                    (\files -> Decode.succeed (msg files))
    in
    Events.on "change" filesDecoder


toMimeTypeString : MimeType -> String
toMimeTypeString mimeType =
    case mimeType of
        Pdf ->
            "application/pdf"

        Jpeg ->
            "image/jpeg"

        Png ->
            "image/png"


strings =
    { uploadDescription1 =
        { no = "Dra filen hit eller "
        , se = "Dra filen hit eller "
        , dk = "Træk filen hertil eller upload fil "
        , en = "Drag and drop the file here or "
        }
    , uploadDescription2 =
        { no = "bla"
        , se = "bläddra"
        , dk = "HER"
        , en = "browse"
        }
    , uploadDescription3 =
        { no = " for å laste opp"
        , se = " för att ladda upp"
        , dk = ""
        , en = " to upload"
        }
    , acceptedFileTypes =
        { no = "Godkjente filtyper: "
        , se = "Godkända filtyper: "
        , dk = "Godkendte filtyper: "
        , en = "Accepted file types: "
        }
    , and =
        { no = "og "
        , se = "och "
        , dk = "og "
        , en = "and "
        }
    , dropToUploadFile =
        { no = "Slipp filen for å laste opp"
        , se = "Släpp filen för att ladda upp"
        , dk = "Drop filen for at uploade"
        , en = "Drop the file to upload"
        }
    , uploadedFiles =
        { no = "Opplastede filer:"
        , se = "Uppladdade filer:"
        , dk = "Uploadede filer:"
        , en = "Uploaded files:"
        }
    , ariaNoMoreFiles =
        { no = "Ingen flere filer kan legges til"
        , se = "Inga fler filer kan inte läggas till"
        , dk = "Der kan ikke tilføjes flere filer"
        , en = "No more files can be added"
        }
    , ariaRemove =
        { no = "Fjern"
        , se = "Ta bort"
        , dk = "Fjern"
        , en = "Remove"
        }
    , ariaRemoveFromList =
        { no = "Fjern fra listen: "
        , se = "Ta bort från listan: "
        , dk = "Fjern fra listen: "
        , en = "Remove from list: "
        }
    }
