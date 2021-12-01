module Nordea.Components.Table exposing
    ( tbody
    , td
    , th
    , thead
    , tr
    , view
    )

import Css
    exposing
        ( backgroundColor
        , borderBottom3
        , column
        , displayFlex
        , flexDirection
        , hover
        , left
        , nthChild
        , paddingBottom
        , paddingLeft
        , paddingTop
        , px
        , rem
        , row
        , solid
        , textAlign
        )
import Css.Global exposing (descendants, typeSelector)
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes exposing (css)
import Nordea.Components.Text as Text
import Nordea.Resources.Colors as Colors


view : List (Attribute msg) -> List (Html msg) -> Html msg
view attrs children =
    Html.table
        (css [ displayFlex, flexDirection column ]
            :: attrs
        )
        children


{-| Groups the header content in a table
-}
thead : List (Attribute msg) -> List (Html msg) -> Html msg
thead attrs children =
    Html.thead (css [ borderBottom3 (px 1) solid Colors.grayLight ] :: attrs)
        children


{-| Defines a row in a table
-}
tr : List (Attribute msg) -> List (Html msg) -> Html msg
tr attrs children =
    Html.tr
        (css
            [ displayFlex
            , flexDirection row
            , hover [ backgroundColor Colors.blueCloud |> Css.important ]
            ]
            :: attrs
        )
        children


{-| Defines a header cell in a table
-}
th : List (Attribute msg) -> List (Html msg) -> Html msg
th attrs children =
    Html.th (css [ paddingLeft (rem 1) ] :: attrs) children


{-| Groups the body content in a table
-}
tbody : List (Attribute msg) -> List (Html msg) -> Html msg
tbody attrs children =
    Html.tbody
        (css
            [ displayFlex
            , flexDirection column
            , descendants
                [ typeSelector "tr"
                    [ nthChild "even"
                        [ backgroundColor Colors.grayLightBorder
                        ]
                    ]
                ]
            ]
            :: attrs
        )
        children


{-| Defines a cell in a table
-}
td : List (Attribute msg) -> List (Html msg) -> Html msg
td attrs children =
    Html.td
        (css
            [ textAlign left
            , paddingBottom (rem 1)
            , paddingLeft (rem 1)
            , paddingTop (rem 1)
            ]
            :: attrs
        )
        [ Text.init Text.BodyTextSmall
            |> Text.view []
                children
        ]
