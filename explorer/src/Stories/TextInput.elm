module Stories.TextInput exposing (stories)

import Config exposing (Msg(..))
import Html.Styled.Attributes exposing (disabled)
import Nordea.Components.TextInput as TextInput
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI Config.Config Msg {}
stories =
    styledStoriesOf
        "TextInput"
        [ ( "Default"
          , \_ ->
                TextInput.init "Text"
                    |> TextInput.view []
          , {}
          )
        , ( "Default (Disabled)"
          , \_ ->
                TextInput.init "Text"
                    |> TextInput.withInputAttrs [ disabled True ]
                    |> TextInput.view []
          , {}
          )
        , ( "Placeholder"
          , \_ ->
                TextInput.init ""
                    |> TextInput.withPlaceholder "Text"
                    |> TextInput.view []
          , {}
          )
        , ( "Max length 3"
          , \_ ->
                TextInput.init ""
                    |> TextInput.withPlaceholder "Type something"
                    |> TextInput.withMaxLength 3
                    |> TextInput.view []
          , {}
          )
        , ( "Pattern only digits"
          , \_ ->
                TextInput.init ""
                    |> TextInput.withPlaceholder "Type something"
                    |> TextInput.withPattern "\\d*"
                    |> TextInput.view []
          , {}
          )
        , ( "Error"
          , \_ ->
                TextInput.init "Text"
                    |> TextInput.withError True
                    |> TextInput.view []
          , {}
          )
        , ( "Disabled"
          , \_ ->
                TextInput.init "Text"
                    |> TextInput.withInputAttrs [ disabled True ]
                    |> TextInput.view []
          , {}
          )
        , ( "With search icon"
          , \_ ->
                TextInput.init "Text"
                    |> TextInput.withSearchIcon True
                    |> TextInput.withCurrency "EUR"
                    |> TextInput.view []
          , {}
          )
        , ( "With currency"
          , \_ ->
                TextInput.init "Text"
                    |> TextInput.withCurrency "EUR"
                    |> TextInput.view []
          , {}
          )
        , ( "With cancel icon"
          , \model ->
                TextInput.init model.customModel.textInputContent
                    |> TextInput.withClearInput
                    |> TextInput.withOnInput TextInputContentChange
                    |> TextInput.view []
          , {}
          )
        , ( "Small"
          , \_ ->
                TextInput.init "Text"
                    |> TextInput.withSmallSize
                    |> TextInput.view []
          , {}
          )
        , ( "Small with search icon"
          , \_ ->
                TextInput.init "Text"
                    |> TextInput.withSearchIcon True
                    |> TextInput.withSmallSize
                    |> TextInput.view []
          , {}
          )
        ]
