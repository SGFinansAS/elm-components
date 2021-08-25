module Stories.FlatLink exposing (stories)

import Css exposing (marginBottom, rem)
import Css.Global exposing (children, everything)
import Html.Styled as Html exposing (text)
import Html.Styled.Attributes exposing (css, href)
import Nordea.Components.Button as ButtonVariant
import Nordea.Components.FlatLink as FlatLink
import Nordea.Resources.Icons as Icons
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI a b {}
stories =
    styledStoriesOf
        "FlatLink"
        [ ( "Default"
          , \_ ->
                Html.div [ css [ children [ everything [ marginBottom (rem 1) ] ] ] ]
                    [ FlatLink.default
                        |> FlatLink.view [ href "/#Default/FlatLink/Default" ] [ text "Click me" ]
                    , FlatLink.default
                        |> FlatLink.view [ href "/#Default/FlatLink/Default" ] [ text "Click me", Icons.rightIcon Icons.info ]
                    , FlatLink.default
                        |> FlatLink.view [ href "/#Default/FlatLink/Default" ] [ Icons.leftIcon Icons.info, text "Click me" ]
                    ]
          , {}
          )
        , ( "Default (Disabled)"
          , \_ ->
                Html.div [ css [ children [ everything [ marginBottom (rem 1) ] ] ] ]
                    [ FlatLink.default
                        |> FlatLink.withDisabled
                        |> FlatLink.view [ href "/#Default/FlatLink/Default" ] [ text "Click me" ]
                    , FlatLink.default
                        |> FlatLink.withDisabled
                        |> FlatLink.view [ href "/#Default/FlatLink/Default" ] [ text "Click me", Icons.rightIcon Icons.info ]
                    , FlatLink.default
                        |> FlatLink.withDisabled
                        |> FlatLink.view [ href "/#Default/FlatLink/Default" ] [ Icons.leftIcon Icons.info, text "Click me" ]
                    ]
          , {}
          )
        , ( "Mini"
          , \_ ->
                Html.div [ css [ children [ everything [ marginBottom (rem 1) ] ] ] ]
                    [ FlatLink.mini
                        |> FlatLink.view [ href "/#Default/FlatLink/Mini" ] [ text "Click me" ]
                    , FlatLink.mini
                        |> FlatLink.view [ href "/#Default/FlatLink/Mini" ] [ text "Click me", Icons.rightIcon Icons.info ]
                    , FlatLink.mini
                        |> FlatLink.view [ href "/#Default/FlatLink/Mini" ] [ Icons.leftIcon Icons.info, text "Click me" ]
                    ]
          , {}
          )
        , ( "withButtonStyle"
          , \_ ->
                Html.div [ css [ children [ everything [ marginBottom (rem 1) ] ] ] ]
                    [ FlatLink.default
                        |> FlatLink.withButtonStyle ButtonVariant.Primary
                        |> FlatLink.view [ href "/#Default/FlatLink/withButtonStyle" ] [ text "Click me" ]
                    , FlatLink.default
                        |> FlatLink.withButtonStyle ButtonVariant.Primary
                        |> FlatLink.view [ href "/#Default/FlatLink/withButtonStyle" ] [ text "Click me", Icons.rightIcon Icons.info ]
                    , FlatLink.default
                        |> FlatLink.withButtonStyle ButtonVariant.Primary
                        |> FlatLink.view [ href "/#Default/FlatLink/withButtonStyle" ] [ Icons.leftIcon Icons.info, text "Click me" ]
                    ]
          , {}
          )
        ]
