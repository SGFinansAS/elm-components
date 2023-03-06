module Nordea.Components.TextArea exposing
    ( TextArea
    , init
    , view
    , withError
    , withMaxLength
    , withOnBlur
    , withOnInput
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
        , focus
        , lineHeight
        , none
        , outline
        , overflow
        , padding2
        , rem
        , resize
        , solid
        )
import Html.Styled exposing (Attribute, Html, styled, textarea)
import Html.Styled.Attributes as Attrs exposing (maxlength, placeholder, value)
import Html.Styled.Events exposing (onBlur, onInput)
import Maybe.Extra as Maybe
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Fonts.Fonts as Fonts
import Nordea.Themes as Themes



-- CONFIG


type alias Config msg =
    { value : String
    , onInput : Maybe (String -> msg)
    , placeholder : Maybe String
    , showError : Bool
    , onBlur : Maybe msg
    , maxLength : Maybe Int
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
        , onBlur = Nothing
        , maxLength = Nothing
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


withOnBlur : msg -> TextArea msg -> TextArea msg
withOnBlur onBlur (TextArea config) =
    TextArea { config | onBlur = Just onBlur }


withMaxLength : Int -> TextArea msg -> TextArea msg
withMaxLength maxLength (TextArea config) =
    TextArea { config | maxLength = Just maxLength }



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
        , config.onBlur |> Maybe.map onBlur
        , config.maxLength |> Maybe.map maxlength

        -- Disable the Grammarly browser extension to avoid crashing Elm.
        , Just (Attrs.attribute "data-gramm" "false")
        , Just (Attrs.attribute "data-gramm_editor" "false")
        , Just (Attrs.attribute "data-enable-grammarly" "false")
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
    , padding2 (rem 0.5) (rem 0.75)
    , borderRadius (rem 0.25)
    , border3 (rem 0.0625) solid borderColorStyle
    , boxSizing borderBox
    , disabled [ backgroundColor Colors.grayWarm ]
    , lineHeight (rem 1.5)
    , resize none
    , overflow auto
    , focus
        [ outline none
        , Themes.borderColor Colors.blueNordea
        ]
    ]
