module Nordea.Html.Events exposing (Key(..), onChange, onEnterOrSpacePress, onEnterPress, onEscPress, onKeyDown, onKeyDownMaybe)

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


onKeyDownMaybe : (Key -> Maybe msg) -> Attribute msg
onKeyDownMaybe msg =
    -- prevent the space from moving the page
    Events.preventDefaultOn "keydown"
        (Events.keyCode
            |> Decode.andThen
                (\keyCode ->
                    let
                        try key =
                            msg key
                                |> Maybe.map (\keyMsg -> Decode.succeed ( keyMsg, True ))
                                |> Maybe.withDefault (Decode.fail "Not relevant keypress")
                    in
                    case keyCode of
                        32 ->
                            try Space

                        13 ->
                            try Enter

                        27 ->
                            try Esc

                        _ ->
                            Decode.fail "Not space and enter"
                )
        )


onEnterPress : msg -> Attribute msg
onEnterPress msg =
    Events.preventDefaultOn "keydown"
        -- prevent the space from moving the page
        (Events.keyCode
            |> Decode.andThen
                (\keyCode ->
                    if keyCode == 13 then
                        Decode.succeed ( msg, True )

                    else
                        Decode.fail "Not enter"
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
                        Decode.fail "Not space or enter"
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
