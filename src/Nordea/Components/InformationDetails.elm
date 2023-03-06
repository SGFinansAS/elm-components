module Nordea.Components.InformationDetails exposing
    ( card
    , element
    , fullWidthElement
    , label
    , value
    )

import Css
    exposing
        ( color
        , column
        , displayFlex
        , flexBasis
        , flexDirection
        , flexGrow
        , flexWrap
        , lineHeight
        , marginBottom
        , marginRight
        , num
        , pct
        , rem
        , wrap
        )
import Css.Global as Css exposing (children)
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes exposing (css)
import Nordea.Components.Card as Card
import Nordea.Components.Text as Text
import Nordea.Resources.Colors as Colors


card : List (Attribute msg) -> List (Html msg) -> Maybe String -> Html msg
card attrs children title =
    let
        withOptionalTitle =
            Maybe.map Card.withTitle title
                |> Maybe.withDefault identity
    in
    Card.init
        |> withOptionalTitle
        |> Card.view
            attrs
            [ Html.div
                [ css
                    [ displayFlex
                    , flexWrap wrap
                    , marginBottom (rem -2)
                    , marginRight (rem -1)
                    , Css.children
                        [ Css.everything
                            [ marginBottom (rem 2)
                            , marginRight (rem 1)
                            ]
                        ]
                    ]
                ]
                children
            ]


element : List (Attribute msg) -> List (Html msg) -> Html msg
element attrs =
    Html.div
        (css
            [ displayFlex
            , flexDirection column
            , flexBasis (pct 45)
            , flexGrow (num 1)
            ]
            :: attrs
        )


fullWidthElement : List (Attribute msg) -> List (Html msg) -> Html msg
fullWidthElement attrs =
    Html.div
        (css
            [ displayFlex
            , flexDirection column
            , flexBasis (pct 100)
            ]
            :: attrs
        )


label : List (Attribute msg) -> List (Html msg) -> Html msg
label attrs content =
    Text.textSmallLight
        |> Text.view
            (css
                [ lineHeight (rem 1.5) |> Css.important
                , color Colors.darkGray |> Css.important
                ]
                :: attrs
            )
            content


value : List (Attribute msg) -> List (Html msg) -> Html msg
value attrs content =
    Text.textLight |> Text.view attrs content
