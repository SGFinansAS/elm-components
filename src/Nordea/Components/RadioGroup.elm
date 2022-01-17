module Nordea.Components.RadioGroup exposing (init, view, withErrorMessage)

import Css exposing (displayFlex, flexDirection, flexWrap, lineHeight, marginBottom, rem, row, wrap)
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes exposing (css)
import Nordea.Components.Common as Common


type alias RadioGroupProperties =
    { label : String
    , errorMessage : Maybe String
    }


type RadioGroup
    = RadioGroup RadioGroupProperties


init : String -> RadioGroup
init label =
    RadioGroup
        { label = label
        , errorMessage = Nothing
        }


view : List (Attribute msg) -> List (Html msg) -> RadioGroup -> Html msg
view attrs contents (RadioGroup properties) =
    Html.fieldset [ css [ Css.borderStyle Css.none, Css.padding (rem 0) ] ]
        ([ Html.legend [ css [ marginBottom (rem 0.5) ] ] [ Html.text properties.label ]
         , Html.div [ css [ displayFlex, flexWrap wrap, flexDirection row, Css.property "gap" "1rem" ] ] contents
         ]
            ++ Common.bottomInfo
                { labelText = properties.label
                , requirednessHint = Nothing
                , showFocusOutline = False
                , errorMessage = properties.errorMessage
                , hintText = Nothing
                , charCounter = Nothing
                }
        )


withErrorMessage : String -> RadioGroup -> RadioGroup
withErrorMessage errorMessage (RadioGroup properties) =
    RadioGroup { properties | errorMessage = Just errorMessage }
