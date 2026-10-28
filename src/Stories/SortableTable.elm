module Stories.SortableTable exposing (stories)

import Config exposing (Config)
import Css exposing (backgroundColor, maxWidth, minWidth, rem, width)
import Html.Styled exposing (Html)
import Html.Styled.Attributes exposing (css)
import Nordea.Components.SortableTable as Table
import Nordea.Resources.Colors
import Stories.SortableTableSharedTypes exposing (Column(..), Model, Msg(..), Order(..))
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


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
            [ minWidth (rem 6), maxWidth (rem 6) ]

        CurrencyCode ->
            [ minWidth (rem 4), maxWidth (rem 4) ]


basicTable : Html msg
basicTable =
    let
        headerRow =
            [ Table.textHeader { css = columnWidthBounds Id, label = Id |> columnName }
            , Table.numericHeader { css = columnWidthBounds Amount, label = Amount |> columnName }
            , Table.textHeader { css = columnWidthBounds CurrencyCode, label = CurrencyCode |> columnName }
            ]
                |> Table.headerRow []

        invoiceToRow : Invoice -> Html msg
        invoiceToRow i =
            Table.dataRow []
                [ Table.textElement { css = columnWidthBounds Id, label = i.id }
                , Table.numericElement { css = columnWidthBounds Amount, label = String.fromFloat i.amount }
                , Table.textElement { css = columnWidthBounds CurrencyCode, label = i.currentcy }
                ]

        tableRows =
            invoices |> List.map invoiceToRow
    in
    Table.view [ css [ backgroundColor Nordea.Resources.Colors.lightGray, width (rem 18) ] ]
        [ Table.thead [] [ headerRow ]
        , Table.tbody [] tableRows
        ]


sortableTable : Model -> Html Config.Msg
sortableTable model =
    let
        orderToSorting : Order -> Table.Sorting
        orderToSorting order =
            case order of
                Asc ->
                    Table.Asc

                Desc ->
                    Table.Desc

        maybeOrder column =
            if model.column == column then
                model.order |> Just

            else
                Nothing

        idHeader =
            let
                maybeOrderId =
                    maybeOrder Id
            in
            Table.sortableTextHeader
                { css = columnWidthBounds Id
                , sorting = maybeOrderId |> Maybe.map orderToSorting
                , onClick = Config.SortableTableMsg (HeaderClick Id maybeOrderId)
                , label = Id |> columnName
                }

        amountHeader =
            let
                maybeOrderAmount =
                    maybeOrder Amount
            in
            Table.sortableNumericHeader
                { css = columnWidthBounds Amount
                , sorting = maybeOrderAmount |> Maybe.map orderToSorting
                , onClick = Config.SortableTableMsg (HeaderClick Amount maybeOrderAmount)
                , label = Amount |> columnName
                }

        headerRow =
            [ idHeader
            , amountHeader
            , Table.textHeader { css = columnWidthBounds CurrencyCode, label = CurrencyCode |> columnName }
            ]
                |> Table.headerRow []

        invoiceToRow : Invoice -> Html msg
        invoiceToRow i =
            Table.dataRow []
                [ Table.textElement { css = columnWidthBounds Id, label = i.id }
                , Table.numericElement { css = columnWidthBounds Amount, label = String.fromFloat i.amount }
                , Table.textElement { css = columnWidthBounds CurrencyCode, label = i.currentcy }
                ]

        sortedInvoices =
            let
                ascInvoices =
                    case model.column of
                        Id ->
                            List.sortBy .id invoices

                        Amount ->
                            List.sortBy .amount invoices

                        CurrencyCode ->
                            invoices
            in
            case model.order of
                Asc ->
                    ascInvoices

                Desc ->
                    List.reverse ascInvoices

        tableRows =
            sortedInvoices |> List.map invoiceToRow
    in
    Table.view [ css [ backgroundColor Nordea.Resources.Colors.lightGray, width (rem 18) ] ]
        [ Table.thead [] [ headerRow ]
        , Table.tbody [] tableRows
        ]


stories : UI Config Config.Msg {}
stories =
    styledStoriesOf
        "SortableTable"
        [ ( "Basic"
          , \_ ->
                basicTable
          , {}
          )
        , ( "With Sorting"
          , \model ->
                model.customModel.sortableTable |> sortableTable
          , {}
          )
        ]
