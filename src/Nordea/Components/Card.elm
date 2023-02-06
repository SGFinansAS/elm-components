module Nordea.Components.Card exposing
    ( Card
    , footer
    , header
    , infoBox
    , init
    , title
    , view
    , withShadow
    , withTitle
    )

import Css
    exposing
        ( auto
        , backgroundColor
        , border3
        , borderRadius
        , borderStyle
        , boxShadow4
        , column
        , displayFlex
        , flexDirection
        , height
        , left
        , margin2
        , none
        , padding
        , rem
        , solid
        , textAlign
        , width
        )
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes exposing (css)
import Nordea.Components.Text as Text
import Nordea.Html as Html exposing (styleIf, viewMaybe)
import Nordea.Resources.Colors as Colors


type alias CardProperties =
    { title : Maybe String
    , hasShadow : Bool
    }


type Card msg
    = Card CardProperties


init : Card msg
init =
    Card
        { title = Nothing
        , hasShadow = False
        }


view : List (Attribute msg) -> List (Html msg) -> Card msg -> Html msg
view attrs children (Card config) =
    Html.div
        (css
            [ borderRadius (rem 0.5)
            , padding (rem 1.5)
            , textAlign left
            , displayFlex
            , flexDirection column
            , backgroundColor Colors.white
            , boxShadow4 (rem 0) (rem 0.25) (rem 2.5) Colors.grayLight
                |> styleIf config.hasShadow
            ]
            :: attrs
        )
        ((config.title |> viewMaybe (\title_ -> header [] [ title [] [ Html.text title_ ] ]))
            :: children
        )


header : List (Attribute msg) -> List (Html msg) -> Html msg
header attrs children =
    Html.div
        (css [] :: attrs)
        (children
            ++ [ Html.hr
                    [ css
                        [ width auto
                        , borderStyle none
                        , height (rem 0.0625)
                        , backgroundColor Colors.grayCool
                        , margin2 (rem 1) (rem -1.5)
                        ]
                    ]
                    []
               ]
        )


title : List (Attribute msg) -> List (Html msg) -> Html msg
title attrs children =
    Text.bodyTextHeavy
        |> Text.view attrs children


infoBox : List (Attribute msg) -> List (Html msg) -> Html msg
infoBox attrs content =
    Html.column
        (css
            [ borderRadius (rem 0.5)
            , border3 (rem 0.0625) solid Colors.grayLight
            , padding (rem 1)
            ]
            :: attrs
        )
        content


footer : List (Attribute msg) -> List (Html msg) -> Html msg
footer attrs children =
    Html.div
        (css [] :: attrs)
        (Html.hr
            [ css
                [ width auto
                , borderStyle none
                , height (rem 0.0625)
                , backgroundColor Colors.grayCool
                , margin2 (rem 1) (rem -1.5)
                ]
            ]
            []
            :: children
        )


withTitle : String -> Card msg -> Card msg
withTitle title_ (Card config) =
    Card { config | title = Just title_ }


withShadow : Card msg -> Card msg
withShadow (Card config) =
    Card { config | hasShadow = True }
