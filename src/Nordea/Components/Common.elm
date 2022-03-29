module Nordea.Components.Common exposing (..)

import Css
    exposing
        ( alignItems
        , auto
        , center
        , color
        , displayFlex
        , flex
        , flexBasis
        , justifyContent
        , marginBottom
        , marginLeft
        , marginRight
        , marginTop
        , none
        , pct
        , rem
        , spaceBetween
        )
import Html.Styled as Html exposing (Html, div, text)
import Html.Styled.Attributes exposing (css)
import Maybe.Extra as Maybe
import Nordea.Components.Text as Text
import Nordea.Html as Html exposing (showIf, styleIf)
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Icons as Icons
import Nordea.Types exposing (Translation)


type RequirednessHint
    = Mandatory (Translation -> String)
    | Optional (Translation -> String)
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


bottomInfo : InputProperties -> List (Html msg)
bottomInfo config =
    let
        charCounterView =
            config.charCounter
                |> Html.viewMaybe
                    (\charCounter ->
                        Text.textSmallLight
                            |> Text.view
                                [ css [ marginLeft auto, color Colors.grayDark ] ]
                                [ String.fromInt charCounter.current ++ "/" ++ String.fromInt charCounter.max |> text ]
                    )
    in
    [ div
        [ css
            [ displayFlex
            , flexBasis (pct 100)
            , justifyContent spaceBetween
            , marginTop (rem 0.5)
            , Css.property "gap" "1rem"
            ]
        ]
        [ config.errorMessage
            |> Html.viewMaybe
                (\errText ->
                    Text.textSmallLight
                        |> Text.view
                            [ css
                                [ displayFlex
                                , alignItems center
                                , color Colors.redDark
                                ]
                            ]
                            [ Icons.error [ css [ marginRight (rem 0.5), flex none ] ]
                            , text errText
                            ]
                )
        , charCounterView
        ]
        |> showIf (Maybe.isJust config.errorMessage)
    , div
        [ css
            [ displayFlex
            , flexBasis (pct 100)
            , justifyContent spaceBetween
            , marginTop (rem 0.2)
            , Css.property "gap" "1rem"
            ]
        ]
        [ config.hintText
            |> Html.viewMaybe
                (\hintText ->
                    Text.textSmallLight
                        |> Text.view [ css [ color Colors.grayDark ] ] [ text hintText ]
                )
        , charCounterView |> showIf (Maybe.isNothing config.errorMessage)
        ]
        |> showIf (Maybe.isJust config.hintText || Maybe.isJust config.charCounter)
    ]


topInfo : InputProperties -> Html msg
topInfo config =
    let
        toI18NString requirednessHint =
            case requirednessHint of
                Mandatory translate ->
                    translate strings.mandatory

                Optional translate ->
                    translate strings.optional

                Custom string ->
                    string
    in
    div [ css [ displayFlex, justifyContent spaceBetween, marginBottom (rem 0.2) ] ]
        [ Text.textSmallLight
            |> Text.view
                [ css [ color Colors.redDark |> styleIf (Maybe.isJust config.errorMessage) ] ]
                [ text config.labelText ]
        , config.requirednessHint
            |> Html.viewMaybe
                (\requirednessHint ->
                    Text.textSmallLight
                        |> Text.view
                            [ css [ color Colors.grayDark ] ]
                            [ requirednessHint |> toI18NString |> text ]
                )
        ]


strings : { mandatory : Translation, optional : Translation }
strings =
    { mandatory =
        { no = "Påkrevd"
        , se = "Krävs"
        , dk = "Påkrævet"
        , en = "Required"
        }
    , optional =
        { no = "Valgfritt"
        , se = "Valfritt"
        , dk = "Valgfrit"
        , en = "Optional"
        }
    }
