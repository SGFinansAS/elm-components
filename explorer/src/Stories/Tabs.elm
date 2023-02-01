module Stories.Tabs exposing (stories)

import Html.Styled as Html
import Html.Styled.Attributes as Attrs
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
        , ( "As button"
          , \_ ->
                Html.row []
                    [ Tabs.init
                        |> Tabs.withIsActive True
                        |> Tabs.withHtmlTag Html.button
                        |> Tabs.view [] [ Html.text "test1" ]
                    , Tabs.init
                        |> Tabs.withHtmlTag Html.button
                        |> Tabs.view [] [ Html.text "test2" ]
                    , Tabs.init
                        |> Tabs.withHtmlTag Html.button
                        |> Tabs.view [] [ Html.text "test3" ]
                    , Tabs.init
                        |> Tabs.withHtmlTag Html.button
                        |> Tabs.view [] [ Html.text "test4" ]
                    ]
          , {}
          )
        ]
