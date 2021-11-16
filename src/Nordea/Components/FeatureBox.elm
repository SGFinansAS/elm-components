module Nordea.Components.FeatureBox exposing (FeatureBox, init, view)

import Html.Styled
    exposing
        ( Html
        , div
        , h2
        , p
        , text
        )
import Nordea.Components.Accordion exposing (Msg)
import Nordea.Resources.Icons as Icons
import Svg.Styled as Svg exposing (Svg)


type alias Config msg =
    { showModal : Bool
    , closeMsg : msg
    , name : String
    , description : String
    , icon : Maybe (Svg msg)
    , button : Maybe (Html msg)
    }


type FeatureBox msg
    = FeatureBox (Config msg)


init : Bool -> msg -> String -> String -> FeatureBox msg
init showModal closeMsg name description =
    FeatureBox
        { showModal = showModal
        , closeMsg = closeMsg
        , name = name
        , description = description
        , icon = Nothing
        , button = Nothing
        }


view : FeatureBox msg -> Html msg
view (FeatureBox config) =
    div []
        [ Icons.confetti
        , h2 [] [ text config.name ]
        , p [] [ text config.description ]
        ]


withButton : Html msg -> FeatureBox msg -> FeatureBox msg
withButton button (FeatureBox config) =
    FeatureBox { config | button = Just button }


withIcon : Svg msg -> FeatureBox msg -> FeatureBox msg
withIcon icon (FeatureBox config) =
    FeatureBox { config | icon = Just icon }
