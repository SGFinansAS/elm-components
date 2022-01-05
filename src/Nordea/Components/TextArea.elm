module Nordea.Components.TextArea exposing
    ( TextArea
    , init
    , view
    )

import Css
    exposing
        ( Style
        , absolute
        , backgroundColor
        , border3
        , borderBox
        , borderRadius
        , boxSizing
        , disabled
        , displayFlex
        , focus
        , fontSize
        , height
        , left
        , none
        , num
        , opacity
        , outline
        , padding2
        , paddingLeft
        , pct
        , pointerEvents
        , position
        , relative
        , rem
        , solid
        , top
        , transform
        , translateY
        , width
        )
import Html.Styled as Html exposing (Attribute, Html, input, styled, textarea, text)
import Html.Styled.Attributes exposing (css, maxlength, pattern, placeholder, value)
import Html.Styled.Events exposing (onInput)
import Maybe.Extra as Maybe
import Nordea.Html exposing (styleIf)
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Icons as Icons
import Nordea.Themes as Themes



-- CONFIG


type alias Config msg =
    { value : String
    , onInput : Maybe (String -> msg)
    , placeholder : Maybe String
    , showError : Bool
    }


type TextArea msg
    = TextArea (Config msg)


init : String -> TextArea msg
init value =
    TextArea
        { value = value
        , onInput = Nothing
        , placeholder = Nothing
        , showError = False
        }

-- VIEW


view : List (Attribute msg) -> TextArea msg -> Html msg
view attributes (TextArea config) =
    textarea [] [text "👋"]
