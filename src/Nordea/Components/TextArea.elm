module Nordea.Components.TextArea exposing
    ( TextArea
    , init
    , view
    , withOnInput
    , withError
    , withPlaceholder
    )

import Css
    exposing
        ( Style
        , auto
        , backgroundColor
        , border3
        , borderBox
        , borderRadius
        , boxSizing
        , disabled
        , displayFlex
        , focus
        , fontFamilies
        , fontSize
        , hidden
        , lineHeight
        , maxWidth
        , none
        , outline
        , overflow
        , padding4
        , relative
        , rem
        , resize
        , solid
        )
import Html.Styled as Html exposing (Attribute, Html, styled, text, textarea)
import Html.Styled.Attributes exposing (css, pattern, placeholder, value)
import Html.Styled.Events exposing (onInput)
import Maybe.Extra as Maybe
import Nordea.Html exposing (styleIf)
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Fonts as Fonts
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

withOnInput : (String -> msg) -> TextArea msg -> TextArea msg
withOnInput onInput (TextArea config) =
    TextArea { config | onInput = Just onInput }

withPlaceholder : String -> TextArea msg -> TextArea msg
withPlaceholder placeholder (TextArea config) =
    TextArea { config | placeholder = Just placeholder }


withError : Bool -> TextArea msg -> TextArea msg
withError condition (TextArea config) =
    TextArea { config | showError = condition }



-- VIEW


view : List (Attribute msg) -> TextArea msg -> Html msg
view attributes (TextArea config) =
    styled textarea
        (getStyles config)
        (getAttributes config ++ attributes)
        []


getAttributes : Config msg -> List (Attribute msg)
getAttributes config =
    Maybe.values
        [ Just config.value |> Maybe.map value
        , config.onInput |> Maybe.map onInput
        , config.placeholder |> Maybe.map placeholder
        ]



-- STYLES


getStyles : Config msg -> List Style
getStyles config =
    let
        borderColorStyle =
            if config.showError then
                Colors.redDark

            else
                Colors.grayMedium
    in
    [ Fonts.fromSize 1
    , padding4 (rem 0.5) (rem 0.75) (rem 0.5) (rem 0.75)
    , borderRadius (rem 0.25)
    , border3 (rem 0.0625) solid borderColorStyle
    , boxSizing borderBox
    , disabled [ backgroundColor Colors.grayWarm ]
    , lineHeight (rem 1.5)
    , resize none
    , overflow auto
    , focus
        [ outline none
        , Themes.borderColor Themes.PrimaryColorLight Colors.blueNordea
        ]
    ]
