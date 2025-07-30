module Config exposing (Config, FinancingVariant(..), Msg(..), OrganizationInfo, init, update)

import Date
import File exposing (File)
import Html.Styled as Html
import Nordea.Components.Accordion as Accordion exposing (Accordion)
import Nordea.Components.DatePicker as DatePicker exposing (DatePicker)
import Nordea.Components.DropdownFilter exposing (Item)
import Set exposing (Set)
import Stories.SortableTableSharedTypes
import Time exposing (Month(..))


type FinancingVariant
    = Leasing
    | Rent
    | Loan
    | HirePurchase


type alias OrganizationInfo =
    { name : String
    , organizationNumber : String
    , enterpriseTypeId : Maybe String
    , postalCode : Maybe String
    , postalPlace : Maybe String
    }


type alias Config =
    { accordion : Accordion
    , openAccordionTableRows : Set Int
    , selectedAccordionTableRows : Set Int
    , isModalOpen : Bool
    , searchComponentInput : String
    , hasMultiSelectDropdownFocus : Bool
    , isChoice1 : Bool
    , isChoice2 : Bool
    , isChoice3 : Bool
    , isChoice4 : Bool
    , selectedItems : List String
    , searchHasFocus : Bool
    , isFeatureBoxOpen : Bool
    , isProgressBarCompleted : Bool
    , isHoveringFileUpload : Bool
    , selectedFiles : List File
    , sliderInputValue : String
    , rangeInputValue : Float
    , isToggled : Bool
    , hamburgerIsActive : Bool
    , showCoachMarkStep : Maybe Int
    , activeRadioButton : String
    , textInputContent : String
    , labelInputContent : String
    , sortableTable : Stories.SortableTableSharedTypes.Model
    , selectedSearchComponent : Maybe (Item FinancingVariant)
    , selectedSearchComponentOrgInfo : Maybe OrganizationInfo
    , paginationCurrentPage : Int
    , datePicker : DatePicker Msg
    , currentDatePickerValue : Maybe DatePicker.DateResult
    , fiveStarRating : Int
    , isCardOpen : Bool
    }


type Msg
    = AccordionMsg Accordion.Msg
    | AccordionTableRowToggled Int Bool
    | AccordionTableAllRowsChecked Bool
    | AccordionTableRowChecked Int Bool
    | SearchComponentInput String
    | SearchComponentInputWithCmd String (Cmd Msg)
    | SearchComponentSelected (Maybe (Item FinancingVariant))
    | SearchComponentSelectedOrgInfo (Maybe (Item OrganizationInfo))
    | SearchComponentFocus Bool
    | NoOp
    | FocusMultiSelectDropdown Bool
    | OnCheckChoice1
    | OnCheckChoice2
    | OnCheckChoice3
    | OnCheckChoice4
    | ToggleModal
    | ToggleFeatureBox
    | ToggleProgressBarCompleted
    | OnDragEnterFileUpload
    | OnDragLeaveFileUpload
    | OnFilesSelected (List File)
    | RemoveFile File
    | SliderMsg String
    | RangeMsg Float
    | ToggleToggle
    | ToggleHamburger
    | UpdateCoachmarkStep (Maybe Int)
    | UpdateActiveRadioButton String
    | TextInputContentChange String
    | LabelInputContentChange String
    | OnClickCollapsible
    | SortableTableMsg Stories.SortableTableSharedTypes.Msg
    | SnackbarMsg
    | PaginationClickedAt Int
    | DateSelected DatePicker.DateResult DatePicker.InternalState
    | UpdateDatePickerInternalState DatePicker.InternalState
    | ToggleOpenCard
    | SetRating Int


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
    , openAccordionTableRows = Set.empty
    , selectedAccordionTableRows = Set.empty
    , searchComponentInput = ""
    , selectedSearchComponent = Nothing
    , selectedSearchComponentOrgInfo = Nothing
    , hasMultiSelectDropdownFocus = False
    , isChoice1 = False
    , isChoice2 = False
    , isChoice3 = False
    , isChoice4 = False
    , searchHasFocus = False
    , isModalOpen = True
    , isFeatureBoxOpen = True
    , isProgressBarCompleted = False
    , isHoveringFileUpload = False
    , selectedFiles = []
    , isToggled = False
    , sliderInputValue = "5"
    , rangeInputValue = 5
    , hamburgerIsActive = False
    , showCoachMarkStep = Nothing
    , activeRadioButton = "second"
    , textInputContent = "Initialized"
    , labelInputContent = "Text"
    , sortableTable = Stories.SortableTableSharedTypes.initModel
    , paginationCurrentPage = 1
    , datePicker = DatePicker.init (Date.fromCalendarDate 2024 May 1) "" DateSelected UpdateDatePickerInternalState
    , currentDatePickerValue = Nothing
    , isCardOpen = True
    , fiveStarRating = 0
    , selectedItems = []
    }


addCmdNone m =
    ( m, Cmd.none )


