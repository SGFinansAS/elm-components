module UIExplorer.Unstyled exposing (Stories, Story)

import Html exposing (Html)
import UIExplorer exposing (Model)


type alias Story a b c =
    ( String, Model a b c -> Html b, c )


type alias Stories a b c =
    List (Story a b c)
