module Nordea.Html exposing
    ( column
    , hideIf
    , nothing
    , row
    , showIf
    , styleIf
    , viewIfNotEmpty
    , viewMaybe
    )

import Css exposing (Style, displayFlex, flexDirection)
import Html.Styled as Html exposing (Attribute, Html, div, styled)


nothing : Html msg
nothing =
    Html.text ""


column : List (Attribute msg) -> List (Html msg) -> Html msg
column =
    styled div
        [ displayFlex
        , flexDirection Css.column
        ]


row : List (Attribute msg) -> List (Html msg) -> Html msg
row =
    styled div
        [ displayFlex
        , flexDirection Css.row
        ]


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


hideIf : Bool -> Html msg -> Html msg
hideIf condition html =
    if condition then
        nothing

    else
        html


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
