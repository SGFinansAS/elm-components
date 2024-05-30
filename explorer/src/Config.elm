module Config exposing (Config, FinancingVariant(..), Msg(..), init, update)

import Date exposing (Date)
import File exposing (File)
import Html.Styled as Html
import Nordea.Components.Accordion as Accordion exposing (Accordion)
import Nordea.Components.DatePicker as DatePicker exposing (DatePicker)
import Nordea.Components.DropdownFilter exposing (Item)
import Stories.SortableTableSharedTypes
import Time exposing (Month(..))


type FinancingVariant
    = Leasing
    | Rent
    | Loan
    | HirePurchase


type alias Config =
    { accordion : Accordion
    , isModalOpen : Bool
    , searchComponentInput : String
    , hasMultiSelectDropdownFocus : Bool
    , isChoice1 : Bool
    , isChoice2 : Bool
    , isChoice3 : Bool
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
    , sortableTable : Stories.SortableTableSharedTypes.Model
    , selectedSearchComponent : Maybe FinancingVariant
    , paginationCurrentPage : Int
    , datePicker : DatePicker Msg
    , currentDatePickerValue : Maybe Date
    }


type Msg
    = AccordionMsg Accordion.Msg
    | SearchComponentInput String
    | SearchComponentSelected (Maybe (Item FinancingVariant))
    | SearchComponentFocus Bool
    | NoOp
    | FocusMultiSelectDropdown Bool
    | OnCheckChoice1
    | OnCheckChoice2
    | OnCheckChoice3
    | ToggleModal
    | ToggleFeatureBox
    | ToggleProgressBarCompleted
    | OnDragEnterFileUpload
    | OnDragLeaveFileUpload
    | OnFilesSelected File (List File)
    | RemoveFile File
    | SliderMsg String
    | RangeMsg Float
    | ToggleToggle
    | ToggleHamburger
    | UpdateCoachmarkStep (Maybe Int)
    | UpdateActiveRadioButton String
    | TextInputContentChange String
    | OnClickCollapsible
    | SortableTableMsg Stories.SortableTableSharedTypes.Msg
    | SnackbarMsg
    | PaginationClickedAt Int
    | DateSelected Date DatePicker.InternalState
    | UpdateDatePickerInternalState DatePicker.InternalState


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
    , searchComponentInput = ""
    , selectedSearchComponent = Nothing
    , hasMultiSelectDropdownFocus = False
    , isChoice1 = False
    , isChoice2 = False
    , isChoice3 = False
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
    , sortableTable = Stories.SortableTableSharedTypes.initModel
    , paginationCurrentPage = 1
    , datePicker = DatePicker.init (Date.fromCalendarDate 2024 May 1) DateSelected UpdateDatePickerInternalState
    , currentDatePickerValue = Nothing
    }


update : Msg -> Config -> Config
update msg config =
    case msg of
        AccordionMsg m ->
            { config | accordion = Accordion.update m config.accordion }

        SearchComponentInput input ->
            { config | searchComponentInput = input }

        FocusMultiSelectDropdown value ->
            { config | hasMultiSelectDropdownFocus = value }

        OnCheckChoice1 ->
            { config | isChoice1 = not config.isChoice1 }

        OnCheckChoice2 ->
            { config | isChoice2 = not config.isChoice2 }

        OnCheckChoice3 ->
            { config | isChoice3 = not config.isChoice3 }

        SearchComponentSelected item ->
            { config
                | searchComponentInput = item |> Maybe.map .text |> Maybe.withDefault ""
                , selectedSearchComponent = item |> Maybe.map .value
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

        OnFilesSelected first rest ->
            { config | selectedFiles = (first :: rest) ++ config.selectedFiles, isHoveringFileUpload = False }

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

        DateSelected date datePickerState ->
            { config
                | currentDatePickerValue = Just date
                , datePicker = DatePicker.updateInternalState datePickerState config.datePicker
            }

        UpdateDatePickerInternalState datePickerState ->
            { config | datePicker = DatePicker.updateInternalState datePickerState config.datePicker }
