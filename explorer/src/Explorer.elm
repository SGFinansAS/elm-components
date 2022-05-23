module Explorer exposing (main)

import Config exposing (Config, Msg(..))
import Html exposing (Html)
import Html.Styled exposing (toUnstyled)
import Nordea.Resources.Fonts as Fonts
import Stories.Accordion as Accordion
import Stories.Button as Button
import Stories.Card as Card
import Stories.Checkbox as Checkbox
import Stories.Dropdown as Dropdown
import Stories.DropdownFilter as Search
import Stories.Error as Error
import Stories.FeatureBox as FeatureBox
import Stories.FileUpload as FileUpload
import Stories.FlatLink as FlatLink
import Stories.Icons as Icons
import Stories.InfoLabel as InfoLabel
import Stories.InfoPanel as InfoPanel
import Stories.InformationDetails as InformationDetails
import Stories.Label as Label
import Stories.LottiePlayer as LottiePlayer
import Stories.Modal as Modal
import Stories.NumberInput as NumberInput
import Stories.ProgressBar as ProgressBar
import Stories.ProgressBarStepper as ProgressBarStepper
import Stories.RadioButton as RadioButton
import Stories.Spinner as Spinner
import Stories.Status as Status
import Stories.StepIndicator as StepIndicator
import Stories.Table as Table
import Stories.Text as Header
import Stories.TextArea as TextArea
import Stories.TextInput as TextInput
import Stories.Tooltip as Tooltip
import UIExplorer exposing (UIExplorerProgram)


type alias Model =
    UIExplorer.Model Config Msg {}


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( { model | customModel = Config.update msg model.customModel }, Cmd.none )


viewEnhancer : a -> Html msg -> Html msg
viewEnhancer _ stories =
    Html.div []
        [ Fonts.globalStyle "/fonts" |> toUnstyled
        , stories
        ]


main : UIExplorerProgram Config Msg {} ()
main =
    UIExplorer.exploreWithCategories
        { customModel = Config.init
        , customHeader = Nothing
        , update = update
        , init = \() a -> a
        , enableDarkMode = False
        , subscriptions = \_ -> Sub.none
        , viewEnhancer = viewEnhancer
        , menuViewEnhancer = \_ v -> v
        , onModeChanged = Nothing
        , documentTitle = Nothing
        }
        (UIExplorer.createCategories
            |> UIExplorer.category "Tokens"
                [ Header.stories
                , Icons.stories
                ]
            |> UIExplorer.category "Components"
                [ Accordion.stories
                , Button.stories
                , Card.stories
                , Checkbox.stories
                , Dropdown.stories
                , Search.stories
                , Error.stories
                , FeatureBox.stories
                , FileUpload.stories
                , FlatLink.stories
                , InfoLabel.stories
                , InfoPanel.stories
                , InformationDetails.stories
                , Label.stories
                , LottiePlayer.stories
                , Modal.stories
                , NumberInput.stories
                , ProgressBar.stories
                , ProgressBarStepper.stories
                , RadioButton.stories
                , Spinner.stories
                , Status.stories
                , StepIndicator.stories
                , Table.stories
                , TextArea.stories
                , TextInput.stories
                , Tooltip.stories
                ]
        )
