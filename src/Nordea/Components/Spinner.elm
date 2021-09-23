module Nordea.Components.Spinner exposing (small)

import Css exposing (Style, color, height, rem, width)
import Html.Styled exposing (Attribute, Html, div)
import Html.Styled.Attributes exposing (css)
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Icons as Icons


small : List (Attribute msg) -> Html msg
small =
    Icons.spinner
