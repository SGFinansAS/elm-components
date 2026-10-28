module Stories.Coachmark exposing (stories)

import Config exposing (Config, Msg(..))
import Css exposing (displayFlex, rem)
import Html.Styled as Html
import Html.Styled.Attributes exposing (class, css)
import Nordea.Components.Button as Button
import Nordea.Components.Coachmark as Coachmark
import Nordea.Components.Tooltip as Tooltip
import Nordea.Css exposing (gap)
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI Config Msg {}
stories =
    styledStoriesOf
        "Coachmark"
        [ ( "Standard"
          , \config ->
                Html.div [ css [ displayFlex, gap (rem 1) ] ]
                    [ Button.secondary
                        |> Button.view [ class "new-button" ] [ Html.text "Some new feature button" ]
                    , Coachmark.view
                        { translate = .no
                        , onChangeStep = UpdateCoachmarkStep
                        , ariaLabel = "New feature introduction"
                        }
                        [ Coachmark.HighlightedClass "new-button"
                        , Coachmark.Placement Tooltip.Right
                        , Coachmark.ShowStep config.customModel.showCoachMarkStep
                        ]
                        []
                        [ Coachmark.step [] [ Html.text ("step 0. " ++ lorem) ]
                        , Coachmark.step [] [ Html.text ("step 1. " ++ lorem) ]
                        , Coachmark.step [] [ Html.text ("step 2. " ++ lorem) ]
                        , Coachmark.step [] [ Html.text ("step 3. " ++ lorem) ]
                        ]
                    ]
          , {}
          )
        ]


lorem =
    "Lorem Ipsum is simply dummy text of the printing and typesetting industry."
