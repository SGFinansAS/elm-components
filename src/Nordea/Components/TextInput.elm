module Nordea.Components.TextInput exposing
    ( TextInput
    , init
    , view
    , withError
    , withMaxLength
    , withOnInput
    , withPattern
    , withPlaceholder
    , withSearchIcon
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
import Html.Styled as Html exposing (Attribute, Html, input, styled)
import Html.Styled.Attributes exposing (css, maxlength, pattern, placeholder, value)
import Html.Styled.Events exposing (onInput)
import Maybe.Extra as Maybe
import Nordea.Html exposing (showIf, styleIf)
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Icons as Icons
import Nordea.Themes as Themes



-- CONFIG


type alias Config msg =
    { value : String
    , onInput : Maybe (String -> msg)
    , placeholder : Maybe String
    , showError : Bool
    , maxLength : Maybe Int
    , pattern : Maybe String
    , hasSearchIcon : Bool
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
        , hasSearchIcon = False
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


withSearchIcon : Bool -> TextInput msg -> TextInput msg
withSearchIcon condition (TextInput config) =
    TextInput { config | hasSearchIcon = condition }



-- VIEW


view : List (Attribute msg) -> TextInput msg -> Html msg
view attributes (TextInput config) =
    Html.div [ css [ position relative ] ]
        [ Html.span
            [ css
                [ position absolute
                , left (rem 0.7)
                , top (pct 50)
                , transform (translateY (pct -50))
                , displayFlex
                , alignItems center
                , pointerEvents none
                ]
            ]
            [ Icons.search [ css [ width (rem 1.4), opacity (num 0.5) ] ] ]
            |> showIf config.hasSearchIcon
        , styled input
            (getStyles config)
            (getAttributes config ++ attributes)
            []
        ]


getAttributes : Config msg -> List (Attribute msg)
getAttributes config =
    Maybe.values
        [ Just config.value |> Maybe.map value
        , config.onInput |> Maybe.map onInput
        , config.placeholder |> Maybe.map placeholder
        , config.maxLength |> Maybe.map maxlength
        , config.pattern |> Maybe.map pattern
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
    [ fontSize (rem 1)
    , height (rem 3)
    , padding2 (rem 0.75) (rem 0.75)
    , borderRadius (rem 0.25)
    , border3 (rem 0.0625) solid borderColorStyle
    , boxSizing borderBox
    , width (pct 100)
    , disabled [ backgroundColor Colors.grayWarm ]
    , paddingLeft (rem 2.5) |> styleIf config.hasSearchIcon
    , focus
        [ outline none
        , Themes.borderColor Themes.PrimaryColorLight Colors.blueNordea
        ]
    ]
