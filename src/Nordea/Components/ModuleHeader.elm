module Nordea.Components.ModuleHeader exposing (buttonSectionStyles, headerStyles, headerTextStyles, view)

import Css
    exposing
        ( alignItems
        , backgroundImage
        , bold
        , borderBottomColor
        , borderBottomStyle
        , borderBottomWidth
        , borderTopColor
        , borderTopStyle
        , borderTopWidth
        , center
        , color
        , displayFlex
        , fontSize
        , fontWeight
        , hex
        , justifyContent
        , marginRight
        , maxHeight
        , minHeight
        , paddingLeft
        , paddingTop
        , px
        , rem
        , solid
        , spaceAround
        , spaceBetween
        , textTransform
        , uppercase
        , url
        , width
        )
import Html.Styled as Styled exposing (Attribute, Html)
import Html.Styled.Attributes as Attributes
import Nordea.Resources.Colors as Colors


view : String -> List (Attribute msg) -> List (Html msg) -> Html msg
view headerText attributes children =
    Styled.header (headerStyles :: attributes) [ Styled.h2 [ headerTextStyles ] [ Styled.text headerText ], Styled.div [ buttonSectionStyles ] children ]


headerStyles : Attribute msg
headerStyles =
    Attributes.css
        [ minHeight (px 50)
        , maxHeight (px 110)
        , borderTopWidth (px 1)
        , borderTopStyle solid
        , borderTopColor (hex "dbdcdd")
        , borderBottomWidth (px 1)
        , borderBottomStyle solid
        , borderBottomColor (hex "d3d5d5")
        , displayFlex
        , justifyContent spaceBetween
        , backgroundImage (url "data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxMDAlIiBoZWlnaHQ9IjEwMCUiIHZpZXdCb3g9IjAgMCAxIDEiIHByZXNlcnZlQXNwZWN0UmF0aW89Im5vbmUiPgo8bGluZWFyR3JhZGllbnQgaWQ9ImcyNjAiIGdyYWRpZW50VW5pdHM9InVzZXJTcGFjZU9uVXNlIiB4MT0iMCUiIHkxPSIwJSIgeDI9IjAlIiB5Mj0iMTAwJSI+CjxzdG9wIHN0b3AtY29sb3I9IiNGNEY0RjQiIG9mZnNldD0iMCIvPjxzdG9wIHN0b3AtY29sb3I9IiNGNkY2RjYiIG9mZnNldD0iMSIvPgo8L2xpbmVhckdyYWRpZW50Pgo8cmVjdCB4PSIwIiB5PSIwIiB3aWR0aD0iMSIgaGVpZ2h0PSIxIiBmaWxsPSJ1cmwoI2cyNjApIiAvPgo8L3N2Zz4=")
        ]


headerTextStyles : Attribute msg
headerTextStyles =
    Attributes.css
        [ paddingTop (px 17)
        , paddingLeft (px 8)
        , textTransform uppercase
        , color Colors.grayDarkest
        , fontSize (px 16)
        , fontWeight bold
        ]


buttonSectionStyles : Attribute msg
buttonSectionStyles =
    Attributes.css
        [ displayFlex
        , alignItems center
        , justifyContent spaceAround
        , width (rem 10)
        , marginRight (rem 2)
        ]
