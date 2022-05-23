module Stories.InformationDetails exposing (stories)

import Config exposing (Config, Msg(..))
import Css
import Html.Styled as Html
import Html.Styled.Attributes exposing (css)
import Nordea.Components.InformationDetails as InformationDetails
import Nordea.Resources.Colors as Colors
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI Config Msg {}
stories =
    styledStoriesOf
        "InformationDetails"
        [ ( "Regular"
          , \_ ->
                Html.div
                    [ css
                        [ Css.backgroundColor Colors.grayLight
                        , Css.padding (Css.rem 2)
                        ]
                    ]
                    [ InformationDetails.card []
                        [ InformationDetails.fullWidthElement []
                            [ InformationDetails.label [] [ Html.text "Full width" ]
                            , InformationDetails.value [] [ Html.text "Full width" ]
                            ]
                        , InformationDetails.element []
                            [ InformationDetails.label [] [ Html.text "Noe" ]
                            , InformationDetails.value [] [ Html.text "Noe" ]
                            ]
                        , InformationDetails.element []
                            [ InformationDetails.label [] [ Html.text "Noe mer" ]
                            , InformationDetails.value [] [ Html.text "Noe mer" ]
                            ]
                        , InformationDetails.element []
                            [ InformationDetails.label [] [ Html.text "Enda mer" ]
                            , InformationDetails.value [] [ Html.text "Enda mer" ]
                            ]
                        , InformationDetails.fullWidthElement []
                            [ InformationDetails.label []
                                [ Html.text "Label"
                                ]
                            , InformationDetails.value [] [ Html.text "1" ]
                            , InformationDetails.value [] [ Html.text "2" ]
                            , InformationDetails.value [] [ Html.text "3" ]
                            ]
                        ]
                        (Just "Title")
                    ]
          , {}
          )
        ]
