module Nordea.Components.AccordionMenu exposing (OptionalConfig(..), Status(..), content, header, view)

import Css exposing (after, alignItems, auto, block, bottom, center, color, content, cursor, display, displayFlex, first, flexEnd, float, fontSize, fontWeight, inline, inlineBlock, justifyContent, lastChild, left, listStyle, listStyleType, marginRight, marginTop, middle, none, normal, nthLastChild, overflow, paddingLeft, pointer, property, px, rem, rgb, right, scaleX, spaceBetween, sub, super, tableCell, textAlign, textDecoration, top, underline, verticalAlign, vh, vmin, vw, width)
import Css.Global exposing (children, class, descendants, global, selector, typeSelector, withAttribute)
import Css.Media exposing (grid)
import Css.Transitions exposing (transform)
import Html.Styled as Html exposing (Attribute, Html, div, li, p, span, styled, text, ul)
import Html.Styled.Attributes exposing (attribute, css)
import Html.Styled.Events exposing (onClick)
import Nordea.Components.Text as Text exposing (Headline)
import Nordea.Resources.Colors exposing (red)
import Nordea.Resources.Icons as Icons


type Status
    = Open
    | Closed


type OptionalConfig
    = Status Status


view : List OptionalConfig -> List (Attribute msg) -> List (Html msg) -> Html msg
view config attrs children_ =
    let
        config_ =
            config
                |> List.foldl
                    (\attr acc ->
                        case attr of
                            Status x ->
                                { acc | status = x }
                    )
                    { status = Open }

        openAttr =
            case config_.status of
                Open ->
                    attribute "open" "" :: attrs

                Closed ->
                    attrs

        attrs_ =
            css
                [ children [ typeSelector "summary" [ listStyle none, children [ typeSelector "div" [ lastChild [ display inlineBlock ], nthLastChild "2" [ display none ] ] ] ] ]
                , withAttribute "open" [ children [ typeSelector "summary" [ children [ typeSelector "div" [ lastChild [ display none ], nthLastChild "2" [ display inlineBlock ] ] ] ] ] ]
                ]
                :: openAttr
    in
    Html.details attrs_ children_


header : List (Attribute msg) -> List (Html msg) -> Html msg
header attrs children =
    Html.summary
        (css [ displayFlex, alignItems center, justifyContent spaceBetween ] :: attrs)
        (List.append [ div [] children ]
            [ div [ css [ float right ] ] [ Icons.chevronDown [ css [ width (rem 1.5) ] ] ]
            , div [ css [ float right ] ] [ Icons.chevronLeft [ css [ width (rem 1.5) ] ] ]
            ]
        )


content : List (Attribute msg) -> List (Html msg) -> Html msg
content attrs children =
    Html.div attrs children
