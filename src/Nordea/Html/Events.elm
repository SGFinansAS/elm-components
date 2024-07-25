module Nordea.Html.Events exposing (Key(..), onChange, onEnterOrSpacePress, onEscPress, onKeyDown)

import Html.Styled exposing (Attribute)
import Html.Styled.Events as Events
import Json.Decode as Decode


type Key
    = Space
    | Enter
    | Esc


onChange : (String -> msg) -> Attribute msg
onChange onChangeAction =
    Events.on "change" <| Decode.map onChangeAction Events.targetValue


onKeyDown : (Key -> msg) -> Attribute msg
onKeyDown msg =
    -- prevent the space from moving the page
    Events.preventDefaultOn "keydown"
        (Events.keyCode
            |> Decode.andThen
                (\keyCode ->
                    case keyCode of
                        32 ->
                            Decode.succeed ( msg Space, True )

                        13 ->
                            Decode.succeed ( msg Enter, True )

                        27 ->
                            Decode.succeed ( msg Esc, True )

                        _ ->
                            Decode.fail "Not space and enter"
                )
        )


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
