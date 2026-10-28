module Stories.Toggle exposing (stories)

import Config exposing (Config, Msg(..))
import Css exposing (column, cursor, displayFlex, flexDirection, pointer, rem)
import Html.Styled as Html exposing (div)
import Html.Styled.Attributes as Attributes exposing (css, disabled)
import Nordea.Components.Text as Text
import Nordea.Components.Toggle as Toggle
import Nordea.Css exposing (rowGap)
import Nordea.Html as Html
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI Config Msg {}
stories =
    let
        toggle checked attrs extra =
            Toggle.init "Hey" (\_ -> ToggleToggle)
                |> Toggle.withIsChecked checked
                |> Toggle.view attrs extra
    in
    styledStoriesOf
        "Toggle"
        [ ( "Toggle"
          , \model ->
                let
                    checked =
                        model.customModel.isToggled

                    customId =
                        "custom-toggle-input"
                in
                div [ css [ displayFlex, flexDirection column, rowGap (rem 1) ] ]
                    [ Toggle.init "Hey" (\_ -> ToggleToggle)
                        |> Toggle.withIsChecked checked
                        |> Toggle.withInputAttrs [ Attributes.attribute "aria-label" "Input must have some labelling" ]
                        |> Toggle.view [] []
                    , toggle checked [] [ "With toggle label" |> Html.text ]
                    , Toggle.init "Hey" (\_ -> ToggleToggle)
                        |> Toggle.withIsChecked checked
                        |> Toggle.withHtmlTag Html.row
                        |> Toggle.withInputAttrs [ Attributes.id customId ]
                        |> Toggle.view [ css [ displayFlex, flexDirection column ] ]
                            [ Html.column [ css [ rowGap (rem 1) ] ]
                                [ Text.textHeavy
                                    |> Text.withHtmlTag Html.label
                                    |> Text.view [ Attributes.for customId, css [ cursor pointer ] ]
                                        [ "Separate label with embedded toggle:" |> Html.text ]
                                , Text.textTiny |> Text.view [] [ "(HTML doesn't allow nesting labels)" |> Html.text ]
                                , Toggle.init "embedded" (\_ -> ToggleToggle)
                                    |> Toggle.withIsChecked checked
                                    |> Toggle.view [] [ "I'm on a separate label" |> Html.text ]
                                ]
                            ]
                    ]
          , {}
          )
        , ( "Toggle (Disabled)"
          , \model ->
                div [] [ toggle model.customModel.isToggled [ disabled True ] [ "Disabled" |> Html.text ] ]
          , {}
          )
        ]
