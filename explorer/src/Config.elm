module Config exposing (Config, FinancingVariant(..), Msg(..), OrganizationInfo, init, update)

import Date
import File exposing (File)
import Html.Styled as Html
import List.Extra as List
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
    , selectedOptions : List String
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
    , selectedOptions = []
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
    }


update : Msg -> Config -> Config
update msg config =
    case msg of
        AccordionMsg m ->
            { config | accordion = Accordion.update m config.accordion }

        AccordionTableRowToggled index isOpen ->
            let
                operation =
                    if isOpen then
                        Set.insert

                    else
                        Set.remove
            in
            { config | openAccordionTableRows = operation index config.openAccordionTableRows }

        AccordionTableAllRowsChecked areChecked ->
            { config
                | selectedAccordionTableRows =
                    if areChecked then
                        Set.fromList [ 0, 1 ]

                    else
                        Set.empty
            }

        AccordionTableRowChecked index isChecked ->
            let
                operation =
                    if isChecked then
                        Set.insert

                    else
                        Set.remove
            in
            { config | selectedAccordionTableRows = operation index config.selectedAccordionTableRows }

        SearchComponentInput input ->
            { config | searchComponentInput = input }

        FocusMultiSelectDropdown value ->
            { config | hasMultiSelectDropdownFocus = value }

        OnCheckChoice1 ->
            { config | isChoice1 = not config.isChoice1, selectedOptions = addLabelIfNotExists "Valg 1" config.selectedOptions }

        OnCheckChoice2 ->
            { config | isChoice2 = not config.isChoice2, selectedOptions = addLabelIfNotExists "Valg 2 asdfasdf" config.selectedOptions }

        OnCheckChoice3 ->
            { config | isChoice3 = not config.isChoice3, selectedOptions = addLabelIfNotExists "Valg 3 asdfasdfasdf" config.selectedOptions }

        OnCheckChoice4 ->
            { config | isChoice4 = not config.isChoice4, selectedOptions = addLabelIfNotExists "Valg 4-lengere tekst" config.selectedOptions }

        SearchComponentSelected item ->
            { config
                | searchComponentInput = item |> Maybe.map .text |> Maybe.withDefault ""
                , selectedSearchComponent = item
                , searchHasFocus = False
            }

        SearchComponentSelectedOrgInfo item ->
            { config
                | searchComponentInput = item |> Maybe.map .text |> Maybe.withDefault ""
                , selectedSearchComponentOrgInfo = item |> Maybe.map .value
                , searchHasFocus = False
            }

        SearchComponentFocus value ->
            { config | searchHasFocus = value }

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

        OnFilesSelected files ->
            { config | selectedFiles = files ++ config.selectedFiles, isHoveringFileUpload = False }

        RemoveFile file ->
            { config | selectedFiles = config.selectedFiles |> List.filter ((/=) file) }

        SliderMsg value ->
            { config | sliderInputValue = value }

        RangeMsg value ->
            { config | rangeInputValue = value }

        ToggleToggle ->
            { config | isToggled = not config.isToggled }

        ToggleHamburger ->
            { config | hamburgerIsActive = not config.hamburgerIsActive }

        UpdateCoachmarkStep p ->
            { config | showCoachMarkStep = p }

        UpdateActiveRadioButton s ->
            { config | activeRadioButton = s }

        TextInputContentChange string ->
            { config | textInputContent = string }

        LabelInputContentChange string ->
            { config | labelInputContent = string }

        OnClickCollapsible ->
            config

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

        SnackbarMsg ->
            config

        PaginationClickedAt i ->
            { config | paginationCurrentPage = i }

        DateSelected result datePickerState ->
            { config
                | currentDatePickerValue = Just result
                , datePicker = DatePicker.updateInternalState datePickerState config.datePicker
            }

        UpdateDatePickerInternalState datePickerState ->
            { config | datePicker = DatePicker.updateInternalState datePickerState config.datePicker }

        SetRating value ->
            { config | fiveStarRating = value }

        ToggleOpenCard ->
            { config | isCardOpen = not config.isCardOpen }


addLabelIfNotExists label selectedOptions =
    if List.member label selectedOptions then
        List.remove label selectedOptions

    else
        selectedOptions ++ [ label ]
