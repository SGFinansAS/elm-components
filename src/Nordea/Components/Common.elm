module Nordea.Components.Common exposing (..)

import Css exposing (alignItems, auto, center, color, displayFlex, flex, flexBasis, fontFamilies, fontSize, justifyContent, lineHeight, marginBottom, marginLeft, marginRight, marginTop, none, pct, rem, spaceBetween)
import Html.Styled as Html exposing (Attribute, Html, div, styled, text)
import Html.Styled.Attributes exposing (css)
import Maybe.Extra as Maybe
import Nordea.Html as Html exposing (showIf)
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Icons as Icons


type RequirednessHint
    = Mandatory ({ no : String, se : String, dk : String } -> String)
    | Optional ({ no : String, se : String, dk : String } -> String)
    | Custom String


type alias InputProperties =
    { labelText : String
    , requirednessHint : Maybe RequirednessHint
    , showFocusOutline : Bool
    , errorMessage : Maybe String
    , hintText : Maybe String
    , charCounter : Maybe CharCounter
    }


type alias CharCounter =
    { current : Int
    , max : Int
    }


bodyText : List (Attribute msg) -> List (Html msg) -> Html msg
bodyText =
    styled Html.span
        [ fontSize (rem 0.875)
        , fontFamilies [ "Nordea Sans Small" ]
        , lineHeight (rem 1.5)
        , color Colors.black
        ]


bottomInfo : InputProperties -> List (Html msg)
bottomInfo config =
    let
        charCounterView =
            config.charCounter
                |> Html.viewMaybe
                    (\charCounter ->
                        bodyText [ css [ marginLeft auto, color Colors.grayDark |> Css.important ] ]
                            [ String.fromInt charCounter.current ++ "/" ++ String.fromInt charCounter.max |> text ]
                    )
    in
    [ div [ css [ displayFlex, flexBasis (pct 100), justifyContent spaceBetween, marginTop (rem 0.5), Css.property "gap" "1rem" ] ]
        [ config.errorMessage
            |> Html.viewMaybe
                (\errText ->
                    div
                        [ css
                            [ displayFlex
                            , alignItems center
                            , color Colors.redDark
                            , fontSize (rem 0.875)
                            ]
                        ]
                        [ Icons.error [ css [ marginRight (rem 0.5), flex none ] ]
                        , text errText
                        ]
                )
        , charCounterView
        ]
        |> showIf (Maybe.isJust config.errorMessage)
    , div [ css [ displayFlex, flexBasis (pct 100), justifyContent spaceBetween, marginTop (rem 0.5), Css.property "gap" "1rem" ] ]
        [ config.hintText
            |> Html.viewMaybe
                (\hintText ->
                    Html.div [ css [ color Colors.grayDark, fontSize (rem 0.875) ] ] [ text hintText ]
                )
        , charCounterView |> showIf (Maybe.isNothing config.errorMessage)
        ]
        |> showIf (Maybe.isJust config.hintText || Maybe.isJust config.charCounter)
    ]


topInfo : InputProperties -> Html msg
topInfo config =
    let
        textStyle =
            if Maybe.isJust config.errorMessage then
                color Colors.redDark |> Css.important

            else
                color Colors.black

        toI18NString requirednessHint =
            case requirednessHint of
                Mandatory translate ->
                    translate strings.mandatory

                Optional translate ->
                    translate strings.optional

                Custom string ->
                    string
    in
    div [ css [ displayFlex, justifyContent spaceBetween, marginBottom (rem 0.5) ] ]
        [ bodyText [ css [ textStyle ] ] [ text config.labelText ]
        , config.requirednessHint
            |> Html.viewMaybe
                (\requirednessHint ->
                    bodyText
                        [ css [ color Colors.grayDark |> Css.important ] ]
                        [ requirednessHint |> toI18NString |> text ]
                )
        ]


strings =
    { mandatory =
        { no = "Obligatorisk"
        , se = "Obligatoriskt"
        , dk = "Obligatorisk"
        }
    , optional =
        { no = "Valgfritt"
        , se = "Valfritt"
        , dk = "Valgfrit"
        }
    }
