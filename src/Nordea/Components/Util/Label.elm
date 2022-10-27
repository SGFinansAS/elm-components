module Nordea.Components.Util.Label exposing (init, view, withIsError)

import Css exposing (color)
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes exposing (css)
import Nordea.Components.Text as Text
import Nordea.Html as Html
import Nordea.Resources.Colors as Colors


type alias Label =
    { label : String
    , isError : Bool
    }


init : { label : String } -> Label
init { label } =
    { label = label
    , isError = False
    }


view : List (Attribute msg) -> Label -> Html msg
view attrs { label, isError } =
    Html.label attrs
        [ Text.textSmallLight
            |> Text.view
                [ css [ color Colors.redDark |> Html.styleIf isError ] ]
                [ Html.text label ]
        ]


withIsError : Bool -> Label -> Label
withIsError isError label =
    { label | isError = isError }
