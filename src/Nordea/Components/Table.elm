module Nordea.Components.Table exposing
    ( tbody
    , tbodySmall
    , td
    , th
    , thead
    , theadSmall
    , tr
    , view
    , Variant
    , theadWithVariant
    , tbodyWithVariant
    )

import Css
    exposing
        ( alignSelf
        , backgroundColor
        , borderBottom3
        , center
        , column
        , displayFlex
        , ellipsis
        , flexDirection
        , height
        , hidden
        , hover
        , noWrap
        , nthChild
        , overflow
        , padding
        , padding4
        , rem
        , row
        , solid
        , textOverflow
        , whiteSpace
        )
import Css.Global as Css exposing (typeSelector)
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes exposing (css)
import Nordea.Components.Text as Text
import Nordea.Resources.Colors as Colors
import Nordea.Themes as Themes


type Variant
    = Small
    | Standard
    | ExtraSmall


view : List (Attribute msg) -> List (Html msg) -> Html msg
view attrs children =
    Html.table
        (css [ displayFlex, flexDirection column ]
            :: attrs
        )
        children


{-| Groups the header content in a table
-}
theadWithVariant : List (Attribute msg) -> List (Html msg) -> Variant -> Html msg
theadWithVariant attrs children variant =
    let
        headHeight =
            case variant of
                Small ->
                    rem 2.5

                Standard ->
                    rem 3.5

                ExtraSmall ->
                    rem 1.5
    in
    Html.thead
        (css
            [ height headHeight
            , borderBottom3 (rem 0.0625) solid Colors.grayLight
            ]
            :: attrs
        )
        children


{-| Groups the header content in a table
-}
thead : List (Attribute msg) -> List (Html msg) -> Html msg
thead attrs children =
    theadWithVariant attrs children Standard


{-| Groups the header content in a smaller table
-}
theadSmall : List (Attribute msg) -> List (Html msg) -> Html msg
theadSmall attrs children =
    theadWithVariant attrs children Small


{-| Defines a row in a table
-}
tr : List (Attribute msg) -> List (Html msg) -> Html msg
tr attrs children =
    Html.tr
        (css
            [ displayFlex
            , flexDirection row
            ]
            :: attrs
        )
        children


{-| Defines a header cell in a table
-}
th : List (Attribute msg) -> List (Html msg) -> Html msg
th attrs children =
    Html.th
        (css [ padding4 (rem 1.0) (rem 0.75) (rem 0.75) (rem 0.75) ] :: attrs)
        [ Text.textSmallHeavy |> Text.view [] children ]


{-| Groups the body content in a table
-}
tbodyWithVariant : List (Attribute msg) -> List (Html msg) -> Variant -> Html msg
tbodyWithVariant attrs children variant =
    let
        trHeight =
            case variant of
                Small ->
                    rem 2.5

                Standard ->
                    rem 4.5

                ExtraSmall ->
                    rem 2.5
    in
    Html.tbody
        (css
            [ displayFlex
            , flexDirection column
            , Css.children
                [ typeSelector "tr"
                    [ height trHeight
                    , hover [ Themes.backgroundColor Themes.SecondaryColor Colors.cloudBlue |> Css.important ]
                    , nthChild "even" [ backgroundColor Colors.grayLightBorder ]
                    ]
                ]
            ]
            :: attrs
        )
        children


{-| Groups the body content in a table
-}
tbody : List (Attribute msg) -> List (Html msg) -> Html msg
tbody attrs children =
    tbodyWithVariant attrs children Standard


{-| Groups the body content in a smaller table
-}
tbodySmall : List (Attribute msg) -> List (Html msg) -> Html msg
tbodySmall attrs children =
    tbodyWithVariant attrs children Small


{-| Defines a cell in a table
When only simple text inside the table cell, the text type here should be Text.BodyTextSmall
-}
td : List (Attribute msg) -> List (Html msg) -> Html msg
td attrs children =
    Html.td
        (css
            [ padding (rem 0.75)
            , alignSelf center
            , textOverflow ellipsis
            , whiteSpace noWrap
            , overflow hidden
            ]
            :: attrs
        )
        children
