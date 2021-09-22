module Nordea.Components.Spinner exposing (default, small)

import Css exposing (Style, color, height, rem, width)
import Html.Styled exposing (Attribute, Html, div)
import Html.Styled.Attributes exposing (css)
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Icons as Icons


default : List (Attribute msg) -> Html msg
default attrs =
    div
        (css [ color Colors.blueDeep ] :: attrs)
        [ Icons.spinner ]


small : List (Attribute msg) -> Html msg
small attrs =
    div
        (css
            [ color Colors.blueDeep
            , width (rem 3.75)
            , height (rem 3.75)
            ]
            :: attrs
        )
        [ Icons.spinner ]
