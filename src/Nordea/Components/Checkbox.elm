module Nordea.Components.Checkbox exposing (Checkbox, init, view, withError, withOnCheck)

import Css
    exposing
        ( Style
        , alignItems
        , backgroundColor
        , border3
        , boxSizing
        , center
        , color
        , contentBox
        , cursor
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
import Html.Styled.Attributes exposing (checked, type_)
import Html.Styled.Events exposing (onCheck)
import Maybe.Extra as Maybe
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Icons as Icons


type alias Config msg =
    { checked : Bool
    , onCheck : Maybe (Bool -> msg)
    , showError : Bool
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
        }


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
        labelStyles
        []
        ([ styled input
            inputStyles
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
        ]


labelStyles : List Style
labelStyles =
    [ displayFlex
    , alignItems center
    , cursor pointer
    ]


inputStyles : List Style
inputStyles =
    [ display none
    , pseudoClass "checked"
        [ adjacentSiblings
            [ typeSelector "div"
                [ backgroundColor Colors.blueDeep
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

            else
                Colors.blueDeep
    in
    [ display inlineBlock
    , width (em 1)
    , height (em 1)
    , boxSizing contentBox
    , border3 (em 0.125) solid borderColorStyle
    , backgroundColor Colors.white
    , color Colors.white
    , marginRight (em 0.5)
    ]
