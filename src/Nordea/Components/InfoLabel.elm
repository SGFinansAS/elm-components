module Nordea.Components.InfoLabel exposing (view, warning)

import Css
    exposing
        ( backgroundColor
        , borderRadius
        , displayFlex
        , fitContent
        , flexDirection
        , height
        , marginRight
        , maxWidth
        , padding
        , rem
        , row
        , width
        )
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes exposing (css)
import Nordea.Components.Text as Text
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Icons as Icon
import Nordea.Themes as Themes


view : List (Attribute msg) -> List (Html msg) -> Html msg
view attrs children =
    Html.div
        (infoLabelContainerStyle :: css [ Themes.backgroundColor Themes.SecondaryColor Colors.blueCloud ] :: attrs)
        [ Icon.info [ css [ width (rem 1.5), height (rem 1.5), marginRight (rem 0.5) ] ]
        , Text.bodyTextSmall
            |> Text.view [] children
        ]


warning : List (Attribute msg) -> List (Html msg) -> Html msg
warning attrs children =
    Html.div
        (infoLabelContainerStyle :: css [ backgroundColor Colors.yellow ] :: attrs)
        [ Icon.info [ css [ width (rem 1.5), height (rem 1.5), marginRight (rem 0.5) ] ]
        , Text.bodyTextSmall
            |> Text.view [] children
        ]


infoLabelContainerStyle : Attribute msg
infoLabelContainerStyle =
    css
        [ displayFlex
        , flexDirection row
        , padding (rem 0.75)
        , borderRadius (rem 0.5)
        , maxWidth fitContent
        ]
