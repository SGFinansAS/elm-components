module Stories.Pagination exposing (stories)

import Config exposing (Config, Msg(..))
import Nordea.Components.Pagination as Pagination
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
                    , showFirstPageAlways = True
                    , showLastPageAlways = True
                    , showPrevButton = False
                    , showNextButton = False
                    , hideNextButtonIfLastPage = Nothing
                    , hidePrevButtonIfFirstPage = Nothing
                    , pageOnClickMsg = PaginationClickedAt
                    }
                    |> Pagination.view []
          , {}
          )
        , ( "Standard use case with odd window and without first and last"
          , \model ->
                Pagination.init
                    { totalPages = 50
                    , currentPage = model.customModel.paginationCurrentPage
                    , windowSize = 5
                    , showFirstPageAlways = False
                    , showLastPageAlways = False
                    , showPrevButton = False
                    , showNextButton = False
                    , hideNextButtonIfLastPage = Nothing
                    , hidePrevButtonIfFirstPage = Nothing
                    , pageOnClickMsg = PaginationClickedAt
                    }
                    |> Pagination.view []
          , {}
          )
        , ( "Standard use case with even window"
          , \model ->
                Pagination.init
                    { totalPages = 50
                    , currentPage = model.customModel.paginationCurrentPage
                    , windowSize = 4
                    , showFirstPageAlways = True
                    , showLastPageAlways = True
                    , showPrevButton = False
                    , showNextButton = False
                    , hideNextButtonIfLastPage = Nothing
                    , hidePrevButtonIfFirstPage = Nothing
                    , pageOnClickMsg = PaginationClickedAt
                    }
                    |> Pagination.view []
          , {}
          )
        , ( "Standard use case with even window and without first and last"
          , \model ->
                Pagination.init
                    { totalPages = 50
                    , currentPage = model.customModel.paginationCurrentPage
                    , windowSize = 4
                    , showFirstPageAlways = False
                    , showLastPageAlways = False
                    , showPrevButton = False
                    , showNextButton = False
                    , hideNextButtonIfLastPage = Nothing
                    , hidePrevButtonIfFirstPage = Nothing
                    , pageOnClickMsg = PaginationClickedAt
                    }
                    |> Pagination.view []
          , {}
          )
        , ( "Edge case: window size 2"
          , \model ->
                Pagination.init
                    { totalPages = 50
                    , currentPage = model.customModel.paginationCurrentPage
                    , windowSize = 2
                    , showFirstPageAlways = True
                    , showLastPageAlways = True
                    , showPrevButton = False
                    , showNextButton = False
                    , hideNextButtonIfLastPage = Nothing
                    , hidePrevButtonIfFirstPage = Nothing
                    , pageOnClickMsg = PaginationClickedAt
                    }
                    |> Pagination.view []
          , {}
          )
        , ( "Edge case: window size 1, show first and last always"
          , \model ->
                Pagination.init
                    { totalPages = 10
                    , currentPage = model.customModel.paginationCurrentPage
                    , windowSize = 1
                    , showFirstPageAlways = True
                    , showLastPageAlways = True
                    , showPrevButton = False
                    , showNextButton = False
                    , hideNextButtonIfLastPage = Nothing
                    , hidePrevButtonIfFirstPage = Nothing
                    , pageOnClickMsg = PaginationClickedAt
                    }
                    |> Pagination.view []
          , {}
          )
        , ( "Edge case: window size 1, do not show first and last (useless)"
          , \model ->
                Pagination.init
                    { totalPages = 10
                    , currentPage = model.customModel.paginationCurrentPage
                    , windowSize = 1
                    , showFirstPageAlways = False
                    , showLastPageAlways = False
                    , showPrevButton = False
                    , showNextButton = False
                    , hideNextButtonIfLastPage = Nothing
                    , hidePrevButtonIfFirstPage = Nothing
                    , pageOnClickMsg = PaginationClickedAt
                    }
                    |> Pagination.view []
          , {}
          )
        , ( "Edge case: window size 1, show next and prev (more useful)"
          , \model ->
                Pagination.init
                    { totalPages = 10
                    , currentPage = model.customModel.paginationCurrentPage
                    , windowSize = 1
                    , showFirstPageAlways = False
                    , showLastPageAlways = False
                    , showPrevButton = True
                    , showNextButton = True
                    , hideNextButtonIfLastPage = Nothing
                    , hidePrevButtonIfFirstPage = Nothing
                    , pageOnClickMsg = PaginationClickedAt
                    }
                    |> Pagination.view []
          , {}
          )
        ]
