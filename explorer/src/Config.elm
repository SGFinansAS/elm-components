module Config exposing (Config, FinancingVariant(..), Msg(..), init, update)

import File exposing (File)
import Html.Styled as Html
import Nordea.Components.Accordion as Accordion exposing (Accordion)
import Nordea.Components.DropdownFilter exposing (Item)


type FinancingVariant
    = Leasing
    | Rent
    | Loan
    | HirePurchase


type alias Config =
    { accordion : Accordion
    , isModalOpen : Bool
    , searchComponentInput : Maybe String
    , searchHasFocus : Bool
    , isFeatureBoxOpen : Bool
    , isProgressBarCompleted : Bool
    , isHoveringFileUpload : Bool
    , selectedFiles : List File
    }


type Msg
    = AccordionMsg Accordion.Msg
    | SearchComponentInput String
    | SearchComponentSelected (Item FinancingVariant)
    | SearchComponentFocus Bool
    | OnClickClearSearchComponentInput
    | NoOp
    | ToggleModal
    | ToggleFeatureBox
    | ToggleProgressBarCompleted
    | OnDragEnterFileUpload
    | OnDragLeaveFileUpload
    | OnFilesSelected File (List File)
    | RemoveFile File


init : Config
init =
    { accordion =
        Accordion.init
            |> Accordion.withTitle "FAQ"
            |> Accordion.withItem
                { title = "Hello"
                , body = [ Html.text "World" ]
                , open = False
                }
            |> Accordion.withItem
                { title = "This is a question"
                , body = [ Html.text "This is an answer" ]
                , open = False
                }
    , searchComponentInput = Nothing
    , searchHasFocus = False
    , isModalOpen = True
    , isFeatureBoxOpen = True
    , isProgressBarCompleted = False
    , isHoveringFileUpload = False
    , selectedFiles = []
    }


update : Msg -> Config -> Config
update msg config =
    case msg of
        AccordionMsg m ->
            { config | accordion = Accordion.update m config.accordion }

        SearchComponentInput input ->
            { config | searchComponentInput = Just input }

        SearchComponentSelected item ->
            { config
                | searchComponentInput = Just item.text
                , searchHasFocus = False
            }

        SearchComponentFocus value ->
            { config | searchHasFocus = value }

        OnClickClearSearchComponentInput ->
            let
                emptySearchString =
                    config.searchComponentInput |> Maybe.map (\_ -> "")
            in
            { config | searchComponentInput = emptySearchString }

        NoOp ->
            config

        ToggleModal ->
            { config | isModalOpen = not config.isModalOpen }

        ToggleFeatureBox ->
            { config | isFeatureBoxOpen = not config.isFeatureBoxOpen }

        ToggleProgressBarCompleted ->
            { config | isProgressBarCompleted = not config.isProgressBarCompleted }

        OnDragEnterFileUpload ->
            { config | isHoveringFileUpload = True }

        OnDragLeaveFileUpload ->
            { config | isHoveringFileUpload = False }

        OnFilesSelected first rest ->
            { config | selectedFiles = (first :: rest) ++ config.selectedFiles, isHoveringFileUpload = False }

        RemoveFile file ->
            { config | selectedFiles = config.selectedFiles |> List.filter ((/=) file) }
