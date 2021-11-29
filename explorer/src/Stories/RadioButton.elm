module Stories.RadioButton exposing (stories)

import Config exposing (Msg(..))
import Css exposing (column, displayFlex, flexDirection, maxWidth, rem)
import Html.Styled as Html exposing (text)
import Html.Styled.Attributes exposing (css)
import Nordea.Components.RadioButton as RadioButton
import Nordea.Components.RadioGroup as RadioGroup
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI a Msg {}
stories =
    styledStoriesOf
        "RadioButton"
        [ ( "Standard"
          , \_ ->
                Html.div [ css [ displayFlex, Css.property "gap" "1rem" ] ]
                    [ RadioButton.init
                        "simple"
                        (text "Click me")
                        NoOp
                        |> RadioButton.view []
                    , RadioButton.init
                        "simple"
                        (text "Click me")
                        NoOp
                        |> RadioButton.withIsSelected True
                        |> RadioButton.view []
                    ]
          , {}
          )
        , ( "Standard with error"
          , \_ ->
                Html.div [ css [ displayFlex, Css.property "gap" "1rem" ] ]
                    [ RadioButton.init
                        "simple"
                        (text "Click me")
                        NoOp
                        |> RadioButton.withHasError True
                        |> RadioButton.view []
                    , RadioButton.init
                        "simple"
                        (text "Click me")
                        NoOp
                        |> RadioButton.withHasError True
                        |> RadioButton.withIsSelected True
                        |> RadioButton.view []
                    ]
          , {}
          )
        , ( "Simple"
          , \_ ->
                Html.div [ css [ displayFlex, Css.property "gap" "1rem" ] ]
                    [ RadioButton.init
                        "simple"
                        (text "Click me")
                        NoOp
                        |> RadioButton.withAppearance RadioButton.Simple
                        |> RadioButton.view []
                    , RadioButton.init
                        "simple"
                        (text "Click me")
                        NoOp
                        |> RadioButton.withAppearance RadioButton.Simple
                        |> RadioButton.withIsSelected True
                        |> RadioButton.view []
                    ]
          , {}
          )
        , ( "Simple with error"
          , \_ ->
                Html.div [ css [ displayFlex, Css.property "gap" "1rem" ] ]
                    [ RadioButton.init
                        "simple"
                        (text "Click me")
                        NoOp
                        |> RadioButton.withAppearance RadioButton.Simple
                        |> RadioButton.withHasError True
                        |> RadioButton.view []
                    , RadioButton.init
                        "simple"
                        (text "Click me")
                        NoOp
                        |> RadioButton.withAppearance RadioButton.Simple
                        |> RadioButton.withHasError True
                        |> RadioButton.withIsSelected True
                        |> RadioButton.view []
                    ]
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
                                    |> RadioButton.withIsSelected (i == 2)
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
                                    |> RadioButton.withIsSelected (i == 2)
                                    |> RadioButton.view []
                            )
                    )
          , {}
          )
        , ( "Group"
          , \_ ->
                RadioGroup.init
                    "Group label"
                    |> RadioGroup.view
                        []
                        [ RadioButton.init
                            "simple"
                            (text "Click me: ")
                            NoOp
                            |> RadioButton.view []
                        , RadioButton.init
                            "simple"
                            (text "Click me: ")
                            NoOp
                            |> RadioButton.view []
                        ]
          , {}
          )
        , ( "Group with error"
          , \_ ->
                RadioGroup.init
                    "Group label"
                    |> RadioGroup.withErrorMessage "Some error message"
                    |> RadioGroup.view
                        []
                        [ RadioButton.init
                            "simple"
                            (text "Click me: ")
                            NoOp
                            |> RadioButton.withHasError True
                            |> RadioButton.view []
                        , RadioButton.init
                            "simple"
                            (text "Click me: ")
                            NoOp
                            |> RadioButton.withHasError True
                            |> RadioButton.view []
                        ]
          , {}
          )
        ]
