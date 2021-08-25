module Nordea.Html exposing (nothing, viewIf, viewIfNotEmpty, viewMaybe)

import Html.Styled as Html exposing (Html)


nothing : Html msg
nothing =
    Html.text ""


viewMaybe : Maybe a -> (a -> Html msg) -> Html msg
viewMaybe maybe view =
    case maybe of
        Just value ->
            view value

        Nothing ->
            nothing


viewIf : Bool -> Html msg -> Html msg
viewIf condition element =
    if condition then
        element

    else
        nothing


viewIfNotEmpty : List a -> (List a -> Html msg) -> Html msg
viewIfNotEmpty list view =
    if not (List.isEmpty list) then
        view list

    else
        nothing
