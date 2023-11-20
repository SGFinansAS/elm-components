module Stories.Checkbox exposing (stories)

import Config exposing (Msg(..))
import Css exposing (column, displayFlex, flexDirection, maxWidth, rem)
import Html.Styled as Html exposing (text)
import Html.Styled.Attributes exposing (css, disabled)
import Nordea.Components.Checkbox as Checkbox
import Nordea.Components.Text as Text
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI a Msg {}
stories =
    styledStoriesOf
        "Checkbox"
        [ ( "Standard"
          , \_ ->
                Html.div [ css [ displayFlex, Css.property "gap" "1rem" ] ]
                    [ Checkbox.init
                        "simple"
                        (text "Click me")
                        (\_ -> NoOp)
                        |> Checkbox.view []
                    , Checkbox.init
                        "simple"
                        (text "Click me")
                        (\_ -> NoOp)
                        |> Checkbox.withIsChecked True
                        |> Checkbox.view []
                    ]
          , {}
          )
        , ( "Standard with error"
          , \_ ->
                Html.div [ css [ displayFlex, Css.property "gap" "1rem" ] ]
                    [ Checkbox.init
                        "simple"
                        (text "Click me")
                        (\_ -> NoOp)
                        |> Checkbox.withHasError True
                        |> Checkbox.view []
                    , Checkbox.init
                        "simple"
                        (text "Click me")
                        (\_ -> NoOp)
                        |> Checkbox.withHasError True
                        |> Checkbox.withIsChecked True
                        |> Checkbox.view []
                    ]
          , {}
          )
        , ( "Standard disabled"
          , \_ ->
                Html.div [ css [ displayFlex, Css.property "gap" "1rem" ] ]
                    [ Checkbox.init
                        "standard"
                        (text "Click me")
                        (\_ -> NoOp)
                        |> Checkbox.view [ disabled True ]
                    , Checkbox.init
                        "standard"
                        (text "Click me")
                        (\_ -> NoOp)
                        |> Checkbox.withIsChecked True
                        |> Checkbox.view [ disabled True ]
                    ]
          , {}
          )
        , ( "Small"
          , \_ ->
                Html.div [ css [ displayFlex, Css.property "gap" "1rem" ] ]
                    [ Checkbox.init
                        "small"
                        (Text.textTinyLight |> Text.view [] [ text "Click me" ])
                        (\_ -> NoOp)
                        |> Checkbox.withAppearance Checkbox.Small
                        |> Checkbox.view []
                    , Checkbox.init
                        "small"
                        (Text.textTinyLight |> Text.view [] [ text "Click me" ])
                        (\_ -> NoOp)
                        |> Checkbox.withAppearance Checkbox.Small
                        |> Checkbox.withIsChecked True
                        |> Checkbox.view []
                    ]
          , {}
          )
        , ( "Small with error"
          , \_ ->
                Html.div [ css [ displayFlex, Css.property "gap" "1rem" ] ]
                    [ Checkbox.init
                        "small"
                        (Text.textTinyLight |> Text.view [] [ text "Click me" ])
                        (\_ -> NoOp)
                        |> Checkbox.withAppearance Checkbox.Small
                        |> Checkbox.withHasError True
                        |> Checkbox.view []
                    , Checkbox.init
                        "small"
                        (Text.textTinyLight |> Text.view [] [ text "Click me" ])
                        (\_ -> NoOp)
                        |> Checkbox.withAppearance Checkbox.Small
                        |> Checkbox.withIsChecked True
                        |> Checkbox.withHasError True
                        |> Checkbox.view []
                    ]
          , {}
          )
        , ( "Simple"
          , \_ ->
                Html.div [ css [ displayFlex, Css.property "gap" "1rem" ] ]
                    [ Checkbox.init
                        "simple"
                        (text "Click me")
                        (\_ -> NoOp)
                        |> Checkbox.withAppearance Checkbox.Simple
                        |> Checkbox.view []
                    , Checkbox.init
                        "simple"
                        (text "Click me")
                        (\_ -> NoOp)
                        |> Checkbox.withAppearance Checkbox.Simple
                        |> Checkbox.withIsChecked True
                        |> Checkbox.view []
                    ]
          , {}
          )
        , ( "Simple with error"
          , \_ ->
                Html.div [ css [ displayFlex, Css.property "gap" "1rem" ] ]
                    [ Checkbox.init
                        "simple"
                        (text "Click me")
                        (\_ -> NoOp)
                        |> Checkbox.withAppearance Checkbox.Simple
                        |> Checkbox.withHasError True
                        |> Checkbox.view []
                    , Checkbox.init
                        "simple"
                        (text "Click me")
                        (\_ -> NoOp)
                        |> Checkbox.withAppearance Checkbox.Simple
                        |> Checkbox.withHasError True
                        |> Checkbox.withIsChecked True
                        |> Checkbox.view []
                    ]
          , {}
          )
        , ( "Simple disabled"
          , \_ ->
                Html.div [ css [ displayFlex, Css.property "gap" "1rem" ] ]
                    [ Checkbox.init
                        "simple"
                        (text "Click me")
                        (\_ -> NoOp)
                        |> Checkbox.withAppearance Checkbox.Simple
                        |> Checkbox.view [ disabled True ]
                    , Checkbox.init
                        "simple"
                        (text "Click me")
                        (\_ -> NoOp)
                        |> Checkbox.withAppearance Checkbox.Simple
                        |> Checkbox.withIsChecked True
                        |> Checkbox.view [ disabled True ]
                    ]
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
                                    |> Checkbox.withIsChecked (i == 2)
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
                                    |> Checkbox.withIsChecked (i == 2)
                                    |> Checkbox.view []
                            )
                    )
          , {}
          )
        ]
