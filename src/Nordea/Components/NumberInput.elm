module Nordea.Components.NumberInput exposing
    ( NumberInput
    , init
    , view
    , withError
    , withFormatter
    , withKrSuffix
    , withLeftAlignment
    , withMax
    , withMin
    , withOnBlur
    , withOnInput
    , withPctSuffix
    , withPlaceholder
    , withSmallSize
    , withStep
    )

import Css
    exposing
        ( Style
        , absolute
        , alignItems
        , backgroundColor
        , border3
        , borderBox
        , borderRadius
        , boxSizing
        , center
        , color
        , cursor
        , default
        , disabled
        , display
        , displayFlex
        , focus
        , fontSize
        , height
        , left
        , none
        , outline
        , padding4
        , pct
        , position
        , property
        , pseudoElement
        , relative
        , rem
        , right
        , solid
        , textAlign
        , width
        )
import Html.Styled as Html exposing (Attribute, Html, input, styled)
import Html.Styled.Attributes as Attributes exposing (css, placeholder, step, type_, value)
import Html.Styled.Events exposing (onBlur, onInput)
import Maybe.Extra as Maybe
import Nordea.Resources.Colors as Colors exposing (nordeaGray)
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
    , size : Size
    , alignment : Alignment
    , suffix : Maybe Suffix
    }


type Suffix
    = Kr
    | Pct


toString : Suffix -> String
toString suffix =
    case suffix of
        Kr ->
            "KR"

        Pct ->
            "%"


type Alignment
    = Left
    | Right


type Size
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
        , size = Standard
        , alignment = Right
        , suffix = Nothing
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
    NumberInput { config | size = Small }


withLeftAlignment : NumberInput msg -> NumberInput msg
withLeftAlignment (NumberInput config) =
    NumberInput { config | alignment = Left }


withPctSuffix : NumberInput msg -> NumberInput msg
withPctSuffix (NumberInput config) =
    NumberInput { config | suffix = Just Pct }


withKrSuffix : NumberInput msg -> NumberInput msg
withKrSuffix (NumberInput config) =
    NumberInput { config | suffix = Just Kr }



-- VIEW


view : List (Attribute msg) -> NumberInput msg -> Html msg
view attributes (NumberInput config) =
    Html.div [ css [ position relative, displayFlex, alignItems center ] ]
        [ styled input
            (getStyles config)
            (getAttributes config ++ attributes)
            []
        , Html.div
            [ css
                ([ position absolute
                 , right (rem 0.5)
                 , cursor default

                 --    , zIndex (int 99) --otherwise invisible on focus
                 , color nordeaGray
                 ]
                    ++ getFontSize config.size
                )
            ]
            [ Html.text (config.suffix |> Maybe.map toString |> Maybe.withDefault "") ]
        ]


getAttributes : Config msg -> List (Attribute msg)
getAttributes config =
    let
        format : String -> String
        format value =
            if String.endsWith "." value || String.endsWith "," value then
                value

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
        [ "text" |> type_ |> Just
        , config.min |> Maybe.map String.fromFloat |> Maybe.map Attributes.min
        , config.max |> Maybe.map String.fromFloat |> Maybe.map Attributes.max
        , config.step |> Maybe.map String.fromFloat |> Maybe.map step
        , config.placeholder |> Maybe.map placeholder
        , config.onInput |> Maybe.map onInput
        , config.onBlur |> Maybe.map onBlur
        , config.value |> format |> value |> Just
        ]



-- STYLES


getStyles : Config msg -> List Style
getStyles config =
    let
        borderColorStyle =
            if config.showError then
                Colors.darkRed

            else
                Colors.mediumGray

        rightPaddingAdditionDueToIcon =
            case config.suffix of
                Nothing ->
                    0

                Just Kr ->
                    1.5

                Just Pct ->
                    1.5

        sizeSpecificStyling =
            (case config.size of
                Small ->
                    [ height (rem 1.5)
                    , padding4 (rem 0.25) (rem (0.5 + rightPaddingAdditionDueToIcon)) (rem 0.25) (rem 0.5)
                    ]

                Standard ->
                    [ height (rem 2.5)
                    , padding4 (rem 0) (rem (0.75 + rightPaddingAdditionDueToIcon)) (rem 0) (rem 0.75)
                    ]
            )
                ++ getFontSize config.size

        textAlignValue =
            case config.alignment of
                Left ->
                    left

                Right ->
                    right
    in
    [ pseudoElement "-webkit-outer-spin-button" [ display none ]
    , pseudoElement "-webkit-inner-spin-button" [ display none ]
    , property "-moz-appearance" "textfield"
    , textAlign textAlignValue
    , borderRadius (rem 0.25)
    , border3 (rem 0.0625) solid borderColorStyle
    , boxSizing borderBox
    , width (pct 100)
    , disabled [ backgroundColor Colors.grayWarm ]
    , focus
        [ outline none
        , Themes.borderColor Colors.nordeaBlue
        ]
    ]
        ++ sizeSpecificStyling


getFontSize : Size -> List Style
getFontSize size =
    case size of
        Small ->
            [ fontSize (rem 0.75) ]

        Standard ->
            [ fontSize (rem 1) ]
