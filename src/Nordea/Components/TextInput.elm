module Nordea.Components.TextInput exposing
    ( TextInput
    , init
    , view
    , withCurrency
    , withMaxLength
    , withOnBlur
    , withOnEnterPress
    , withOnInput
    , withPattern
    , withPlaceholder
    , withSearchIcon
    , withSmallSize
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
        , color
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
        , right
        , solid
        , top
        , transform
        , translateY
        , width
        )
import Html.Styled as Html exposing (Attribute, Html, input, styled)
import Html.Styled.Attributes exposing (css, maxlength, pattern, placeholder, value)
import Html.Styled.Events exposing (keyCode, on, onBlur, onInput)
import Json.Decode as Json
import Maybe.Extra as Maybe
import Nordea.Components.Text as Text
import Nordea.Css as NordeaCss
import Nordea.Html as Html exposing (styleIf)
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Icons as Icons
import Nordea.Themes as Themes



-- CONFIG


type alias Config =
    { value : String
    , hasSearchIcon : Bool
    , size : Size
    , currency : Maybe String
    }


type Size
    = Small
    | Large


type TextInput
    = TextInput Config


init : String -> TextInput
init value =
    TextInput
        { value = value
        , hasSearchIcon = False
        , size = Large
        , currency = Nothing
        }


withSearchIcon : Bool -> TextInput -> TextInput
withSearchIcon condition (TextInput config) =
    TextInput { config | hasSearchIcon = condition }


withSmallSize : TextInput -> TextInput
withSmallSize (TextInput config) =
    TextInput { config | size = Small }


withCurrency : String -> TextInput -> TextInput
withCurrency currency (TextInput config) =
    TextInput { config | currency = Just currency }



-- VIEW


view : List (Attribute msg) -> TextInput -> Html msg
view attributes (TextInput config) =
    let
        borderColorStyle =
            if config.showError then
                Colors.redDark

            else
                Colors.grayMedium

        lol =
            [ fontSize (rem 1)
            , height
                (case config.size of
                    Small ->
                        NordeaCss.smallInputHeight

                    Large ->
                        NordeaCss.standardInputHeight
                )
            , padding2 (rem 0.75) (rem 0.75)
            , borderRadius (rem 0.25)
            , border3 (rem 0.0625) solid borderColorStyle
            , boxSizing borderBox
            , width (pct 100)
            , disabled [ backgroundColor Colors.grayWarm ]
            , paddingLeft (rem 2) |> styleIf config.hasSearchIcon
            , focus
                [ outline none
                , Themes.borderColor Themes.PrimaryColorLight Colors.blueNordea
                ]
            ]

        lal =
            Maybe.values
                [ Just config.value |> Maybe.map value
                , config.onInput |> Maybe.map onInput
                , config.placeholder |> Maybe.map placeholder
                , config.maxLength |> Maybe.map maxlength
                , config.pattern |> Maybe.map pattern
                , config.onBlur |> Maybe.map onBlur
                , config.onEnterPress |> Maybe.map onEnterPress
                ]
    in
    if config.hasSearchIcon then
        Html.div
            (css [ displayFlex, position relative ] :: attributes)
            [ Icons.search
                [ css
                    [ width (rem 1)
                    , opacity (num 0.5)
                    , position absolute
                    , left (rem 0.7)
                    , top (pct 50)
                    , transform (translateY (pct -50))
                    , pointerEvents none
                    ]
                ]
            , Html.input
                (getStyles config)
                (getAttributes config)
                []
            , viewCurrency config
            ]

    else
        Html.div
            (css [ displayFlex, position relative ] :: attributes)
            [ Html.input
                (getStyles config)
                (getAttributes config ++ attributes)
                []
            , viewCurrency config
            ]


viewCurrency : Config msg -> Html msg
viewCurrency config =
    config.currency
        |> Html.viewMaybe
            (\currency ->
                Text.textHeavy
                    |> Text.view
                        [ css
                            [ position absolute
                            , right (rem 0.7)
                            , top (pct 30)
                            ]
                        ]
                        [ currency
                            |> String.slice 0 3
                            |> String.toUpper
                            |> Html.text
                        ]
            )
