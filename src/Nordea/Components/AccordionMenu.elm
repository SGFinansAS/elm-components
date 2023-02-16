module Nordea.Components.AccordionMenu exposing (content, header, view)

import Css exposing (alignItems, center, display, displayFlex, float, inlineBlock, justifyContent, listStyle, none, rem, right, spaceBetween, width)
import Css.Global exposing (children, class, descendants, typeSelector, withAttribute)
import Html.Styled as Html exposing (Attribute, Html, div)
import Html.Styled.Attributes exposing (attribute, css)
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
                [ children [ typeSelector "summary" [ listStyle none, descendants [ class "accordion-close-icon" [ display inlineBlock ], class "accordion-open-icon" [ display none ] ] ] ]
                , withAttribute "open" [ children [ typeSelector "summary" [ descendants [ class "accordion-close-icon" [ display none ], class "accordion-open-icon" [ display inlineBlock ] ] ] ] ]
                ]
                :: openAttr
    in
    Html.details attrs_ children_


header : List (Attribute msg) -> List (Html msg) -> Html msg
header attrs children =
    Html.summary
        (css [ displayFlex, alignItems center, justifyContent spaceBetween ] :: attrs)
        [ div [] children
        , div [ Html.Styled.Attributes.class "accordion-open-icon", css [ float right ] ] [ Icons.chevronDown [ css [ width (rem 1.5) ] ] ]
        , div [ Html.Styled.Attributes.class "accordion-close-icon", css [ float right ] ] [ Icons.chevronUp [ css [ width (rem 1.5) ] ] ]
        ]


content : List (Attribute msg) -> List (Html msg) -> Html msg
content attrs children =
    Html.div attrs children
