module Explorer exposing (main)

import Config exposing (Config, Msg(..))
import Html exposing (Html)
import Html.Styled exposing (toUnstyled)
import Nordea.Resources.Fonts.Fonts as Fonts
import Stories.Accordion as Accordion
import Stories.Badge as Badge
import Stories.Button as Button
import Stories.Card as Card
import Stories.Checkbox as Checkbox
import Stories.Colors as Colors
import Stories.Dropdown as Dropdown
import Stories.DropdownFilter as Search
import Stories.Error as Error
import Stories.FeatureBox as FeatureBox
import Stories.FileDownload as FileDownload
import Stories.FileUpload as FileUpload
import Stories.FilterChip as FilterChip
import Stories.FlatLink as FlatLink
import Stories.Hamburger as Hamburger
import Stories.Icons as Icons
import Stories.InfoBanner as InfoBanner
import Stories.InfoPanel as InfoPanel
import Stories.InformationDetails as InformationDetails
import Stories.Label as Label
import Stories.LottiePlayer as LottiePlayer
import Stories.Modal as Modal
import Stories.MultiSelectDropdown as MultiSelectDropdown
import Stories.NumberInput as NumberInput
import Stories.ProgressBar as ProgressBar
import Stories.ProgressBarStepper as ProgressBarStepper
import Stories.RadioButton as RadioButton
import Stories.Range as Range
import Stories.Slider as Slider
import Stories.Spinner as Spinner
import Stories.Status as Status
import Stories.StepIndicator as StepIndicator
import Stories.Table as Table
import Stories.Tabs as Tabs
import Stories.Text as Text
import Stories.TextArea as TextArea
import Stories.TextInput as TextInput
import Stories.Toggle as Toggle
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
                [ Colors.stories
                , Text.stories
                , Icons.stories
                ]
            |> UIExplorer.category "Components"
                [ Accordion.stories
                , Badge.stories
                , Button.stories
                , Card.stories
                , Checkbox.stories
                , Dropdown.stories
                , MultiSelectDropdown.stories
                , Search.stories
                , Error.stories
                , FeatureBox.stories
                , FileDownload.stories
                , FileUpload.stories
                , FilterChip.stories
                , FlatLink.stories
                , Hamburger.stories
                , InfoBanner.stories
                , InfoPanel.stories
                , InformationDetails.stories
                , Label.stories
                , LottiePlayer.stories
                , Modal.stories
                , NumberInput.stories
                , ProgressBar.stories
                , ProgressBarStepper.stories
                , RadioButton.stories
                , Range.stories
                , Slider.stories
                , Spinner.stories
                , Status.stories
                , StepIndicator.stories
                , Table.stories
                , Tabs.stories
                , TextArea.stories
                , TextInput.stories
                , Toggle.stories
                , Tooltip.stories
                ]
        )
