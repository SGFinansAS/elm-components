module Nordea.Components.FeatureBox exposing
    ( FeatureBox
    , init
    , view
    , withButton
    , withIcon
    )

import Css
    exposing
        ( alignItems
        , auto
        , backgroundColor
        , bottom
        , center
        , column
        , displayFlex
        , fixed
        , flexDirection
        , height
        , int
        , justifyContent
        , left
        , marginBottom
        , marginLeft
        , marginRight
        , marginTop
        , minWidth
        , none
        , outline
        , overflow
        , padding4
        , pct
        , position
        , pseudoClass
        , rem
        , textAlign
        , top
        , width
        , zIndex
        )
import Css.Global exposing (children, everything)
import Html.Styled
    exposing
        ( Html
        , div
        , h2
        , p
        , text
        )
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events exposing (onClick)
import Nordea.Components.Button as Button
import Nordea.Components.Card as Card
import Nordea.Components.Text as Text exposing (..)
import Nordea.Html as Html exposing (showIf)
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Icons as Icons
import Nordea.Themes as Themes
import Svg.Styled exposing (Svg)


type alias Config msg =
    { showFeatureBox : Bool
    , closeMsg : msg
    , name : String
    , description : String
    , icon : Maybe (Svg msg)
    , button : Maybe (Html msg)
    }


type FeatureBox msg
    = FeatureBox (Config msg)


init : Bool -> msg -> String -> String -> FeatureBox msg
init showFeatureBox closeMsg name description =
    FeatureBox
        { showFeatureBox = showFeatureBox
        , closeMsg = closeMsg
        , name = name
        , description = description
        , icon = Nothing
        , button = Nothing
        }


view : FeatureBox msg -> Html msg
view (FeatureBox config) =
    showIf config.showFeatureBox
        (div
            [ css
                [ position fixed
                , left (rem 0)
                , top (rem 0)
                , bottom (rem 0)
                , minWidth (pct 100)
                , outline none
                , overflow auto
                , displayFlex
                , justifyContent center
                , alignItems center
                , padding4 (rem 8) (rem 1) (rem 2) (rem 1)
                , backgroundColor (Colors.black |> Colors.withAlpha 0.5)
                , zIndex (int 1)
                ]
            ]
            [ Card.init
                |> Card.view
                    [ css
                        [ displayFlex
                        , alignItems center
                        , flexDirection column
                        , width (rem 20.5)
                        , children
                            [ everything
                                [ pseudoClass "not(:last-child)" [ marginBottom (rem 0.5) ] ]
                            ]
                        ]
                    ]
                    [ closeButton config.closeMsg
                    , config.icon
                        |> Html.viewMaybe (\icon -> icon)
                    , Text.titleHeavy
                        |> Text.withHtmlTag h2
                        |> Text.view [ css [ marginTop (rem 1.5) ] ] [ text config.name ]
                    , Text.bodyTextSmall
                        |> Text.withHtmlTag p
                        |> Text.view [ css [ textAlign center ] ] [ text config.description ]
                    , config.button
                        |> Html.viewMaybe
                            (\button ->
                                div [ css [ marginTop (rem 1), marginBottom (rem 1) ] ] [ button ]
                            )
                    ]
            ]
        )


withButton : Html msg -> FeatureBox msg -> FeatureBox msg
withButton button (FeatureBox config) =
    FeatureBox { config | button = Just button }


withIcon : Svg msg -> FeatureBox msg -> FeatureBox msg
withIcon icon (FeatureBox config) =
    FeatureBox { config | icon = Just icon }


closeButton : msg -> Html msg
closeButton closeMsg =
    Button.tertiary
        |> Button.view
            [ css [ alignItems center, marginLeft auto, marginRight (rem -1), marginTop (rem -0.5) ]
            , onClick closeMsg
            ]
            [ Icons.cross
                [ css
                    [ width (rem 1)
                    , height (rem 1)
                    , Themes.color Colors.blueDeep
                    ]
                ]
            ]
