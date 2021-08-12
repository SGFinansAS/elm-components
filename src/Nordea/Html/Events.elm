module Nordea.Html.Events exposing (onChange)

import Html.Styled exposing (Attribute)
import Html.Styled.Events as Events
import Json.Decode as Json


onChange : (String -> msg) -> Attribute msg
onChange onChangeAction =
    Events.on "change" <| Json.map onChangeAction Events.targetValue
