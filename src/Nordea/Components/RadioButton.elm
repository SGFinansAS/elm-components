module Nordea.Components.RadioButton exposing (RadioButton, init, view, withOnCheck)

import Css
import Css.Global as Css
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attrs
import Html.Styled.Events as Events
import Maybe.Extra as Maybe
import Nordea.Resources.Colors as Colors


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
    viewLabel (viewInput config attributes :: (viewRadio :: children))


viewLabel : List (Html msg) -> Html msg
viewLabel =
    Html.styled Html.label
        [ Css.displayFlex
        , Css.alignItems Css.center
        , Css.cursor Css.pointer
        , Css.position Css.relative
        , Css.paddingLeft (Css.rem 1.75)
        , Css.height (Css.rem 1.25)
        ]
        []


viewInput : Config msg -> List (Attribute msg) -> Html msg
viewInput config attributes =
    Html.styled Html.input
        [ Css.display Css.none
        , Css.checked
            [ Css.adjacentSiblings
                [ Css.everything
                    [ Css.after
                        [ Css.backgroundColor Colors.blueDeep ]
                    ]
                ]
            ]
        ]
        (Maybe.values
            [ Just "radio" |> Maybe.map Attrs.type_
            , Just config.checked |> Maybe.map Attrs.checked
            , config.onCheck |> Maybe.map Events.onCheck
            ]
            ++ attributes
        )
        []


viewRadio : Html msg
viewRadio =
    Html.styled Html.span
        [ Css.before
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
            ]
        ]
        []
        []
