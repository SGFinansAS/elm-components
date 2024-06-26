module Nordea.Components.FileUpload exposing
    ( AcceptFileType(..)
    , Appearance(..)
    , FileUpload
    , MimeType(..)
    , init
    , supportedFileTypesText
    , uploadedFilesView
    , view
    , withAcceptedFileTypes
    , withAllowMultipleFiles
    , withAppearance
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
        , center
        , color
        , column
        , cursor
        , dashed
        , displayFlex
        , flex
        , flexDirection
        , height
        , hover
        , justifyContent
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
        , pointer
        , position
        , pseudoClass
        , rem
        , row
        , width
        )
import File exposing (File)
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes exposing (accept, css, multiple, type_, value)
import Html.Styled.Events as Events
import Json.Decode as Decode
import Nordea.Components.Text as Text
import Nordea.Html as Html exposing (showIf, styleIf)
import Nordea.Resources.Colors as Colors
import Nordea.Resources.I18N exposing (Translation)
import Nordea.Resources.Icons as Icon
import Nordea.Themes as Themes
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


type alias Config msg =
    { isHovering : Bool
    , onDragEnter : msg
    , onDragLeave : msg
    , files : List File
    , translate : Translate
    , allowMultiple : Bool
    , onFilesSelected : File -> List File -> msg
    , accept : AcceptFileType
    , appearance : Appearance
    }


init : Translate -> (File -> List File -> msg) -> msg -> msg -> FileUpload msg
init translate onFilesSelected onDragEnter onDragLeave =
    FileUpload
        { isHovering = False
        , onDragEnter = onDragEnter
        , onDragLeave = onDragLeave
        , files = []
        , translate = translate
        , allowMultiple = False
        , onFilesSelected = onFilesSelected
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
            [ onFilesDropped
                config.accept
                (\first rest ->
                    config.onFilesSelected
                        first
                        (if config.allowMultiple then
                            rest

                         else
                            []
                        )
                )
            , preventDefaultOn "dragover" config.onDragEnter
            , preventDefaultOn "dragleave" config.onDragLeave
            , css
                [ displayFlex
                , styleAppearance
                , alignItems center
                , borderRadius (rem 0.25)
                , cursor pointer
                , pseudoClass "focus-within" [ border3 (rem 0.0625) dashed Colors.deepBlue ]
                , styleOnHover
                ]
            ]

        iconUpload =
            Icon.upload
                [ css
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
                |> Text.view [ css [ color Colors.darkGray ] ]
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
                            |> Text.view [ css [ color Colors.darkGray, marginTop (rem 0.5) ] ]
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
    in
    Html.div attrs
        [ iconUpload |> showIf (not config.isHovering)
        , description |> showIf (not config.isHovering)
        , viewSupportedFileTypesText
            |> showIf (not config.isHovering && config.appearance == Large)
        , textType
            |> Text.view [ css [ Themes.color Colors.nordeaBlue ] ]
                [ Html.text (config.translate strings.dropToUploadFile) ]
            |> showIf config.isHovering
        , Html.input
            [ type_ "file"
            , onSelectFiles config.onFilesSelected
            , multiple config.allowMultiple
            , accept mimeTypesAsString
            , value ""
            , css [ opacity (num 0), position absolute, height (rem 0), width (rem 0) ]
            ]
            []
        ]


uploadedFilesView : List File -> (File -> msg) -> Translate -> List (Attribute msg) -> Html msg
uploadedFilesView files onClickRemove translate attrs =
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
    in
    Html.section attrs
        [ Text.textSmallLight
            |> Text.withHtmlTag Html.h1
            |> Text.view [ css [ marginBottom (rem 0.25) ] ] [ Html.text (translate strings.uploadedFiles) ]
        , Html.ul [ css [ listStyleType none, padding (rem 0) ] ]
            (files
                |> List.map
                    (\file ->
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
                            [ Icon.pdf [ css [ color Colors.black, marginRight (rem 1) ] ]
                            , Html.div [ css [ displayFlex, flexDirection column, flex (num 1), marginRight (rem 1) ] ]
                                [ Text.bodyTextSmall
                                    |> Text.view [] [ Html.text (File.name file) ]
                                , Text.textTinyLight
                                    |> Text.view [] [ file |> File.size |> fileSizeToString |> Html.text ]
                                ]
                            , Html.button
                                [ preventDefaultOn "click" (onClickRemove file)
                                , css
                                    [ borderStyle none
                                    , Css.property "appearance" "none"
                                    , cursor pointer
                                    , padding2 (rem 0.75) (rem 1.25)
                                    , margin2 (rem -0.75) (rem -1.25)
                                    , backgroundColor Colors.transparent
                                    ]
                                ]
                                [ Icon.trash [ css [ Themes.color Colors.deepBlue ] ] ]
                            ]
                    )
            )
        ]


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


onFilesDropped : AcceptFileType -> (File -> List File -> msg) -> Attribute msg
onFilesDropped acceptFileType msg =
    let
        filesDroppedDecoder =
            Decode.at [ "dataTransfer", "files" ] (Decode.list File.decoder)
                |> Decode.map
                    (\files ->
                        case acceptFileType of
                            Any ->
                                files

                            Only mimeTypes ->
                                files |> List.filter (\file -> List.member (File.mime file) (List.map toMimeTypeString mimeTypes))
                    )
                |> Decode.andThen
                    (\files ->
                        case files of
                            head :: tail ->
                                Decode.succeed ( msg head tail, True )

                            _ ->
                                Decode.fail "No files selected"
                    )
    in
    Events.preventDefaultOn "drop" filesDroppedDecoder


preventDefaultOn : String -> msg -> Attribute msg
preventDefaultOn event msg =
    Events.preventDefaultOn event (Decode.succeed ( msg, True ))


onSelectFiles : (File -> List File -> msg) -> Attribute msg
onSelectFiles msg =
    let
        filesDecoder =
            Decode.at [ "target", "files" ] (Decode.list File.decoder)
                |> Decode.andThen
                    (\files ->
                        case files of
                            head :: tail ->
                                Decode.succeed (msg head tail)

                            _ ->
                                Decode.fail "No files selected"
                    )
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
    }
