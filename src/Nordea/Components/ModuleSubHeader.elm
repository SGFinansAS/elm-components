module Nordea.Components.ModuleSubHeader exposing (subHeaderStyles, view)

import Css
    exposing
        ( backgroundImage
        , bold
        , borderBottomColor
        , borderBottomStyle
        , borderBottomWidth
        , fontSize
        , fontWeight
        , hex
        , padding
        , pct
        , px
        , solid
        , url
        , width
        )
import Html.Styled as Styled exposing (Attribute, Html)
import Html.Styled.Attributes as Attributes


view : String -> List (Attribute msg) -> Html msg
view subHeaderText attributes =
    Styled.legend (subHeaderStyles :: attributes) [ Styled.text subHeaderText ]


subHeaderStyles : Attribute msg
subHeaderStyles =
    Attributes.css
        [ width (pct 100)
        , padding (px 8)
        , borderBottomWidth (px 1)
        , borderBottomStyle solid
        , borderBottomColor (hex "d3d5d5")
        , fontSize (px 13)
        , fontWeight bold
        , backgroundImage (url "data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxMDAlIiBoZWlnaHQ9IjEwMCUiIHZpZXdCb3g9IjAgMCAxIDEiIHByZXNlcnZlQXNwZWN0UmF0aW89Im5vbmUiPgo8bGluZWFyR3JhZGllbnQgaWQ9ImczOTMiIGdyYWRpZW50VW5pdHM9InVzZXJTcGFjZU9uVXNlIiB4MT0iMCUiIHkxPSIwJSIgeDI9IjAlIiB5Mj0iMTAwJSI+CjxzdG9wIHN0b3AtY29sb3I9IiNGNEY0RjQiIG9mZnNldD0iMCIvPjxzdG9wIHN0b3AtY29sb3I9IiNGNkY2RjYiIG9mZnNldD0iMSIvPgo8L2xpbmVhckdyYWRpZW50Pgo8cmVjdCB4PSIwIiB5PSIwIiB3aWR0aD0iMSIgaGVpZ2h0PSIxIiBmaWxsPSJ1cmwoI2czOTMpIiAvPgo8L3N2Zz4=")
        ]
