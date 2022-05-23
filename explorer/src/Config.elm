module Config exposing (Config, FinancingVariant(..), Msg(..), TooltipMsg(..), TooltipState, init, initialToolTipState, update)

import File exposing (File)
import Html.Styled as Html
import Nordea.Components.Accordion as Accordion exposing (Accordion)
import Nordea.Components.DropdownFilter exposing (Item)
import Nordea.Components.InfoLabel as InfoLabel exposing (InfoLabel)


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
    , infoLabel : InfoLabel
    , tooltipState : TooltipState
    }


type TooltipMsg
    = Toggle


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
    | InfoLabelMsg InfoLabel.Msg
    | ToolTipMsg TooltipMsg


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
    , infoLabel =
        InfoLabel.init
            |> InfoLabel.withTitle "This is a title of below text"
            |> InfoLabel.withText
                [ "Lorem ipsum dolor sit amet.", "Consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?" ]
    , tooltipState = initialToolTipState
    }


update : Msg -> Config -> Config
update msg config =
    case msg of
        AccordionMsg m ->
            { config | accordion = Accordion.update m config.accordion }

        InfoLabelMsg m ->
            { config | infoLabel = InfoLabel.update m config.infoLabel }

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

        ToolTipMsg tooltipMsg ->
            { config | tooltipState = tooltipUpdate tooltipMsg config.tooltipState }


type alias TooltipState =
    { cardIsOpen : Bool }


initialToolTipState : TooltipState
initialToolTipState =
    { cardIsOpen = False }


tooltipUpdate : TooltipMsg -> TooltipState -> TooltipState
tooltipUpdate msg state =
    case msg of
        Toggle ->
            { state | cardIsOpen = not state.cardIsOpen }
