module Nordea.Components.AccordionMenu exposing (header, view)

import Css
    exposing
        ( alignItems
        , auto
        , center
        , display
        , displayFlex
        , inlineBlock
        , listStyle
        , marginLeft
        , none
        , rem
        , width
        )
import Css.Global exposing (children, class, typeSelector, withAttribute)
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Html exposing (attribute, css)
import Nordea.Resources.Icons as Icons


type alias Config =
    { isOpen : Bool }


view : Config -> List (Attribute msg) -> List (Html msg) -> Html msg
view config attrs children_ =
    let
        openAttr =
            if config.isOpen then
                attribute "open" ""

            else
                attribute "" ""
    in
    Html.details
        (css
            [ children
                [ typeSelector "summary"
                    [ listStyle none
                    , children
                        [ class "accordion-open-icon" [ display inlineBlock ]
                        , class "accordion-closed-icon" [ display none ]
                        ]
                    ]
                ]
            , withAttribute "open"
                [ children
                    [ typeSelector "summary"
                        [ children
                            [ class "accordion-closed-icon" [ display inlineBlock ]
                            , class "accordion-open-icon" [ display none ]
                            ]
                        ]
                    ]
                ]
            ]
            :: openAttr
            :: attrs
        )
        children_


header : List (Attribute msg) -> List (Html msg) -> Html msg
header attrs children =
    Html.summary
        (css [ displayFlex, alignItems center ] :: attrs)
        (children
            ++ [ Icons.chevronDown
                    [ Html.class "accordion-open-icon"
                    , css [ marginLeft auto, width (rem 1.5) ]
                    ]
               , Icons.chevronUp
                    [ Html.class "accordion-closed-icon"
                    , css [ marginLeft auto, width (rem 1.5) ]
                    ]
               ]
        )
