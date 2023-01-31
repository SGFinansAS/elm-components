module Stories.Tabs exposing (stories)

import Css
import Html.Styled as Html
import Html.Styled.Attributes as Attrs exposing (css)
import Nordea.Components.Tabs as Tabs
import Nordea.Html as Html
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI a b {}
stories =
    styledStoriesOf
        "Tabs"
        [ ( "Default"
          , \_ ->
                Html.row []
                    [ Tabs.init
                        |> Tabs.withIsActive True
                        |> Tabs.view [] [ Html.text "test1" ]
                    , Tabs.init
                        |> Tabs.view [] [ Html.text "test2" ]
                    , Tabs.init
                        |> Tabs.view [] [ Html.text "test3" ]
                    , Tabs.init
                        |> Tabs.view [] [ Html.text "test4" ]
                    ]
          , {}
          )
        , ( "As link"
          , \_ ->
                Html.row []
                    [ Tabs.init
                        |> Tabs.withIsActive True
                        |> Tabs.withHtmlTag Html.a
                        |> Tabs.view [ Attrs.href "#" ] [ Html.text "test1" ]
                    , Tabs.init
                        |> Tabs.view [] [ Html.text "test2" ]
                    , Tabs.init
                        |> Tabs.view [] [ Html.text "test3" ]
                    , Tabs.init
                        |> Tabs.view [] [ Html.text "test4" ]
                    ]
          , {}
          )
        ]
