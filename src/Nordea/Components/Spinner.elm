module Nordea.Components.Spinner exposing (small)

import Css exposing (Style, color, height, rem, width)
import Html.Styled exposing (Attribute, Html, div)
import Html.Styled.Attributes exposing (css)
import Nordea.Css exposing (colorWithVariable)
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Icons as Icons


small : List (Attribute msg) -> Html msg
small attrs =
    Icons.spinner (css [ width (rem 3.75), colorWithVariable "--themePrimaryColor" Colors.blueDeep ] :: attrs)
