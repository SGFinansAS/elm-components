module Nordea.Components.Dropdown exposing
    ( Dropdown
    , Option
    , init
    , view
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
        , rem
        , solid
        , width
        )
import Html.Styled as Html exposing (Attribute, Html, styled)
import Html.Styled.Attributes as Attributes
import Html.Styled.Events as Events
import List.Extra as List
import Nordea.Resources.Colors as Colors
import Nordea.Util.List as List



-- CONFIG


type alias Option =
    { value : String
    , label : String
    }


type alias Config msg =
    { value : String
    , options : List Option
    , onInput : Maybe (String -> msg)
    }


type Dropdown msg
    = Dropdown (Config msg)


init : String -> List Option -> Dropdown msg
init value options =
    Dropdown
        { value = value
        , options = options |> List.uniqueBy .value
        , onInput = Nothing
        }


withOnInput : (String -> msg) -> Dropdown msg -> Dropdown msg
withOnInput onInput (Dropdown config) =
    Dropdown { config | onInput = Just onInput }



-- VIEW


view : List (Attribute msg) -> Dropdown msg -> Html msg
view attributes (Dropdown config) =
    styled Html.select
        styles
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
    List.filterMaybe
        [ config.onInput |> Maybe.map Events.onInput ]



-- STYLES


styles : List Style
styles =
    [ fontSize (rem 1)
    , height (em 2.5)
    , padding2 (em 0.5) (em 0.75)
    , borderRadius (em 0.125)
    , border3 (em 0.0625) solid Colors.grayMedium
    , boxSizing borderBox
    , width (em 18.75)
    , disabled
        [ backgroundColor Colors.grayWarm
        ]
    , focus
        [ outline none
        , borderColor Colors.blueNordea
        ]
    ]
