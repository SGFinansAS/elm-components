module Nordea.Components.Modal exposing
    ( ViewConfig
    , header
    , view
    )

import Css
    exposing
        ( alignItems
        , auto
        , backgroundColor
        , borderBottom3
        , borderRadius
        , bottom
        , center
        , column
        , displayFlex
        , fixed
        , flexDirection
        , hidden
        , int
        , justifyContent
        , left
        , marginLeft
        , maxWidth
        , minWidth
        , none
        , outline
        , overflow
        , padding
        , padding4
        , pct
        , position
        , rem
        , solid
        , top
        , zIndex
        , margin
        )
import Css.Global as Global
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes exposing (attribute, css, tabindex)
import Html.Styled.Events as Events exposing (keyCode, on)
import Json.Decode as Json
import Nordea.Components.Button as NordeaButton
import Nordea.Components.Text as Text
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Icons as Icons
import Nordea.Themes as Themes
import Css.Media as Media


type alias ViewConfig msg =
    { onClickClose : msg
    , title : String
    }


view : ViewConfig msg -> List (Attribute msg) -> List (Html msg) -> Html msg
view config attrs children =
    let
        card =
            Html.div
                (attribute "role" "dialog"
                    :: attribute "aria-modal" "true"
                    :: css
                        [ borderRadius (rem 0)
                        , backgroundColor Colors.white
                        , displayFlex
                        , flexDirection column
                        , minWidth (rem 18)
                        , maxWidth (rem 60)
                        , margin (auto)
                        , Media.withMedia
                            [ Media.only Media.screen [ Media.minWidth (rem 47) ] ]
                            [ borderRadius (rem 0.5) ]
                        ]
                    :: attrs
                )
                [ header config.onClickClose config.title, contentContainer [] children ]
    in
    Html.div
        [ onEscPress config.onClickClose
        , tabindex 0
        , css
            [ position fixed
            , left (rem 0)
            , top (rem 0)
            , bottom (rem 0)
            , outline none
            , overflow auto
            , displayFlex
            , minWidth (pct 100)
            , justifyContent center
            , alignItems center
            , padding (rem 0)
            , backgroundColor (Colors.black |> Colors.withAlpha 0.5)
            , zIndex (int 1)
            , Media.withMedia
                [ Media.only Media.screen [ Media.minWidth (rem 47) ] ]
                [ padding4 (rem 8) (rem 1) (rem 2) (rem 1) ]
            ]
        ]
        [ card, disableScrollOnBody ]


header : msg -> String -> Html msg
header onClickMsg title =
    let
        cross onClick =
            NordeaButton.tertiary
                |> NordeaButton.view
                    [ Events.onClick onClick, css [ alignItems center, marginLeft auto ] ]
                    [ Icons.cross
                        [ css [ Themes.color Themes.PrimaryColor Colors.blueDeep ] ]
                    ]
    in
    Html.div
        [ css
            [ padding4 (rem 1.5) (rem 1.5) (rem 1.5) (rem 2.5)
            , alignItems center
            , borderBottom3 (rem 0.0625) solid Colors.grayCool
            , displayFlex
            ]
        ]
        [ Text.headlineFourHeavy
            |> Text.view [] [ Html.text title ]
        , cross onClickMsg
        ]


contentContainer : List (Attribute msg) -> List (Html msg) -> Html msg
contentContainer attrs children =
    Html.div (css [ padding (rem 2.5), displayFlex, flexDirection column ] :: attrs) children


disableScrollOnBody : Html msg
disableScrollOnBody =
    Global.global [ Global.body [ overflow hidden ] ]


onEscPress : msg -> Attribute msg
onEscPress msg =
    let
        isEnter code =
            if code == 27 then
                Json.succeed msg

            else
                Json.fail "not ESC"
    in
    on "keydown" (Json.andThen isEnter keyCode)
