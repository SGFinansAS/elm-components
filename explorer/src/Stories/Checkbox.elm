module Stories.Checkbox exposing (stories)

import Config exposing (Msg(..))
import Css exposing (column, displayFlex, flexDirection, maxWidth, rem)
import Html.Styled as Html exposing (text)
import Html.Styled.Attributes as Attrs exposing (css)
import Nordea.Components.Checkbox as Checkbox
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI a Msg {}
stories =
    styledStoriesOf
        "Checkbox"
        [ ( "Standard"
          , \_ ->
                Checkbox.init
                    "simple"
                    (text "Click me")
                    (\_ -> NoOp)
                    |> Checkbox.view []
          , {}
          )
        , ( "Standard with error"
          , \_ ->
                Checkbox.init
                    "simple"
                    (text "Click me")
                    (\_ -> NoOp)
                    |> Checkbox.withHasError True
                    |> Checkbox.view []
          , {}
          )
        , ( "Simple"
          , \_ ->
                Checkbox.init
                    "simple"
                    (text "Click me")
                    (\_ -> NoOp)
                    |> Checkbox.withAppearance Checkbox.Simple
                    |> Checkbox.view []
          , {}
          )
        , ( "Simple with error"
          , \_ ->
                Checkbox.init
                    "simple"
                    (text "Click me")
                    (\_ -> NoOp)
                    |> Checkbox.withAppearance Checkbox.Simple
                    |> Checkbox.withHasError True
                    |> Checkbox.view []
          , {}
          )
        , ( "Liststyle"
          , \_ ->
                Html.div [ css [ displayFlex, flexDirection column, maxWidth (rem 30) ] ]
                    (List.range 0 5
                        |> List.map
                            (\i ->
                                Checkbox.init
                                    "simple"
                                    (text ("Click me: " ++ String.fromInt i))
                                    (\_ -> NoOp)
                                    |> Checkbox.withAppearance Checkbox.ListStyle
                                    |> Checkbox.view []
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
                                Checkbox.init
                                    "simple"
                                    (text ("Click me: " ++ String.fromInt i))
                                    (\_ -> NoOp)
                                    |> Checkbox.withAppearance Checkbox.ListStyle
                                    |> Checkbox.withHasError True
                                    |> Checkbox.view []
                            )
                    )
          , {}
          )
        ]
