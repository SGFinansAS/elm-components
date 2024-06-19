module Nordea.Html.Events exposing (onChange, onEnterOrSpacePress, onEscPress)

import Html.Styled exposing (Attribute)
import Html.Styled.Events as Events
import Json.Decode as Decode


onChange : (String -> msg) -> Attribute msg
onChange onChangeAction =
    Events.on "change" <| Decode.map onChangeAction Events.targetValue


onEnterOrSpacePress : msg -> Attribute msg
onEnterOrSpacePress msg =
    Events.preventDefaultOn "keydown"
        -- prevent the space from moving the page
        (Events.keyCode
            |> Decode.andThen
                (\keyCode ->
                    if keyCode == 32 || keyCode == 13 then
                        Decode.succeed ( msg, True )

                    else
                        Decode.fail "Not space and enter"
                )
        )


onEscPress : msg -> Attribute msg
onEscPress msg =
    Events.preventDefaultOn "keydown"
        (Events.keyCode
            |> Decode.andThen
                (\keyCode ->
                    if keyCode == 27 then
                        Decode.succeed ( msg, True )

                    else
                        Decode.fail "not ESC"
                )
        )
