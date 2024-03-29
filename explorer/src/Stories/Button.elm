module Stories.Button exposing (stories)

import Css
    exposing
        ( color
        , column
        , displayFlex
        , flexDirection
        , justifyContent
        , marginBottom
        , minHeight
        , rem
        , spaceBetween
        , width
        )
import Css.Global exposing (children, everything)
import Html.Styled as Html exposing (text)
import Html.Styled.Attributes exposing (css, disabled)
import Nordea.Components.Button as Button
import Nordea.Components.Status as Status
import Nordea.Components.Text as Text
import Nordea.Resources.Colors as Colors
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
                        |> Button.view [] [ text "Click me", Icons.rightIcon (Icons.info []) ]
                    , Button.primary
                        |> Button.view [] [ Icons.leftIcon (Icons.info []), text "Click me" ]
                    ]
          , {}
          )
        , ( "Primary (Disabled)"
          , \_ ->
                Html.div [ css [ children [ everything [ marginBottom (rem 1) ] ] ] ]
                    [ Button.primary
                        |> Button.view [ disabled True ] [ text "Click me" ]
                    , Button.primary
                        |> Button.view [ disabled True ] [ text "Click me", Icons.rightIcon (Icons.info []) ]
                    , Button.primary
                        |> Button.view [ disabled True ] [ Icons.leftIcon (Icons.info []), text "Click me" ]
                    ]
          , {}
          )
        , ( "Primary Small"
          , \_ ->
                Html.div [ css [ children [ everything [ marginBottom (rem 1) ] ] ] ]
                    [ Button.primary
                        |> Button.withSmallSize
                        |> Button.view [] [ text "Click me" ]
                    , Button.primary
                        |> Button.withSmallSize
                        |> Button.view [] [ text "Click me", Icons.rightIcon (Icons.info []) ]
                    , Button.primary
                        |> Button.withSmallSize
                        |> Button.view [] [ Icons.leftIcon (Icons.info []), text "Click me" ]
                    ]
          , {}
          )
        , ( "Secondary"
          , \_ ->
                Html.div [ css [ children [ everything [ marginBottom (rem 1) ] ] ] ]
                    [ Button.secondary
                        |> Button.view [] [ text "Click me" ]
                    , Button.secondary
                        |> Button.view [] [ text "Click me", Icons.rightIcon (Icons.info []) ]
                    , Button.secondary
                        |> Button.view [] [ Icons.leftIcon (Icons.info []), text "Click me" ]
                    ]
          , {}
          )
        , ( "Secondary Small"
          , \_ ->
                Html.div [ css [ children [ everything [ marginBottom (rem 1) ] ] ] ]
                    [ Button.secondary
                        |> Button.withSmallSize
                        |> Button.view [] [ text "Click me" ]
                    , Button.secondary
                        |> Button.withSmallSize
                        |> Button.view [] [ text "Click me", Icons.rightIcon (Icons.info []) ]
                    , Button.secondary
                        |> Button.withSmallSize
                        |> Button.view [] [ Icons.leftIcon (Icons.info []), text "Click me" ]
                    ]
          , {}
          )
        , ( "Tertiary"
          , \_ ->
                Html.div [ css [ children [ everything [ marginBottom (rem 1) ] ] ] ]
                    [ Button.tertiary
                        |> Button.view [] [ text "Click me" ]
                    , Button.tertiary
                        |> Button.view [] [ text "Click me", Icons.rightIcon (Icons.info []) ]
                    , Button.tertiary
                        |> Button.view [] [ Icons.leftIcon (Icons.info []), text "Click me" ]
                    ]
          , {}
          )
        , ( "Tertiary Small"
          , \_ ->
                Html.div [ css [ children [ everything [ marginBottom (rem 1) ] ] ] ]
                    [ Button.tertiary
                        |> Button.withSmallSize
                        |> Button.view [] [ text "Click me" ]
                    , Button.tertiary
                        |> Button.withSmallSize
                        |> Button.view [] [ text "Click me", Icons.rightIcon (Icons.info []) ]
                    , Button.tertiary
                        |> Button.withSmallSize
                        |> Button.view [] [ Icons.leftIcon (Icons.info []), text "Click me" ]
                    ]
          , {}
          )
        , ( "Card (clickable)"
          , \_ ->
                Html.div [ css [ children [ everything [ marginBottom (rem 1) ] ] ] ]
                    [ Button.card
                        |> Button.view
                            [ css
                                [ width (rem 11)
                                , minHeight (rem 8.25)
                                , justifyContent spaceBetween
                                , flexDirection column
                                ]
                            ]
                            [ Text.bodyTextSmall |> Text.view [] [ Html.text "Øvrig reg.bart landbruksutstyr" ]
                            ]
                    , Button.card
                        |> Button.withHtmlTag Html.a
                        |> Button.view
                            [ css
                                [ width (rem 11)
                                , minHeight (rem 8.25)
                                , justifyContent spaceBetween
                                , flexDirection column
                                ]
                            ]
                            [ Html.div
                                [ css [ marginBottom (rem 2.0) ] ]
                                [ Status.blue "Status" [] ]
                            , Text.headlineTwo |> Text.view [] [ Html.text "10" ]
                            , Text.bodyTextSmall
                                |> Text.view [ css [ marginBottom (rem 1) |> Css.important ] ]
                                    [ Html.text "Applications ready for e-signing" ]
                            ]
                    ]
          , {}
          )
        , ( "Card Small (clickable)"
          , \_ ->
                Html.div [ css [ children [ everything [ marginBottom (rem 1) ] ] ] ]
                    [ Button.card
                        |> Button.withSmallSize
                        |> Button.view [ css [ width (rem 20) ] ]
                            [ Text.textHeavy |> Text.view [ css [ displayFlex, marginBottom (rem 0.25), color Colors.eclipse ] ] [ Html.text "Some text goes here" ]
                            , Text.textTiny |> Text.view [ css [ color Colors.eclipse ] ] [ Html.text "Some info text" ]
                            ]
                    ]
          , {}
          )
        , ( "With FlatLink style"
          , \_ ->
                Html.div [ css [ children [ everything [ marginBottom (rem 1) ] ] ] ]
                    [ Button.flatLinkStyle
                        |> Button.view [] [ text "Click me" ]
                    , Button.flatLinkStyle
                        |> Button.view [] [ text "Click me", Icons.rightIcon (Icons.info []) ]
                    , Button.flatLinkStyle
                        |> Button.view [] [ Icons.leftIcon (Icons.info []), text "Click me" ]
                    ]
          , {}
          )
        , ( "Circular"
          , \_ ->
                Html.div [ css [ children [ everything [ marginBottom (rem 1) ] ] ] ]
                    [ Button.circular
                        |> Button.view [] [ Icons.chevronLeft [] ]
                    , Button.circular
                        |> Button.view [] [ Icons.chevronRight [] ]
                    ]
          , {}
          )
        ]
