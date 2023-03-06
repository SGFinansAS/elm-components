module Nordea.Components.Modal exposing
    ( default
    , newsModal
    , view
    , withSubtitle
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
        , color
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
        , padding3
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
import Nordea.Html exposing (viewMaybe)
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Icons as Icons
import Nordea.Themes as Themes


type Variant
    = DefaultModal
    | NewsModal


type alias Config msg =
    { variant : Variant
    , onClickClose : msg
    , title : Maybe String
    , subtitle : Maybe String
    }


type Modal msg
    = Modal (Config msg)


init : msg -> Variant -> Modal msg
init onClickClose variant =
    Modal
        { variant = variant
        , onClickClose = onClickClose
        , title = Nothing
        , subtitle = Nothing
        }


default : msg -> Modal msg
default msg =
    init msg DefaultModal


newsModal : msg -> Modal msg
newsModal msg =
    init msg NewsModal


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
                [ header config.variant config.title config.onClickClose
                , contentContainer config.variant config.title config.subtitle [] children
                ]
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


header : Variant -> Maybe String -> msg -> Html msg
header variant title onClickMsg =
    let
        cross onClick =
            NordeaButton.tertiary
                |> NordeaButton.view
                    [ Events.onClick onClick, css [ alignItems center, marginLeft auto ] ]
                    [ Icons.cross
                        [ css [ Themes.color Colors.blueDeep, Css.width (rem 1.385) ] ]
                    ]
    in
    case variant of
        DefaultModal ->
            Html.div
                [ css
                    [ padding4 (rem 1.5) (rem 1.5) (rem 1.5) (rem 2.5)
                    , alignItems center
                    , borderBottom3 (rem 0.0625) solid Colors.grayCool
                    , displayFlex
                    ]
                ]
                [ title
                    |> viewMaybe
                        (\text ->
                            Text.titleHeavy
                                |> Text.view [] [ Html.text text ]
                        )
                , cross onClickMsg
                ]

        NewsModal ->
            Html.div
                [ css
                    [ padding4 (rem 1) (rem 1.5) (rem 0) (rem 2.5)
                    , alignItems center
                    , displayFlex
                    ]
                ]
                [ cross onClickMsg
                ]


contentContainer : Variant -> Maybe String -> Maybe String -> List (Attribute msg) -> List (Html msg) -> Html msg
contentContainer variant title subTitle attrs children =
    let
        newsTitle =
            Html.div []
                [ subTitle
                    |> viewMaybe
                        (\text ->
                            Text.textTinyLight
                                |> Text.view [ css [ color Colors.nordeaGray ] ] [ Html.text text ]
                        )
                , title
                    |> viewMaybe
                        (\text ->
                            Text.titleHeavy
                                |> Text.view [ css [ padding3 (rem 0.5) (rem 0) (rem 2) ] ] [ Html.text text ]
                        )
                ]
    in
    case variant of
        DefaultModal ->
            Html.div (css [ padding (rem 2.5), displayFlex, flexDirection column ] :: attrs) children

        NewsModal ->
            Html.div (css [ padding4 (rem 0) (rem 2.5) (rem 3.5) (rem 2.5), displayFlex, flexDirection column, textAlign center ] :: attrs)
                (newsTitle
                    :: children
                )


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


withSubtitle : String -> Modal msg -> Modal msg
withSubtitle subtitle (Modal config) =
    Modal { config | subtitle = Just subtitle }
