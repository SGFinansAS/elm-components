module Nordea.Components.AccordionMenu exposing (OptionalConfig(..), Status(..), content, header, view)

import Css exposing (alignItems, center, display, displayFlex, float, inlineBlock, justifyContent, lastChild, listStyle, none, nthLastChild, rem, right, spaceBetween, width)
import Css.Global exposing (children, typeSelector, withAttribute)
import Html.Styled as Html exposing (Attribute, Html, div)
import Html.Styled.Attributes exposing (attribute, css)
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
