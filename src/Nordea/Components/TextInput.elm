module Nordea.Components.TextInput exposing
    ( TextInput
    , init
    , view
    , withDisabled
    , withError
    , withMaxLength
    , withOnInput
    , withPattern
    , withPlaceholder
    )

import Css
    exposing
        ( Style
        , backgroundColor
        , border3
        , borderBox
        , borderColor
        , borderRadius
        , boxSizing
        , em
        , focus
        , fontSize
        , height
        , none
        , outline
        , padding2
        , pct
        , property
        , rem
        , solid
        , width
        )
import Html.Styled exposing (Attribute, Html, input, styled)
import Html.Styled.Attributes as Attributes exposing (maxlength, pattern, placeholder, value)
import Html.Styled.Events exposing (onInput)
import Maybe.Extra as Maybe
import Nordea.Resources.Colors as Colors
import Nordea.Themes as Themes



-- CONFIG


type alias Config msg =
    { value : String
    , onInput : Maybe (String -> msg)
    , placeholder : Maybe String
    , showError : Bool
    , maxLength : Maybe Int
    , pattern : Maybe String
    , disabled : Bool
    }


type TextInput msg
    = TextInput (Config msg)


init : String -> TextInput msg
init value =
    TextInput
        { value = value
        , onInput = Nothing
        , placeholder = Nothing
        , showError = False
        , maxLength = Nothing
        , pattern = Nothing
        , disabled = False
        }


withOnInput : (String -> msg) -> TextInput msg -> TextInput msg
withOnInput onInput (TextInput config) =
    TextInput { config | onInput = Just onInput }


withPlaceholder : String -> TextInput msg -> TextInput msg
withPlaceholder placeholder (TextInput config) =
    TextInput { config | placeholder = Just placeholder }


withMaxLength : Int -> TextInput msg -> TextInput msg
withMaxLength maxLength (TextInput config) =
    TextInput { config | maxLength = Just maxLength }


withPattern : String -> TextInput msg -> TextInput msg
withPattern pattern (TextInput config) =
    TextInput { config | pattern = Just pattern }


withError : Bool -> TextInput msg -> TextInput msg
withError condition (TextInput config) =
    TextInput { config | showError = condition }


withDisabled : Bool -> TextInput msg -> TextInput msg
withDisabled condition (TextInput config) =
    TextInput { config | disabled = condition }



-- VIEW


view : List (Attribute msg) -> TextInput msg -> Html msg
view attributes (TextInput config) =
    styled input
        (getStyles config)
        (getAttributes config ++ attributes)
        []


getAttributes : Config msg -> List (Attribute msg)
getAttributes config =
    Maybe.values
        [ Just config.value |> Maybe.map value
        , config.onInput |> Maybe.map onInput
        , config.placeholder |> Maybe.map placeholder
        , config.maxLength |> Maybe.map maxlength
        , config.pattern |> Maybe.map pattern
        , Just config.disabled |> Maybe.map Attributes.disabled
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
    [ fontSize (rem 0.8)
    , height (em 2)
    , padding2 (em 0.65) (em 0.65)
    , borderRadius (em 0.125)
    , border3 (em 0.0625) solid borderColorStyle
    , boxSizing borderBox
    , width (pct 70)
    , Css.disabled
        [ backgroundColor Colors.grayWarm
        ]
    , focus
        [ outline none
        , Themes.borderColor Themes.PrimaryColorLight Colors.blueNordea
        ]
    ]
