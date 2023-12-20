module Stories.SortableTable exposing (stories)

import Css exposing (..)
import Html.Styled exposing (Html)
import Html.Styled.Attributes exposing (css)
import Nordea.Components.SortableTable as Table
import Nordea.Resources.Colors
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


type Column
    = Id
    | Amount
    | CurrencyCode


type alias Invoice =
    { id : String
    , amount : Float
    , currentcy : String
    }


invoices : List Invoice
invoices =
    [ { id = "1", amount = 34.5, currentcy = "NOK" }
    , { id = "2", amount = 0, currentcy = "NOK" }
    ]


columnName : Column -> String
columnName c =
    case c of
        Id ->
            "Id"

        Amount ->
            "Amount"

        CurrencyCode ->
            "Currency"


columnWidthBounds : Column -> List Css.Style
columnWidthBounds c =
    case c of
        Id ->
            [ minWidth (rem 4), maxWidth (rem 4) ]

        Amount ->
            [ minWidth (rem 4), maxWidth (rem 4) ]

        CurrencyCode ->
            [ minWidth (rem 4), maxWidth (rem 4) ]


basicTable : Html msg
basicTable =
    let
        headerRow =
            [ Id, Amount, CurrencyCode ] |> List.map (\c -> Table.textHeader { css = columnWidthBounds c, label = c |> columnName }) |> Table.headerRow []

        invoiceToRow : Invoice -> Html msg
        invoiceToRow i =
            Table.dataRow []
                [ Table.textElement { css = columnWidthBounds Id, label = i.id }
                , Table.textElement { css = columnWidthBounds Amount, label = String.fromFloat i.amount }
                , Table.textElement { css = columnWidthBounds CurrencyCode, label = i.currentcy }
                ]

        tableRows =
            invoices |> List.map invoiceToRow
    in
    Table.view [ css [ backgroundColor Nordea.Resources.Colors.lightGray, width (rem 16) ] ]
        [ Table.thead [] [ headerRow ]
        , Table.tbody [] tableRows
        ]


stories : UI a b {}
stories =
    styledStoriesOf
        "SortableTable"
        [ ( "Basic"
          , \_ ->
                basicTable
          , {}
          )
        ]
