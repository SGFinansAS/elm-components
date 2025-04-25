module Nordea.Components.OutsideEventSupport exposing (OutsideEventType(..), view)

import Css exposing (display, none)
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes exposing (class, css)
import Nordea.Html exposing (showIf)


type OutsideEventType
    = OutsideClick
    | OutsideFocus


view : { isActive : Bool, eventType : OutsideEventType } -> Html msg
view { isActive, eventType } =
    Html.span [ css [ display none ], class (eventTypeToClassName eventType) ] []
        |> showIf isActive


eventTypeToClassName : OutsideEventType -> String
eventTypeToClassName eventType =
    case eventType of
        OutsideClick ->
            "outside-click"

        OutsideFocus ->
            "focusin"
