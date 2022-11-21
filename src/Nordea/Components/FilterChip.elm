module Nordea.Components.FilterChip exposing (init, view)

import Css
    exposing
        ( alignItems
        , borderBox
        , borderRadius
        , borderWidth
        , boxSizing
        , center
        , displayFlex
        , fitContent
        , flexDirection
        , maxWidth
        , noWrap
        , padding2
        , rem
        , whiteSpace
        , width
        )
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes exposing (css)
import Nordea.Components.Text as Text
import Nordea.Resources.Colors as Colors
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
            , displayFlex
            , flexDirection Css.row
            , borderRadius (rem 2)
            , boxSizing borderBox
            , Themes.backgroundColor Themes.SecondaryColor Colors.cloudBlue
            , Themes.color Themes.PrimaryColor Colors.deepBlue
            , maxWidth fitContent
            , Css.property "gap" "1rem"
            , whiteSpace noWrap
            , alignItems center
            , borderWidth (rem 0)
            , Css.property "appearance" "none"
            ]
         ]
            ++ attrs
        )
        [ Text.bodyTextSmall |> Text.view [] [ Html.text label ]
        , Icon.cross [ css [ width (rem 1.0) ] ]
        ]
