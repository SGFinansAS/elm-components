module Nordea.Utils.List exposing (isNotEmpty)


isNotEmpty : List a -> Bool
isNotEmpty list =
    not (List.isEmpty list)
