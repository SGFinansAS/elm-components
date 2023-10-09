module Nordea.Components.InformationDetails exposing
    ( card
    , collapsibleCard
    , element
    , fullWidthElement
    , label
    , value
    )

import Css
    exposing
        ( alignItems
        , auto
        , backgroundColor
        , borderRadius
        , center
        , color
        , column
        , cursor
        , displayFlex
        , ellipsis
        , flexBasis
        , flexDirection
        , flexGrow
        , flexWrap
        , hidden
        , lineHeight
        , marginBottom
        , marginLeft
        , marginRight
        , marginTop
        , maxWidth
        , num
        , overflow
        , padding
        , paddingRight
        , pct
        , pointer
        , rem
        , textOverflow
        , width
        , wrap
        )
import Css.Global as Css exposing (children)
import Css.Transitions exposing (transition)
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Html exposing (css)
import Nordea.Components.AccordionMenu as AccordionMenu
import Nordea.Components.Card as Card
import Nordea.Components.Text as Text
import Nordea.Html as Html
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Icons as Icons


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


collapsibleCard :
    { attrs : List (Attribute msg)
    , title : String
    , emphasisedText : String
    , isOpen : Bool
    , children : List (Html msg)
    }
    -> Html msg
collapsibleCard { attrs, title, emphasisedText, isOpen, children } =
    AccordionMenu.view { isOpen = isOpen }
        (css
            [ cursor Css.default
            , borderRadius (rem 0.5)
            , padding (rem 1.5)
            , backgroundColor Colors.white
            ]
            :: attrs
        )
        [ Html.summary
            (css [ displayFlex, alignItems center, cursor pointer ] :: attrs)
            [ Text.bodyTextHeavy |> Text.view [ css [] ] [ Html.text title ]
            , Text.textLight
                |> Text.view
                    [ css
                        [ marginLeft auto
                        , paddingRight (rem 0.75)
                        , maxWidth (rem 13.25)
                        , textOverflow ellipsis
                        , overflow hidden
                        , transition [ Css.Transitions.opacity3 400 0 Css.Transitions.ease ]
                        ]
                    , Html.class "accordion-closed-text"
                    ]
                    [ Html.text emphasisedText ]
            , Icons.chevronDown
                [ Html.class "accordion-open-icon"
                , css [ width (rem 1.25), color Colors.deepBlue ]
                ]
            , Icons.chevronUp
                [ Html.class "accordion-closed-icon"
                , css [ width (rem 1.25), color Colors.deepBlue ]
                ]
            ]
        , Html.wrappedRow
            [ css
                [ marginTop (rem 2)
                , marginBottom (rem -1.5)
                , marginRight (rem -1)
                , Css.children
                    [ Css.everything
                        [ marginBottom (rem 1.5)
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
