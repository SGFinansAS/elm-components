module Config exposing (Config, FinancingVariant(..), Msg(..), init, update)

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
                emptySearchString = case config.searchComponentInput of
                    Just string ->
                        Just ""

                    Nothing ->
                        Nothing
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
