module Nordea.Html.Events exposing (onChange, onEnterPress)

import Html.Styled exposing (Attribute)
import Html.Styled.Events as Events
import Json.Decode as Json


onChange : (String -> msg) -> Attribute msg
onChange onChangeAction =
    Events.on "change" <| Json.map onChangeAction Events.targetValue


onEnterPress : msg -> Attribute msg
onEnterPress msg =
    let
        isEnter code =
            if code == 13 then
                Json.succeed msg

            else
                Json.fail "not ENTER"
    in
    Events.on "keydown" (Json.andThen isEnter Events.keyCode)
