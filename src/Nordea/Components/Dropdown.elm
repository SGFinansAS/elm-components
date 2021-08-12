module Nordea.Components.Dropdown exposing
    ( Dropdown
    , Option
    , init
    , view
    , withError
    , withOnInput
    )

import Css
    exposing
        ( Style
        , backgroundColor
        , border3
        , borderBox
        , borderColor
        , borderRadius
        , boxSizing
        , disabled
        , em
        , focus
        , fontSize
        , height
        , none
        , outline
        , padding2
        , pct
        , rem
        , solid
        , width
        )
import Html.Styled as Html exposing (Attribute, Html, styled)
import Html.Styled.Attributes as Attributes
import Html.Styled.Events as Events
import List.Extra as List
import Maybe.Extra as Maybe
import Nordea.Html.Events as Events
import Nordea.Resources.Colors as Colors



-- CONFIG


type alias Option =
    { value : String
    , label : String
    }


type alias Config msg =
    { value : String
    , options : List Option
    , onInput : Maybe (String -> msg)
    , showError : Bool
    }


type Dropdown msg
    = Dropdown (Config msg)


init : String -> List Option -> Dropdown msg
init value options =
    Dropdown
        { value = value
        , options = options |> List.uniqueBy .value
        , onInput = Nothing
        , showError = False
        }


withOnInput : (String -> msg) -> Dropdown msg -> Dropdown msg
withOnInput onInput (Dropdown config) =
    Dropdown { config | onInput = Just onInput }


withError : Bool -> Dropdown msg -> Dropdown msg
withError condition (Dropdown config) =
    Dropdown { config | showError = condition }



-- VIEW


view : List (Attribute msg) -> Dropdown msg -> Html msg
view attributes (Dropdown config) =
    styled Html.select
        (getStyles config)
        (getAttributes config ++ attributes)
        (List.map (viewOption config.value) config.options)


viewOption : String -> Option -> Html msg
viewOption selected option =
    Html.option
        [ Attributes.value option.value
        , Attributes.selected (option.value == selected)
        ]
        [ Html.text option.label ]


getAttributes : Config msg -> List (Attribute msg)
getAttributes config =
    Maybe.values
        [ config.onInput |> Maybe.map Events.onChange ]



-- STYLES


getStyles : Config msg -> List Style
getStyles config =
    let
        borderColorStyle =
            if config.showError then
                Colors.redDark

            else
                Colors.grayMedium
    in
    [ fontSize (rem 1)
    , height (em 2.5)
    , padding2 (em 0.5) (em 0.75)
    , borderRadius (em 0.125)
    , border3 (em 0.0625) solid borderColorStyle
    , boxSizing borderBox
    , width (pct 100)
    , disabled
        [ backgroundColor Colors.grayWarm
        ]
    , focus
        [ outline none
        , borderColor Colors.blueNordea
        ]
    ]
