module Nordea.Components.Util.Hint exposing
    ( init
    , view
    , withCharCounter
    , withError
    )

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
        , marginLeft
        , marginRight
        , marginTop
        , none
        , pct
        , rem
        , spaceBetween
        )
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes exposing (css)
import Nordea.Components.Text as Text
import Nordea.Html as Html
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Icons as Icons


type alias Hint =
    { text : String
    , charCounter : Maybe CharCounter
    , error : Maybe String
    }


type alias CharCounter =
    { current : Int
    , max : Int
    }


init : { text : String } -> Hint
init { text } =
    { text = text
    , charCounter = Nothing
    , error = Nothing
    }


view : Hint -> Html msg
view hint =
    let
        viewHintText text =
            Text.textSmallLight
                |> Text.view [ css [ color Colors.grayDark ] ] [ Html.text text ]

        viewError errorText =
            Text.textSmallLight
                |> Text.view
                    [ css [ displayFlex, alignItems center, color Colors.redDark ] ]
                    [ Icons.error [ css [ marginRight (rem 0.5), flex none ] ]
                    , Html.text errorText
                    ]

        viewCharCounter counter =
            Text.textSmallLight
                |> Text.view
                    [ css [ marginLeft auto, color Colors.grayDark ] ]
                    [ String.fromInt counter.current ++ "/" ++ String.fromInt counter.max |> Html.text ]
    in
    Html.row
        [ css
            [ flexBasis (pct 100)
            , justifyContent spaceBetween
            , marginTop (rem 0.2)
            ]
        ]
        [ Html.column []
            [ hint.error |> Html.viewMaybe viewError
            , viewHintText hint.text
            ]
        , hint.charCounter |> Html.viewMaybe viewCharCounter
        ]


withError : Maybe String -> Hint -> Hint
withError error hint =
    { hint | error = error }


withCharCounter : Maybe CharCounter -> Hint -> Hint
withCharCounter charCounter hint =
    { hint | charCounter = charCounter }
