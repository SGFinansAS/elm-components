module Nordea.Html exposing
    ( attrIf
    , column
    , nothing
    , row
    , showIf
    , styleIf
    , viewIfNotEmpty
    , viewMaybe
    , wrappedRow
    )

import Css exposing (Style, displayFlex, flexDirection, flexWrap, wrap)
import Html.Styled as Html exposing (Attribute, Html, div, styled)
import Html.Styled.Attributes as Attributes


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


wrappedRow : List (Attribute msg) -> List (Html msg) -> Html msg
wrappedRow =
    styled div
        [ displayFlex
        , flexDirection Css.row
        , flexWrap wrap
        ]



-- VISIBILITY


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
        Css.property "_" "_"


attrIf condition attr =
    if condition then
        attr

    else
        Attributes.attribute "" ""
