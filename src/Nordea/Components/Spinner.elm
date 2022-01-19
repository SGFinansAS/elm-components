module Nordea.Components.Spinner exposing (custom, small)

import Css exposing (Style, color, height, rem, width)
import Html.Styled exposing (Attribute, Html, div)
import Html.Styled.Attributes exposing (css)
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Icons as Icons
import Nordea.Themes as Themes


small : List (Attribute msg) -> Html msg
small attrs =
    Icons.spinner (css [ width (rem 3.75), Themes.color Themes.PrimaryColor Colors.blueDeep ] :: attrs)


custom : List (Attribute msg) -> Html msg
custom attrs =
    Icons.spinner (css [ Themes.color Themes.PrimaryColor Colors.blueDeep ] :: attrs)
