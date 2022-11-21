module Nordea.Components.FilterChip exposing (init, view)

import Css
    exposing
        ( alignItems
        , backgroundColor
        , borderBox
        , borderRadius
        , borderWidth
        , boxSizing
        , center
        , color
        , cursor
        , disabled
        , displayFlex
        , fitContent
        , flexDirection
        , focus
        , hover
        , maxWidth
        , minHeight
        , noWrap
        , none
        , outline
        , padding2
        , pointer
        , pointerEvents
        , rem
        , whiteSpace
        , width
        )
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes exposing (css)
import Nordea.Components.Text as Text
import Nordea.Resources.Colors as Color
import Nordea.Resources.Icons as Icon
import Nordea.Themes as Themes


type FilterChip
    = FilterChip { label : String }


init : { label : String } -> FilterChip
init { label } =
    FilterChip { label = label }


view : List (Attribute msg) -> FilterChip -> Html msg
view attrs (FilterChip { label }) =
    Html.button
        ([ css
            [ padding2 (rem 0.25) (rem 0.75)
            , minHeight fitContent
            , displayFlex
            , flexDirection Css.row
            , borderRadius (rem 2)
            , boxSizing borderBox
            , Themes.backgroundColor Themes.SecondaryColor Color.cloudBlue
            , Themes.color Themes.PrimaryColor Color.deepBlue
            , maxWidth fitContent
            , Css.property "gap" "1rem"
            , Css.property "height" "fit-content"
            , whiteSpace noWrap
            , alignItems center
            , borderWidth (rem 0)
            , Css.property "appearance" "none"
            , cursor pointer
            , hover [ backgroundColor Color.lightGray ]
            , focus
                [ outline none
                , Css.property "box-shadow" ("0rem 0rem 0rem 0.125rem " ++ Themes.colorVariable Themes.SecondaryColor Color.blueHaas)
                ]
            , disabled
                [ pointerEvents none
                , backgroundColor Color.lightGray
                , color Color.darkGray
                ]
            ]
         ]
            ++ attrs
        )
        [ Text.bodyTextSmall |> Text.view [] [ Html.text label ]
        , Icon.cross [ css [ width (rem 1.0) ] ]
        ]
