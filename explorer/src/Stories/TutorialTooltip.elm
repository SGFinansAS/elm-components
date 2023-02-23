module Stories.TutorialTooltip exposing (stories)

import Config exposing (Config, Msg(..))
import Css exposing (backgroundColor, display, displayFlex, flexBasis, height, none, pct, rem, width)
import Html.Styled as Html
import Html.Styled.Attributes exposing (class, css)
import Html.Styled.Events as Events
import Nordea.Components.FlatLink as FlatLink
import Nordea.Components.Tooltip as Tooltip
import Nordea.Components.TutorialTooltip as TutorialTooltip
import Nordea.Resources.Icons as Icons
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI Config Msg {}
stories =
    styledStoriesOf
        "TutorialTooltip"
        [ ( "Standard"
          , \config ->
                Html.div [ css [ displayFlex ] ]
                    [ Html.div
                        [ class "omgash"
                        , css [ height (rem 2), width (rem 10), backgroundColor (Css.hex "#FF0000") ]
                        ]
                        []
                    , TutorialTooltip.view
                        { translate = .no
                        , onClickOpen = UpdateCouchMarkPage (Just 0)
                        , onClickClose = UpdateCouchMarkPage Nothing
                        }
                        [ TutorialTooltip.HighlightedClass "omgash"
                        , TutorialTooltip.Placement Tooltip.Right
                        , TutorialTooltip.ShowPage config.customModel.showCoachMarkPage
                        , TutorialTooltip.ShowStepLegend True
                        ]
                        []
                        [ TutorialTooltip.page
                            [ TutorialTooltip.nextButton [ Events.onClick (UpdateCouchMarkPage (Just 1)) ] [ Html.text "Start" ] ]
                            []
                            [ Html.span [] [ Html.text ("Page 0. " ++ lorem) ] ]
                        , TutorialTooltip.page
                            [ TutorialTooltip.nextButton [ Events.onClick (UpdateCouchMarkPage (Just 2)) ] [ Html.text "Next" ] ]
                            []
                            [ Html.span [] [ Html.text ("Page 1. " ++ lorem) ] ]
                        , TutorialTooltip.page
                            [ TutorialTooltip.nextButton [ Events.onClick (UpdateCouchMarkPage (Just 3)) ] [ Html.text "Next" ] ]
                            []
                            [ Html.span [] [ Html.text ("Page 2. " ++ lorem) ] ]
                        , TutorialTooltip.page
                            [ TutorialTooltip.nextButton [ Events.onClick (UpdateCouchMarkPage Nothing) ] [ Html.text "Close" ] ]
                            []
                            [ Html.span [] [ Html.text ("Page 3. " ++ lorem) ] ]
                        ]
                    ]
          , {}
          )
        ]


lorem =
    "Lorem Ipsum is simply dummy text of the printing and typesetting industry."
