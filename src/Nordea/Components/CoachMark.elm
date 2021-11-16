module Nordea.Components.CoachMark exposing (..)

import Css exposing (backgroundColor, batch, borderLeft3, borderRadius, borderRight3, borderTop3, color, deg, displayFlex, height, justifyContent, margin2, marginBottom, marginTop, padding, position, relative, rem, rotate, solid, spaceBetween, transform, transparent, width)
import Html.Styled as Html exposing (Html, a)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events exposing (onClick)
import Maybe.Extra as Maybe
import Nordea.Components.Button as Button
import Nordea.Components.Text as Text
import Nordea.Html as Html
import Nordea.Resources.Colors as Colors


type Arrow
    = Top
    | Right
    | Bottom
    | Left


type alias CoachMarkProperties =
    { title : Maybe String
    , bodyText : Maybe String
    , currentStep : Maybe Int
    , totalSteps : Maybe Int
    , arrowPlacement : Maybe Arrow
    }


type CoachMark
    = CoachMark CoachMarkProperties


init : CoachMark
init =
    CoachMark
        { title = Nothing
        , bodyText = Nothing
        , currentStep = Nothing
        , totalSteps = Nothing
        , arrowPlacement = Nothing
        }


view : List (Html msg) -> CoachMark -> Html msg
view navButtons (CoachMark config) =
    Html.div [ css [ position relative ] ]
        [ Html.div
            [ css
                [ backgroundColor Colors.grayDarkest
                , padding (rem 1.5)
                , width (rem 20.5)
                , borderRadius (rem 0.5)
                ]
            ]
            [ Html.div [ css [ displayFlex, justifyContent spaceBetween ] ]
                [ Text.titleHeavy
                    |> Text.view [ css [ color Colors.white, marginBottom (rem 0.25) ] ] [ Html.text (config.title |> Maybe.withDefault "") ]
                , if (config.currentStep |> Maybe.isJust) && (config.totalSteps |> Maybe.isJust) then
                    steps (CoachMark config)

                  else
                    Html.text ""
                ]
            , Text.bodyTextLight |> Text.view [ css [ color Colors.grayLight ] ] [ Html.text (config.bodyText |> Maybe.withDefault "") ]
            , Html.div [ css [ height (rem 2.5), marginTop (rem 1.5), displayFlex, justifyContent spaceBetween ] ] navButtons
            ]
        , triangle config.arrowPlacement
        ]


steps (CoachMark config) =
    Text.bodyTextLight
        |> Text.view [ css [ color Colors.grayMedium ] ]
            [ config.currentStep |> Html.viewMaybe (\step -> Html.text (step |> String.fromInt))
            , Html.text "/"
            , config.totalSteps |> Html.viewMaybe (\step -> Html.text (step |> String.fromInt))
            ]


triangle : Maybe Arrow -> Html msg
triangle arrow =
    let
        baseStyle =
            batch
                [ width (rem 0)
                , height (rem 0)
                , borderLeft3 (rem 1.5) solid transparent
                , borderRight3 (rem 1.5) solid transparent
                , borderTop3 (rem 1.5) solid Colors.grayDarkest
                ]
    in
    case arrow of
        Just Top ->
            Html.div
                [ css
                    [ baseStyle
                    , transform (rotate (deg -180))
                    ]
                ]
                []

        Just Right ->
            Html.div
                [ css
                    [ baseStyle
                    , transform (rotate (deg -90))
                    ]
                ]
                []

        Just Bottom ->
            Html.div
                [ css
                    [ baseStyle
                    ]
                ]
                []

        Just Left ->
            Html.div
                [ css
                    [ baseStyle
                    , transform (rotate (deg 90))
                    ]
                ]
                []

        Nothing ->
            Html.text ""


withTitle : String -> CoachMark -> CoachMark
withTitle title (CoachMark config) =
    CoachMark { config | title = Just title }


withBodyText : String -> CoachMark -> CoachMark
withBodyText bodyText (CoachMark config) =
    CoachMark { config | bodyText = Just bodyText }


withSteps : Int -> Int -> CoachMark -> CoachMark
withSteps currentStep totalSteps (CoachMark config) =
    CoachMark { config | currentStep = Just currentStep, totalSteps = Just totalSteps }


withArrow : Arrow -> CoachMark -> CoachMark
withArrow arrowPlacement (CoachMark config) =
    CoachMark { config | arrowPlacement = Just arrowPlacement }
