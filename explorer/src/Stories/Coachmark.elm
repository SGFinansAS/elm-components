module Stories.Coachmark exposing (stories)

import Config exposing (Config, Msg(..))
import Css exposing (backgroundColor, displayFlex, height, rem, width)
import Html.Styled as Html
import Html.Styled.Attributes exposing (class, css)
import Html.Styled.Events as Events
import Nordea.Components.Coachmark as Coachmark
import Nordea.Components.Tooltip as Tooltip
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI Config Msg {}
stories =
    styledStoriesOf
        "Coachmark"
        [ ( "Standard"
          , \config ->
                Html.div [ css [ displayFlex ] ]
                    [ Html.div
                        [ class "omgash"
                        , css [ height (rem 2), width (rem 10), backgroundColor (Css.hex "#FF0000") ]
                        ]
                        []
                    , Coachmark.view
                        { translate = .no
                        , onClickOpen = UpdateCouchMarkPage (Just 0)
                        , onClickClose = UpdateCouchMarkPage Nothing
                        }
                        [ Coachmark.HighlightedClass "omgash"
                        , Coachmark.Placement Tooltip.Right
                        , Coachmark.ShowPage config.customModel.showCoachMarkPage
                        , Coachmark.ShowStepLegend True
                        ]
                        []
                        [ Coachmark.page
                            [ Coachmark.nextButton [ Events.onClick (UpdateCouchMarkPage (Just 1)) ] [ Html.text "Start" ] ]
                            []
                            [ Html.span [] [ Html.text ("Page 0. " ++ lorem) ] ]
                        , Coachmark.page
                            [ Coachmark.nextButton [ Events.onClick (UpdateCouchMarkPage (Just 2)) ] [ Html.text "Next" ] ]
                            []
                            [ Html.span [] [ Html.text ("Page 1. " ++ lorem) ] ]
                        , Coachmark.page
                            [ Coachmark.nextButton [ Events.onClick (UpdateCouchMarkPage (Just 3)) ] [ Html.text "Next" ] ]
                            []
                            [ Html.span [] [ Html.text ("Page 2. " ++ lorem) ] ]
                        , Coachmark.page
                            [ Coachmark.nextButton [ Events.onClick (UpdateCouchMarkPage Nothing) ] [ Html.text "Close" ] ]
                            []
                            [ Html.span [] [ Html.text ("Page 3. " ++ lorem) ] ]
                        ]
                    ]
          , {}
          )
        ]


lorem =
    "Lorem Ipsum is simply dummy text of the printing and typesetting industry."
