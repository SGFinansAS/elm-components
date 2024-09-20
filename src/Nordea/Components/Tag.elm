module Nordea.Components.Tag exposing (beta)

import Css
    exposing
        ( Color
        , auto
        , backgroundColor
        , borderRadius
        , color
        , display
        , fontSize
        , fontWeight
        , inlineBlock
        , int
        , lineHeight
        , marginLeft
        , padding
        , rem
        )
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes exposing (css)
import Nordea.Resources.Colors as Colors


view : String -> Color -> Color -> List (Attribute msg) -> Html msg
view text textColor tagColor attrs =
    Html.div
        (css
            [ display inlineBlock
            , borderRadius (rem 0.25)
            , padding (rem 0.25)
            , backgroundColor tagColor
            , fontSize (rem 0.5)
            , lineHeight (rem 0.5)
            , fontWeight (int 500)
            , Css.property "height" "fit-content"
            , color textColor
            ]
            :: attrs
        )
        [ Html.text text ]


beta : List (Attribute msg) -> Html msg
beta =
    view "Beta" Colors.deepBlue Colors.lightOrange
