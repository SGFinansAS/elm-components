module Stories.Icons exposing (stories)

import Css exposing (displayFlex, marginBottom, rem, width)
import Css.Global exposing (children, everything)
import Html.Styled as Html
import Html.Styled.Attributes exposing (css)
import Nordea.Resources.Icons as Icons
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI a b {}
stories =
    styledStoriesOf
        "Icons"
        [ ( "Icons"
          , \_ ->
                Html.div [ css [ displayFlex, Css.property "gap" "1rem", children [ everything [ marginBottom (rem 2) ] ] ] ]
                    [ Icons.filledCheckmark [ css [ width (rem 1.5) ] ]
                    , Icons.unfilledMark [ css [ width (rem 1.5) ] ]
                    ]
          , {}
          )
        ]