update : Msg -> Config -> ( Config, Cmd Msg )
update msg config =
    case msg of
        AccordionMsg m ->
            { config | accordion = Accordion.update m config.accordion }
                |> addCmdNone

        AccordionTableRowToggled index isOpen ->
            let
                operation =
                    if isOpen then
                        Set.insert

                    else
                        Set.remove
            in
            { config | openAccordionTableRows = operation index config.openAccordionTableRows }
                |> addCmdNone

        AccordionTableAllRowsChecked areChecked ->
            { config
                | selectedAccordionTableRows =
                    if areChecked then
                        Set.fromList [ 0, 1 ]

                    else
                        Set.empty
            }
                |> addCmdNone

        AccordionTableRowChecked index isChecked ->
            let
                operation =
                    if isChecked then
                        Set.insert

                    else
                        Set.remove
            in
            { config | selectedAccordionTableRows = operation index config.selectedAccordionTableRows }
                |> addCmdNone

        SearchComponentInput input ->
            { config | searchComponentInput = input }
                |> addCmdNone

        SearchComponentInputWithCmd input cmd ->
            ( { config | searchComponentInput = input }, cmd )

        FocusMultiSelectDropdown value ->
            { config | hasMultiSelectDropdownFocus = value }
                |> addCmdNone

        OnCheckChoice1 ->
            { config | isChoice1 = not config.isChoice1, selectedItems = "Valg 1" :: config.selectedItems }
                |> addCmdNone

        OnCheckChoice2 ->
            { config | isChoice2 = not config.isChoice2, selectedItems = "Valg 2" :: config.selectedItems }
                |> addCmdNone

        OnCheckChoice3 ->
            { config | isChoice3 = not config.isChoice3, selectedItems = "Valg 3" :: config.selectedItems }
                |> addCmdNone

        OnCheckChoice4 ->
            { config | isChoice4 = not config.isChoice4, selectedItems = "Valg 4 - Ekstra tekst heihei 12345" :: config.selectedItems }
                |> addCmdNone

        SearchComponentSelected item ->
            { config
                | searchComponentInput = item |> Maybe.map .text |> Maybe.withDefault ""
                , selectedSearchComponent = item
                , searchHasFocus = False
            }
                |> addCmdNone

        SearchComponentSelectedOrgInfo item ->
            { config
                | searchComponentInput = item |> Maybe.map .text |> Maybe.withDefault ""
                , selectedSearchComponentOrgInfo = item |> Maybe.map .value
                , searchHasFocus = False
            }
                |> addCmdNone

        SearchComponentFocus value ->
            { config | searchHasFocus = value }
                |> addCmdNone

        NoOp ->
            config
                |> addCmdNone

        ToggleModal ->
            { config | isModalOpen = not config.isModalOpen }
                |> addCmdNone

        ToggleFeatureBox ->
            { config | isFeatureBoxOpen = not config.isFeatureBoxOpen }
                |> addCmdNone

        ToggleProgressBarCompleted ->
            { config | isProgressBarCompleted = not config.isProgressBarCompleted }
                |> addCmdNone

        OnDragEnterFileUpload ->
            { config | isHoveringFileUpload = True }
                |> addCmdNone

        OnDragLeaveFileUpload ->
            { config | isHoveringFileUpload = False }
                |> addCmdNone

        OnFilesSelected files ->
            { config | selectedFiles = files ++ config.selectedFiles, isHoveringFileUpload = False }
                |> addCmdNone

        RemoveFile file ->
            { config | selectedFiles = config.selectedFiles |> List.filter ((/=) file) }
                |> addCmdNone

        SliderMsg value ->
            { config | sliderInputValue = value }
                |> addCmdNone

        RangeMsg value ->
            { config | rangeInputValue = value }
                |> addCmdNone

        ToggleToggle ->
            { config | isToggled = not config.isToggled }
                |> addCmdNone

        ToggleHamburger ->
            { config | hamburgerIsActive = not config.hamburgerIsActive }
                |> addCmdNone

        UpdateCoachmarkStep p ->
            { config | showCoachMarkStep = p }
                |> addCmdNone

        UpdateActiveRadioButton s ->
            { config | activeRadioButton = s }
                |> addCmdNone

        TextInputContentChange string ->
            { config | textInputContent = string }
                |> addCmdNone

        LabelInputContentChange string ->
            { config | labelInputContent = string }
                |> addCmdNone

        OnClickCollapsible ->
            config
                |> addCmdNone

        SortableTableMsg tableMsg ->
            case tableMsg of
                Stories.SortableTableSharedTypes.HeaderClick column maybeOrder ->
                    let
                        updatedModel =
                            case maybeOrder of
                                Just Stories.SortableTableSharedTypes.Asc ->
                                    Stories.SortableTableSharedTypes.initModel

                                Just Stories.SortableTableSharedTypes.Desc ->
                                    { column = column, order = Stories.SortableTableSharedTypes.Asc }

                                Nothing ->
                                    { column = column, order = Stories.SortableTableSharedTypes.Desc }
                    in
                    { config | sortableTable = updatedModel }
                        |> addCmdNone

        SnackbarMsg ->
            config
                |> addCmdNone

        PaginationClickedAt i ->
            { config | paginationCurrentPage = i }
                |> addCmdNone

        DateSelected result datePickerState ->
            { config
                | currentDatePickerValue = Just result
                , datePicker = DatePicker.updateInternalState datePickerState config.datePicker
            }
                |> addCmdNone

        UpdateDatePickerInternalState datePickerState ->
            { config | datePicker = DatePicker.updateInternalState datePickerState config.datePicker }
                |> addCmdNone

        SetRating value ->
            { config | fiveStarRating = value }
                |> addCmdNone

        ToggleOpenCard ->
            { config | isCardOpen = not config.isCardOpen }
                |> addCmdNone
