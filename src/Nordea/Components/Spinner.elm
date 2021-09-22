module Nordea.Components.Spinner exposing (..)

import Html.Styled exposing (Attribute, Html, div)
import Nordea.Resources.Icons as Icons


view : List (Attribute msg) -> Html msg
view attrs =
    div
        attrs
        [ Icons.spinner ]
