module Nordea.Components.Modal exposing
    ( init
    , view
    , withTitle
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
        , margin
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
        , textAlign
        , top
        , zIndex
        )
import Css.Global as Global
import Css.Media as Media
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes exposing (attribute, css, tabindex)
import Html.Styled.Events as Events exposing (keyCode, on)
import Json.Decode as Json
import Nordea.Components.Button as NordeaButton
import Nordea.Components.Text as Text
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Icons as Icons
import Nordea.Themes as Themes


type alias ViewConfig msg =
    { onClickClose : msg
    , title : Maybe String
    }


type Modal msg
    = Modal (ViewConfig msg)


init : msg -> Modal msg
init onClickClose =
    Modal
        { onClickClose = onClickClose
        , title = Nothing
        }


view : List (Attribute msg) -> List (Html msg) -> Modal msg -> Html msg
view attrs children (Modal config) =
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
                        , margin auto
                        , Media.withMedia
                            [ Media.only Media.screen [ Media.minWidth (rem 47) ] ]
                            [ borderRadius (rem 0.5) ]
                        ]
                    :: attrs
                )
                [ header (config.title |> Maybe.withDefault "") config.onClickClose, contentContainer (config.title |> Maybe.withDefault "") [] children ]
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


header : String -> msg -> Html msg
header title onClickMsg =
    let
        cross onClick =
            NordeaButton.tertiary
                |> NordeaButton.view
                    [ Events.onClick onClick, css [ alignItems center, marginLeft auto ] ]
                    [ Icons.cross
                        [ css [ Themes.color Themes.PrimaryColor Colors.blueDeep, Css.width (rem 1.385) ] ]
                    ]
    in
    if not (title |> String.isEmpty) then
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

    else
        Html.div
            [ css
                [ padding4 (rem 1.5) (rem 1.5) (rem 0) (rem 2.5)
                , alignItems center
                , displayFlex
                ]
            ]
            [ cross onClickMsg ]


contentContainer : String -> List (Attribute msg) -> List (Html msg) -> Html msg
contentContainer title attrs children =
    if not (title |> String.isEmpty) then
        Html.div (css [ padding (rem 2.5), displayFlex, flexDirection column ] :: attrs) children

    else
        Html.div (css [ padding4 (rem 0.5) (rem 2.5) (rem 2.5) (rem 2.5), displayFlex, flexDirection column, textAlign center ] :: attrs) children


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


withTitle : String -> Modal msg -> Modal msg
withTitle title (Modal config) =
    Modal { config | title = Just title }
