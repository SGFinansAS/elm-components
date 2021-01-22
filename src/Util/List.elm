module Util.List exposing (filterMaybe)


filterMaybe : List (Maybe a) -> List a
filterMaybe list =
    List.filterMap identity list
