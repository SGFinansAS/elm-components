module Nordea.Components.Common exposing (CharCounter, InputProperties, topInfo, viewLabel)

import Css
    exposing
        ( color
        , displayFlex
        , justifyContent
        , marginBottom
        , rem
        , spaceBetween
        )
import Html.Styled as Html exposing (Attribute, Html, div, text)
import Html.Styled.Attributes exposing (css)
import Maybe.Extra as Maybe
import Nordea.Components.Text as Text
import Nordea.Components.Util.RequirednessHint as RequirednessHint exposing (RequirednessHint)
import Nordea.Html as Html exposing (styleIf)
import Nordea.Resources.Colors as Colors


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


type alias LabelProperties =
    { label : String
    , isError : Bool
    }


viewLabel : LabelProperties -> List (Attribute msg) -> Html msg
viewLabel { label, isError } attrs =
    Text.textSmallLight
        |> Text.view
            ([ css [ color Colors.redDark |> styleIf isError ] ] ++ attrs)
            [ Html.label [] [ Html.text label ] ]


topInfo : InputProperties -> Html msg
topInfo config =
    div [ css [ displayFlex, justifyContent spaceBetween, marginBottom (rem 0.2) ] ]
        [ Text.textSmallLight
            |> Text.view
                [ css [ color Colors.redDark |> styleIf (Maybe.isJust config.errorMessage) ] ]
                [ text config.labelText ]
        , config.requirednessHint |> Html.viewMaybe RequirednessHint.view
        ]
