module Stories.Button exposing (stories)

import Css exposing (column, displayFlex, flexDirection, marginBottom, rem)
import Css.Global exposing (children, everything)
import Html.Styled as Html exposing (text)
import Html.Styled.Attributes exposing (css, disabled)
import Nordea.Components.Button as Button
import Nordea.Resources.Icons as Icons
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI a b {}
stories =
    styledStoriesOf
        "Button"
        [ ( "Primary"
          , \_ ->
                Html.div [ css [ children [ everything [ marginBottom (rem 1) ] ] ] ]
                    [ Button.primary
                        |> Button.view [] [ text "Click me" ]
                    , Button.primary
                        |> Button.view [] [ text "Click me", Button.rightIcon Icons.info ]
                    , Button.primary
                        |> Button.view [] [ Button.leftIcon Icons.info, text "Click me" ]
                    ]
          , {}
          )
        , ( "Primary (Disabled)"
          , \_ ->
                Html.div [ css [ children [ everything [ marginBottom (rem 1) ] ] ] ]
                    [ Button.primary
                        |> Button.view [ disabled True ] [ text "Click me" ]
                    , Button.primary
                        |> Button.view [ disabled True ] [ text "Click me", Button.rightIcon Icons.info ]
                    , Button.primary
                        |> Button.view [ disabled True ] [ Button.leftIcon Icons.info, text "Click me" ]
                    ]
          , {}
          )
        , ( "Secondary"
          , \_ ->
                Html.div [ css [ children [ everything [ marginBottom (rem 1) ] ] ] ]
                    [ Button.secondary
                        |> Button.view [ disabled True ] [ text "Click me" ]
                    , Button.secondary
                        |> Button.view [ disabled True ] [ text "Click me", Button.rightIcon Icons.info ]
                    , Button.secondary
                        |> Button.view [ disabled True ] [ Button.leftIcon Icons.info, text "Click me" ]
                    ]
          , {}
          )
        , ( "Tertiary"
          , \_ ->
                Html.div [ css [ children [ everything [ marginBottom (rem 1) ] ] ] ]
                    [ Button.tertiary
                        |> Button.view [ disabled True ] [ text "Click me" ]
                    , Button.tertiary
                        |> Button.view [ disabled True ] [ text "Click me", Button.rightIcon Icons.info ]
                    , Button.tertiary
                        |> Button.view [ disabled True ] [ Button.leftIcon Icons.info, text "Click me" ]
                    ]
          , {}
          )
        ]
