module Stories.FilterChip exposing (stories)

import Css
import Html.Styled.Attributes exposing (css)
import Nordea.Components.FilterChip as FilterChip
import Nordea.Html as Html
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI a b {}
stories =
    styledStoriesOf
        "FilterChip"
        [ ( "Default"
          , \_ ->
                Html.row [ css [ Css.property "gap" "1rem" ] ]
                    [ FilterChip.init { label = "Under behandling" }
                        |> FilterChip.view []
                    , FilterChip.init { label = "Under oppstart" }
                        |> FilterChip.view []
                    ]
          , {}
          )
        ]
