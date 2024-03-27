module Stories.Pagination exposing (stories)

import Config exposing (Config, Msg(..))
import Nordea.Components.Pagination as Pagination exposing (OptionalConfig(..))
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI Config Msg {}
stories =
    styledStoriesOf
        "Pagination"
        [ ( "Standard use case with odd window"
          , \model ->
                Pagination.init
                    { totalPages = 50
                    , currentPage = model.customModel.paginationCurrentPage
                    , windowSize = 5
                    , pageOnClickMsg = PaginationClickedAt
                    }
                    |> Pagination.view [] []
          , {}
          )
        , ( "Standard use case with odd window and with next and prev"
          , \model ->
                Pagination.init
                    { totalPages = 50
                    , currentPage = model.customModel.paginationCurrentPage
                    , windowSize = 5
                    , pageOnClickMsg = PaginationClickedAt
                    }
                    |> Pagination.view [ NextButton "Next", PrevButton "Prev" ] []
          , {}
          )
        , ( "Standard use case with even window"
          , \model ->
                Pagination.init
                    { totalPages = 50
                    , currentPage = model.customModel.paginationCurrentPage
                    , windowSize = 4
                    , pageOnClickMsg = PaginationClickedAt
                    }
                    |> Pagination.view [] []
          , {}
          )
        , ( "Edge case: window size 2"
          , \model ->
                Pagination.init
                    { totalPages = 50
                    , currentPage = model.customModel.paginationCurrentPage
                    , windowSize = 2
                    , pageOnClickMsg = PaginationClickedAt
                    }
                    |> Pagination.view [] []
          , {}
          )
        , ( "Edge case: window size 1"
          , \model ->
                Pagination.init
                    { totalPages = 10
                    , currentPage = model.customModel.paginationCurrentPage
                    , windowSize = 1
                    , pageOnClickMsg = PaginationClickedAt
                    }
                    |> Pagination.view [] []
          , {}
          )
        ]
