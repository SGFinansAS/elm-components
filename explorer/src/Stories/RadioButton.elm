module Stories.RadioButton exposing (stories)

import Config exposing (Config, Msg(..))
import Css exposing (displayFlex, rem)
import Html.Styled as Html exposing (text)
import Html.Styled.Attributes exposing (css, disabled)
import Nordea.Components.RadioButton as RadioButton
import Nordea.Css exposing (gap)
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI Config Msg {}
stories =
    styledStoriesOf
        "RadioButton"
        [ ( "Standard"
          , \config ->
                Html.div [ css [ displayFlex, gap (rem 1) ] ]
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
                Html.div [ css [ displayFlex, gap (rem 1) ] ]
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
                Html.div [ css [ displayFlex, gap (rem 1) ] ]
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
        , ( "Small"
          , \config ->
                Html.div [ css [ displayFlex, gap (rem 1) ] ]
                    [ RadioButton.init
                        "small"
                        (text "Click me")
                        (UpdateActiveRadioButton "first")
                        |> RadioButton.withIsSelected (config.customModel.activeRadioButton == "first")
                        |> RadioButton.withAppearance RadioButton.Small
                        |> RadioButton.view []
                    , RadioButton.init
                        "small"
                        (text "Click me")
                        (UpdateActiveRadioButton "second")
                        |> RadioButton.withIsSelected (config.customModel.activeRadioButton == "second")
                        |> RadioButton.withAppearance RadioButton.Small
                        |> RadioButton.view []
                    ]
          , {}
          )
        , ( "Simple"
          , \config ->
                Html.div [ css [ displayFlex, gap (rem 1) ] ]
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
                Html.div [ css [ displayFlex, gap (rem 1) ] ]
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
                Html.div [ css [ displayFlex, gap (rem 1) ] ]
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
