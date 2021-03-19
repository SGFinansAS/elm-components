module Nordea.Components.RadioButton exposing (RadioButton, init, view, withOnCheck)

import Css exposing (Style)
import Css.Global as Css
import Html.Styled exposing (Attribute, Html, div, input, label, styled)
import Html.Styled.Attributes exposing (checked, type_)
import Html.Styled.Events exposing (onCheck)
import Maybe.Extra as Maybe
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Icons as Icons


type alias Config msg =
    { checked : Bool
    , onCheck : Maybe (Bool -> msg)
    }


type RadioButton msg
    = RadioButton (Config msg)



-- CONFIG


init : Bool -> RadioButton msg
init checked =
    RadioButton
        { checked = checked
        , onCheck = Nothing
        }


withOnCheck : (Bool -> msg) -> RadioButton msg -> RadioButton msg
withOnCheck onCheck (RadioButton config) =
    RadioButton { config | onCheck = Just onCheck }



-- VIEW


view : List (Attribute msg) -> List (Html msg) -> RadioButton msg -> Html msg
view attributes children (RadioButton config) =
    styled label
        labelStyles
        []
        ([ styled input
            inputStyles
            (inputAttributes config ++ attributes)
            []
         ]
            ++ children
        )


inputAttributes : Config msg -> List (Attribute msg)
inputAttributes config =
    Maybe.values
        [ Just "radio" |> Maybe.map type_
        , Just config.checked |> Maybe.map checked
        , config.onCheck |> Maybe.map onCheck
        ]


labelStyles : List Style
labelStyles =
    [ Css.displayFlex
    , Css.alignItems Css.center
    , Css.cursor Css.pointer
    , Css.position Css.relative
    , Css.paddingLeft (Css.rem 1.75)
    , Css.height (Css.rem 1.25)
    , Css.before
        [ Css.property "content" "\"\""
        , Css.position Css.absolute
        , Css.top Css.zero
        , Css.left Css.zero
        , Css.width (Css.rem 1.25)
        , Css.height (Css.rem 1.25)
        , Css.border3 (Css.rem 0.125) Css.solid Colors.blueDeep
        , Css.borderRadius (Css.pct 50)
        ]
    , Css.after
        [ Css.property "content" "\"\""
        , Css.position Css.absolute
        , Css.top (Css.rem 0.25)
        , Css.left (Css.rem 0.25)
        , Css.width (Css.rem 0.75)
        , Css.height (Css.rem 0.75)
        , Css.borderRadius (Css.pct 50)

        --, Css.backgroundColor Colors.blueDeep
        ]
    ]


inputStyles : List Style
inputStyles =
    [ Css.display Css.none
    , Css.checked
        [ Css.adjacentSiblings
            [ Css.typeSelector "div"
                []
            ]
        ]
    ]
