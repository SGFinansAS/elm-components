module Stories.SortableTableSharedTypes exposing (Column(..), Model, Msg(..), Order(..), initModel)


type Column
    = Id
    | Amount
    | CurrencyCode


type Order
    = Desc
    | Asc


type Msg
    = HeaderClick Column (Maybe Order)


type alias Model =
    { column : Column
    , order : Order
    }


initModel : Model
initModel =
    { column = Id, order = Desc }
