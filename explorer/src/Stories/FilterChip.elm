module Stories.FilterChip exposing (stories)

import Css exposing (rem)
import Html.Styled.Attributes exposing (css)
import Nordea.Components.FilterChip as FilterChip
import Nordea.Css exposing (gap)
import Nordea.Html as Html
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI a b {}
stories =
    styledStoriesOf
        "FilterChip"
        [ ( "Default"
          , \_ ->
                Html.row [ css [ gap (rem 1) ] ]
                    [ FilterChip.init { label = "Under behandling" }
                        |> FilterChip.view []
                    , FilterChip.init { label = "Under oppstart" }
                        |> FilterChip.view []
                    ]
          , {}
          )
        ]
