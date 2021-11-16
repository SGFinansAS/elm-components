module Stories.Table exposing (stories)

import Config exposing (Config, Msg(..))
import Html.Styled.Attributes exposing (disabled)
import Html.Styled exposing (text, Html)
import Nordea.Components.Table as Table
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)
import Html as HtmlUnstyled
import Css exposing (textAlign, left, right)

type alias RowModel = 
    { id: Int
    , name: String
    , details: String
    }

toHtml : RowModel -> List (Html msg)
toHtml row =
  [ text (String.fromInt row.id), text row.name, text row.details ]

orderRowModel : RowModel -> RowModel -> Order
orderRowModel a b =
  compare a.name b.name


stories : UI a b {}
stories =
    styledStoriesOf
        "Table"
        [ ( "Default"
          , \_ ->
                Table.init 
                    [ Table.Column "ID" Nothing [textAlign Css.center, Css.flex (Css.num 2) ]
                    , Table.Column "Navn" (Just orderRowModel) []
                    , Table.Column "Detaljer" Nothing [] ] toHtml
                      |> Table.withRows 
                        [ RowModel 1 "trym" "veldig kul"
                        , RowModel 2 "Fredrik" "også veldig kul" 
                        , RowModel 3 "Nye Fredrik" "også veldig kul" 
                        ]
                      |> Table.view []
          , {}
          )
        ]
