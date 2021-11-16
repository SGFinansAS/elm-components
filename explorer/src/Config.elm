module Config exposing (Config, Msg(..), init, update)

import Html.Styled as Html
import Nordea.Components.Accordion as Accordion exposing (Accordion)


type alias Config =
    { accordion : Accordion, isModalOpen : Bool }


type Msg
    = AccordionMsg Accordion.Msg
    | NoOp
    | ToggleModal


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
    , isModalOpen = True
    }


update : Msg -> Config -> Config
update msg config =
    case msg of
        AccordionMsg m ->
            { config | accordion = Accordion.update m config.accordion }

        NoOp ->
            config

        ToggleModal ->
            { config | isModalOpen = not config.isModalOpen }
