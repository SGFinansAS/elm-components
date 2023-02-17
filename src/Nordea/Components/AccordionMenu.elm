module Nordea.Components.AccordionMenu exposing (content, header, view)

import Css exposing (alignItems, center, display, displayFlex, inlineBlock, justifyContent, listStyle, none, rem, spaceBetween, width)
import Css.Global exposing (children, class, descendants, typeSelector, withAttribute)
import Html.Styled as Html exposing (Attribute, Html, div)
import Html.Styled.Attributes as Html exposing (attribute, css)
import Nordea.Resources.Icons as Icons


type alias Config =
    { isOpen : Bool }


view : Config -> List a -> List (Attribute msg) -> List (Html msg) -> Html msg
view config _ attrs children_ =
    let
        openAttr =
            if config.isOpen then
                attribute "open" "" :: attrs

            else
                attrs

        attrs_ =
            css
                [ children [ typeSelector "summary" [ listStyle none, descendants [ class "accordion-closed-icon" [ display inlineBlock ], class "accordion-open-icon" [ display none ] ] ] ]
                , withAttribute "open" [ children [ typeSelector "summary" [ descendants [ class "accordion-closed-icon" [ display none ], class "accordion-open-icon" [ display inlineBlock ] ] ] ] ]
                ]
                :: openAttr
    in
    Html.details attrs_ children_


header : List (Attribute msg) -> List (Html msg) -> Html msg
header attrs children =
    Html.summary
        (css [ displayFlex, alignItems center, justifyContent spaceBetween ] :: attrs)
        [ div [] children
        , Icons.chevronDown [ Html.class "accordion-open-icon", css [ width (rem 1.5) ] ]
        , Icons.chevronUp [ Html.class "accordion-closed-icon", css [ width (rem 1.5) ] ]
        ]


content : List (Attribute msg) -> List (Html msg) -> Html msg
content attrs children =
    Html.div attrs children
