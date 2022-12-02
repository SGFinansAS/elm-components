module Nordea.Components.NumberInput exposing
    ( NumberInput
    , init
    , view
    , withError
    , withFormatter
    , withMax
    , withMin
    , withOnBlur
    , withOnInput
    , withPlaceholder
    , withSmallSize
    , withStep
    )

import Css exposing (Style, backgroundColor, border3, borderBox, borderRadius, boxSizing, disabled, display, focus, fontSize, height, none, outline, padding2, pct, property, pseudoElement, rem, right, solid, textAlign, width)
import Html.Styled exposing (Attribute, Html, input, styled)
import Html.Styled.Attributes as Attributes exposing (placeholder, step, type_, value)
import Html.Styled.Events exposing (onBlur, onInput)
import Maybe.Extra as Maybe
import Nordea.Css as NordeaCss
import Nordea.Resources.Colors as Colors
import Nordea.Themes as Themes



-- CONFIG


type alias Config msg =
    { value : String
    , min : Maybe Float
    , max : Maybe Float
    , step : Maybe Float
    , placeholder : Maybe String
    , onInput : Maybe (String -> msg)
    , showError : Bool
    , onBlur : Maybe msg
    , formatter : Maybe (Float -> String)
    , variant : Variant
    }


type Variant
    = Small
    | Standard


type NumberInput msg
    = NumberInput (Config msg)


init : String -> NumberInput msg
init value =
    NumberInput
        { value = value
        , min = Nothing
        , max = Nothing
        , step = Nothing
        , placeholder = Nothing
        , onInput = Nothing
        , showError = False
        , onBlur = Nothing
        , formatter = Nothing
        , variant = Standard
        }


withMin : Float -> NumberInput msg -> NumberInput msg
withMin min (NumberInput config) =
    NumberInput { config | min = Just min }


withMax : Float -> NumberInput msg -> NumberInput msg
withMax max (NumberInput config) =
    NumberInput { config | max = Just max }


withStep : Float -> NumberInput msg -> NumberInput msg
withStep step (NumberInput config) =
    NumberInput { config | step = Just step }


withPlaceholder : String -> NumberInput msg -> NumberInput msg
withPlaceholder placeholder (NumberInput config) =
    NumberInput { config | placeholder = Just placeholder }


withOnInput : (String -> msg) -> NumberInput msg -> NumberInput msg
withOnInput onInput (NumberInput config) =
    NumberInput { config | onInput = Just onInput }


withError : Bool -> NumberInput msg -> NumberInput msg
withError condition (NumberInput config) =
    NumberInput { config | showError = condition }


withOnBlur : msg -> NumberInput msg -> NumberInput msg
withOnBlur msg (NumberInput config) =
    NumberInput { config | onBlur = Just msg }


withFormatter : Maybe (Float -> String) -> NumberInput msg -> NumberInput msg
withFormatter formatter (NumberInput config) =
    NumberInput { config | formatter = formatter }


withSmallSize : NumberInput msg -> NumberInput msg
withSmallSize (NumberInput config) =
    NumberInput { config | variant = Small }



-- VIEW


view : List (Attribute msg) -> NumberInput msg -> Html msg
view attributes (NumberInput config) =
    styled input
        (getStyles config)
        (getAttributes config ++ attributes)
        []


getAttributes : Config msg -> List (Attribute msg)
getAttributes config =
    let
        format value =
            if value == "" then
                ""

            else
                Maybe.map2 (\formatter val -> val |> formatter)
                    config.formatter
                    (value
                        |> String.replace "," "."
                        |> String.replace " " ""
                        |> String.toFloat
                    )
                    |> Maybe.withDefault value
    in
    Maybe.values
        [ Just "text" |> Maybe.map type_
        , config.min |> Maybe.map String.fromFloat |> Maybe.map Attributes.min
        , config.max |> Maybe.map String.fromFloat |> Maybe.map Attributes.max
        , config.step |> Maybe.map String.fromFloat |> Maybe.map step
        , config.placeholder |> Maybe.map placeholder
        , config.onInput |> Maybe.map onInput
        , config.onBlur |> Maybe.map onBlur
        , Just config.value |> Maybe.map format |> Maybe.map value
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

        inputHeight =
            case config.variant of
                Standard ->
                    NordeaCss.standardInputHeight

                Small ->
                    NordeaCss.smallInputHeight
    in
    [ fontSize (rem 1)
    , height inputHeight
    , pseudoElement "-webkit-outer-spin-button" [ display none ]
    , pseudoElement "-webkit-inner-spin-button" [ display none ]
    , property "-moz-appearance" "textfield"
    , textAlign right
    , padding2 (rem 0.75) (rem 0.75)
    , borderRadius (rem 0.25)
    , border3 (rem 0.0625) solid borderColorStyle
    , boxSizing borderBox
    , width (pct 100)
    , disabled [ backgroundColor Colors.grayWarm ]
    , focus
        [ outline none
        , Themes.borderColor Themes.PrimaryColorLight Colors.blueNordea
        ]
    ]
