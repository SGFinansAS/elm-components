module Nordea.Components.Checkbox exposing (Checkbox, init, view, withDisabled, withError, withOnCheck)

import Css
    exposing
        ( Style
        , alignItems
        , backgroundColor
        , border3
        , borderRadius
        , boxSizing
        , center
        , color
        , contentBox
        , cursor
        , default
        , display
        , displayFlex
        , em
        , height
        , inlineBlock
        , marginRight
        , none
        , pointer
        , pseudoClass
        , solid
        , width
        )
import Css.Global exposing (adjacentSiblings, typeSelector)
import Html.Styled exposing (Attribute, Html, div, input, label, styled)
import Html.Styled.Attributes exposing (checked, disabled, type_)
import Html.Styled.Events exposing (onCheck)
import Maybe.Extra as Maybe
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Icons as Icons


type alias Config msg =
    { checked : Bool
    , onCheck : Maybe (Bool -> msg)
    , showError : Bool
    , disabled : Bool
    }


type Checkbox msg
    = Checkbox (Config msg)



-- CONFIG


init : Bool -> Checkbox msg
init checked =
    Checkbox
        { checked = checked
        , onCheck = Nothing
        , showError = False
        , disabled = False
        }


withDisabled : Bool -> Checkbox msg -> Checkbox msg
withDisabled disabled (Checkbox config) =
    Checkbox { config | disabled = disabled }


withOnCheck : (Bool -> msg) -> Checkbox msg -> Checkbox msg
withOnCheck onCheck (Checkbox config) =
    Checkbox { config | onCheck = Just onCheck }


withError : Bool -> Checkbox msg -> Checkbox msg
withError condition (Checkbox config) =
    Checkbox { config | showError = condition }



-- VIEW


view : List (Attribute msg) -> List (Html msg) -> Checkbox msg -> Html msg
view attributes children (Checkbox config) =
    styled label
        (labelStyles config)
        []
        ([ styled input
            (inputStyles config)
            (inputAttributes config ++ attributes)
            []
         , styled div
            (boxStyles config)
            []
            [ Icons.check ]
         ]
            ++ children
        )


inputAttributes : Config msg -> List (Attribute msg)
inputAttributes config =
    Maybe.values
        [ Just "checkbox" |> Maybe.map type_
        , Just config.checked |> Maybe.map checked
        , config.onCheck |> Maybe.map onCheck
        , Just (disabled config.disabled)
        ]


labelStyles : Config msg -> List Style
labelStyles config =
    let
        cursorStyle =
            if config.disabled then
                default

            else
                pointer
    in
    [ displayFlex
    , alignItems center
    , cursor cursorStyle
    ]


inputStyles : Config msg -> List Style
inputStyles config =
    let
        backgroundColorStyle =
            if config.disabled then
                Colors.grayMedium

            else
                Colors.blueDeep
    in
    [ display none
    , pseudoClass "checked"
        [ adjacentSiblings
            [ typeSelector "div"
                [ backgroundColor backgroundColorStyle
                ]
            ]
        ]
    ]


boxStyles : Config msg -> List Style
boxStyles config =
    let
        borderColorStyle =
            if config.showError then
                Colors.redDark

            else if config.disabled then
                Colors.grayMedium

            else
                Colors.blueDeep
    in
    [ display inlineBlock
    , width (em 1)
    , height (em 1)
    , boxSizing contentBox
    , border3 (em 0.125) solid borderColorStyle
    , borderRadius (em 0.125)
    , backgroundColor Colors.white
    , color Colors.white
    , marginRight (em 0.5)
    ]
