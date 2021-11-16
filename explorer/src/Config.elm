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
    , searchComponentInput : Maybe String
    , searchHasFocus : Bool
    }


type Msg
    = AccordionMsg Accordion.Msg
    | SearchComponentInput String
    | SearchComponentSelected (Item FinancingVariant)
    | SearchComponentFocus Bool
    | NoOp


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

        NoOp ->
            config
