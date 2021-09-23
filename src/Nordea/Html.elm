module Nordea.Html exposing (nothing, showIf, styleIf, viewIfNotEmpty, viewMaybe)

import Css exposing (Style)
import Html.Styled as Html exposing (Html)


nothing : Html msg
nothing =
    Html.text ""


viewMaybe : (a -> Html msg) -> Maybe a -> Html msg
viewMaybe view maybe =
    case maybe of
        Just value ->
            view value

        Nothing ->
            nothing


showIf : Bool -> Html msg -> Html msg
showIf condition element =
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


styleIf : Bool -> Style -> Style
styleIf condition style =
    if condition then
        style

    else
        Css.property "" ""
