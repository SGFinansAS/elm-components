module Stories.FilterLabel exposing (stories)

import Css
import Html.Styled.Attributes exposing (css)
import Nordea.Components.FilterLabel as FilterLabel
import Nordea.Html as Html
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI a b {}
stories =
    styledStoriesOf
        "FilterLabel"
        [ ( "Default"
          , \_ ->
                Html.row [ css [ Css.property "gap" "1rem" ] ]
                    [ FilterLabel.init { label = "Under behandling" }
                        |> FilterLabel.view []
                    , FilterLabel.init { label = "Under oppstart" }
                        |> FilterLabel.view []
                    ]
          , {}
          )
        ]
