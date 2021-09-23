module Stories.RadioButton exposing (stories)

import Config exposing (Msg(..))
import Css exposing (column, displayFlex, flexDirection, maxWidth, rem)
import Html.Styled as Html exposing (text)
import Html.Styled.Attributes as Attrs exposing (css)
import Nordea.Components.RadioButton as RadioButton
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI a Msg {}
stories =
    styledStoriesOf
        "RadioButton"
        [ ( "Standard"
          , \_ ->
                RadioButton.init
                    "simple"
                    (text "Click me")
                    NoOp
                    |> RadioButton.view []
          , {}
          )
        , ( "Standard with error"
          , \_ ->
                RadioButton.init
                    "simple"
                    (text "Click me")
                    NoOp
                    |> RadioButton.withHasError True
                    |> RadioButton.view []
          , {}
          )
        , ( "Simple"
          , \_ ->
                RadioButton.init
                    "simple"
                    (text "Click me")
                    NoOp
                    |> RadioButton.withAppearance RadioButton.Simple
                    |> RadioButton.view []
          , {}
          )
        , ( "Simple with error"
          , \_ ->
                RadioButton.init
                    "simple"
                    (text "Click me")
                    NoOp
                    |> RadioButton.withAppearance RadioButton.Simple
                    |> RadioButton.withHasError True
                    |> RadioButton.view []
          , {}
          )
        , ( "Liststyle"
          , \_ ->
                Html.div [ css [ displayFlex, flexDirection column, maxWidth (rem 30) ] ]
                    (List.range 0 5
                        |> List.map
                            (\i ->
                                RadioButton.init
                                    "simple"
                                    (text ("Click me: " ++ String.fromInt i))
                                    NoOp
                                    |> RadioButton.withAppearance RadioButton.ListStyle
                                    |> RadioButton.view []
                            )
                    )
          , {}
          )
        , ( "Liststyle with error"
          , \_ ->
                Html.div [ css [ displayFlex, flexDirection column, maxWidth (rem 30) ] ]
                    (List.range 0 5
                        |> List.map
                            (\i ->
                                RadioButton.init
                                    "simple"
                                    (text ("Click me: " ++ String.fromInt i))
                                    NoOp
                                    |> RadioButton.withAppearance RadioButton.ListStyle
                                    |> RadioButton.withHasError True
                                    |> RadioButton.view []
                            )
                    )
          , {}
          )
        ]
