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
    , accordionMenuIsOpen : Bool
    }


type Msg
    = AccordionMsg Accordion.Msg
    | SearchComponentInput String
    | SearchComponentSelected (Item FinancingVariant)
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
    | ToggleAccordionMenu


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
    , accordionMenuIsOpen = False
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
                | searchComponentInput = item.text
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

        ToggleAccordionMenu ->
            { config | accordionMenuIsOpen = not config.accordionMenuIsOpen }
