module Stories.RadioButton exposing (stories)

import Config exposing (Config, Msg(..))
import Css exposing (displayFlex)
import Html.Styled as Html exposing (text)
import Html.Styled.Attributes exposing (css, disabled)
import Nordea.Components.RadioButton as RadioButton
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI Config Msg {}
stories =
    styledStoriesOf
        "RadioButton"
        [ ( "Standard"
          , \config ->
                Html.div [ css [ displayFlex, Css.property "gap" "1rem" ] ]
                    [ RadioButton.init
                        "simple"
                        (text "Click me")
                        (UpdateActiveRadioButton "first")
                        |> RadioButton.withIsSelected (config.customModel.activeRadioButton == "first")
                        |> RadioButton.view []
                    , RadioButton.init
                        "simple"
                        (text "Click me")
                        (UpdateActiveRadioButton "second")
                        |> RadioButton.withIsSelected (config.customModel.activeRadioButton == "second")
                        |> RadioButton.view []
                    ]
          , {}
          )
        , ( "Standard with error"
          , \config ->
                Html.div [ css [ displayFlex, Css.property "gap" "1rem" ] ]
                    [ RadioButton.init
                        "simple"
                        (text "Click me")
                        (UpdateActiveRadioButton "first")
                        |> RadioButton.withIsSelected (config.customModel.activeRadioButton == "first")
                        |> RadioButton.withHasError True
                        |> RadioButton.view []
                    , RadioButton.init
                        "simple"
                        (text "Click me")
                        (UpdateActiveRadioButton "second")
                        |> RadioButton.withIsSelected (config.customModel.activeRadioButton == "second")
                        |> RadioButton.withHasError True
                        |> RadioButton.view []
                    ]
          , {}
          )
        , ( "Standard disabled"
          , \config ->
                Html.div [ css [ displayFlex, Css.property "gap" "1rem" ] ]
                    [ RadioButton.init
                        "simple"
                        (text "Click me")
                        (UpdateActiveRadioButton "first")
                        |> RadioButton.withIsSelected (config.customModel.activeRadioButton == "first")
                        |> RadioButton.view [ disabled True ]
                    , RadioButton.init
                        "simple"
                        (text "Click me")
                        (UpdateActiveRadioButton "second")
                        |> RadioButton.withIsSelected (config.customModel.activeRadioButton == "second")
                        |> RadioButton.view [ disabled True ]
                    ]
          , {}
          )
        , ( "Simple"
          , \config ->
                Html.div [ css [ displayFlex, Css.property "gap" "1rem" ] ]
                    [ RadioButton.init
                        "simple"
                        (text "Click me")
                        (UpdateActiveRadioButton "first")
                        |> RadioButton.withIsSelected (config.customModel.activeRadioButton == "first")
                        |> RadioButton.withAppearance RadioButton.Simple
                        |> RadioButton.view []
                    , RadioButton.init
                        "simple"
                        (text "Click me")
                        (UpdateActiveRadioButton "second")
                        |> RadioButton.withAppearance RadioButton.Simple
                        |> RadioButton.withIsSelected (config.customModel.activeRadioButton == "second")
                        |> RadioButton.view []
                    ]
          , {}
          )
        , ( "Simple with error"
          , \config ->
                Html.div [ css [ displayFlex, Css.property "gap" "1rem" ] ]
                    [ RadioButton.init
                        "simple"
                        (text "Click me")
                        (UpdateActiveRadioButton "first")
                        |> RadioButton.withIsSelected (config.customModel.activeRadioButton == "first")
                        |> RadioButton.withAppearance RadioButton.Simple
                        |> RadioButton.withHasError True
                        |> RadioButton.view []
                    , RadioButton.init
                        "simple"
                        (text "Click me")
                        (UpdateActiveRadioButton "second")
                        |> RadioButton.withAppearance RadioButton.Simple
                        |> RadioButton.withHasError True
                        |> RadioButton.withIsSelected (config.customModel.activeRadioButton == "second")
                        |> RadioButton.view []
                    ]
          , {}
          )
        , ( "Simple disabled"
          , \config ->
                Html.div [ css [ displayFlex, Css.property "gap" "1rem" ] ]
                    [ RadioButton.init
                        "simple"
                        (text "Click me")
                        (UpdateActiveRadioButton "first")
                        |> RadioButton.withIsSelected (config.customModel.activeRadioButton == "first")
                        |> RadioButton.withAppearance RadioButton.Simple
                        |> RadioButton.view [ disabled True ]
                    , RadioButton.init
                        "simple"
                        (text "Click me")
                        (UpdateActiveRadioButton "second")
                        |> RadioButton.withAppearance RadioButton.Simple
                        |> RadioButton.withIsSelected (config.customModel.activeRadioButton == "second")
                        |> RadioButton.view [ disabled True ]
                    ]
          , {}
          )
        ]
