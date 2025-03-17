module Nordea.Components.FilterChip exposing (init, view, withSmallSize)

import Css
    exposing
        ( alignItems
        , backgroundColor
        , borderBox
        , borderRadius
        , borderWidth
        , boxSizing
        , center
        , cursor
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
        , rem
        , whiteSpace
        , width
        )
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes exposing (css)
import Nordea.Components.Text as Text
import Nordea.Css exposing (gap)
import Nordea.Resources.Colors as Color
import Nordea.Resources.Icons as Icon
import Nordea.Themes as Themes


type FilterChip
    = FilterChip { label : String, appearance : Appearance }


type Appearance
    = Standard
    | Small


init : { label : String } -> FilterChip
init { label } =
    FilterChip { label = label, appearance = Standard }


view : List (Attribute msg) -> FilterChip -> Html msg
view attrs (FilterChip { label, appearance }) =
    let
        ( gapStyle, iconSizeStyle, textType ) =
            case appearance of
                Standard ->
                    ( gap (rem 1), width (rem 1), Text.bodyTextSmall )

                Small ->
                    ( gap (rem 0.25), width (rem 0.5), Text.textTinyLight )
    in
    Html.button
        (css
            [ padding2 (rem 0.25) (rem 0.75)
            , minHeight fitContent
            , displayFlex
            , flexDirection Css.row
            , borderRadius (rem 2)
            , boxSizing borderBox
            , Themes.backgroundColor Color.cloudBlue
            , Themes.color Color.deepBlue
            , maxWidth fitContent
            , gapStyle
            , Css.property "height" "fit-content"
            , whiteSpace noWrap
            , alignItems center
            , borderWidth (rem 0)
            , Css.property "appearance" "none"
            , cursor pointer
            , hover [ backgroundColor Color.lightGray ]
            , focus
                [ outline none
                , Css.property "box-shadow" ("0rem 0rem 0rem 0.125rem " ++ Themes.colorVariable Color.haasBlue)
                ]
            ]
            :: attrs
        )
        [ textType |> Text.view [] [ Html.text label ]
        , Icon.cross [ css [ iconSizeStyle ] ]
        ]


withSmallSize : FilterChip -> FilterChip
withSmallSize (FilterChip config) =
    FilterChip { config | appearance = Small }
