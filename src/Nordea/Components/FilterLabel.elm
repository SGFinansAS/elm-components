module Nordea.Components.FilterLabel exposing (init, view)

import Css
    exposing
        ( alignSelf
        , border3
        , borderBox
        , borderRadius
        , boxSizing
        , center
        , cursor
        , displayFlex
        , fitContent
        , flexDirection
        , fontFamilies
        , maxWidth
        , noWrap
        , padding2
        , pointer
        , rem
        , solid
        , whiteSpace
        , width
        )
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes exposing (css)
import Nordea.Components.Text as Text
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Icons as Icon
import Nordea.Themes as Themes


type FilterLabel
    = FilterLabel { label : String }


init : { label : String } -> FilterLabel
init { label } =
    FilterLabel { label = label }


view : List (Attribute msg) -> FilterLabel -> Html msg
view attrs (FilterLabel { label }) =
    Html.button
        ([ css
            [ padding2 (rem 0.25) (rem 0.75)
            , displayFlex
            , flexDirection Css.row
            , borderRadius (rem 0.5)
            , fontFamilies [ "inherit" ]
            , borderRadius (rem 2)
            , cursor pointer
            , boxSizing borderBox
            , Themes.backgroundColor Themes.SecondaryColor Colors.cloudBlue
            , Themes.color Themes.PrimaryColor Colors.deepBlue
            , border3 (rem 0.125) solid Colors.transparent
            , maxWidth fitContent
            , Css.property "gap" "1rem"
            , whiteSpace noWrap
            , alignSelf center
            ]
         ]
            ++ attrs
        )
        [ Text.bodyTextSmall |> Text.view [] [ Html.text label ]
        , Icon.cross [ css [ width (rem 1.0) ] ]
        ]
