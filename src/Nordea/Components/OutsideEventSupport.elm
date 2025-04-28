module Nordea.Components.OutsideEventSupport exposing (OutsideEventType(..), view)

import Css exposing (display, none)
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes exposing (class, css)
import Html.Styled.Events as Events
import Json.Decode as Decode
import Nordea.Html exposing (showIf)


type OutsideEventType
    = OutsideClick
    | OutsideFocus


view : { msg : msg, isActive : Bool, eventTypes : List OutsideEventType } -> Html msg
view { msg, isActive, eventTypes } =
    let
        eventAttrs =
            eventTypes
                |> List.concatMap
                    (\eventType ->
                        [ Events.on (eventTypeToClassName eventType) (Decode.succeed msg), class (eventTypeToClassName eventType) ]
                    )
    in
    Html.span (css [ display none ] :: eventAttrs) []
        |> showIf isActive


eventTypeToClassName : OutsideEventType -> String
eventTypeToClassName eventType =
    case eventType of
        OutsideClick ->
            "outside-click"

        OutsideFocus ->
            "outside-focus"
