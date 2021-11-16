module Nordea.Html exposing (maybeAttr, nothing, showIf, styleIf, viewIfNotEmpty, viewMaybe)

import Css exposing (Style)
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attrs
import Json.Encode as Encode


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


maybeAttr : Maybe (Attribute msg) -> Attribute msg
maybeAttr attr =
    attr |> Maybe.withDefault (Attrs.property "optionalAttrProp" (Encode.string ""))
