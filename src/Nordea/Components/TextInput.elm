module Nordea.Components.TextInput exposing
    ( TextInput
    , init
    , view
    , withClearInput
    , withCurrency
    , withError
    , withMaxLength
    , withOnBlur
    , withOnEnterPress
    , withOnInput
    , withPattern
    , withPlaceholder
    , withSearchIcon
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
        , cursor
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
        , padding4
        , paddingLeft
        , paddingRight
        , pct
        , pointer
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
import Html.Styled.Attributes as Html
    exposing
        ( css
        , maxlength
        , pattern
        , placeholder
        , tabindex
        , value
        )
import Html.Styled.Events exposing (keyCode, on, onBlur, onClick, onInput)
import Json.Decode as Json
import Maybe.Extra as Maybe
import Nordea.Components.Text as Text
import Nordea.Html as Html exposing (showIf, styleIf)
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
    , hasClearIcon : Bool
    , onBlur : Maybe msg
    , onEnterPress : Maybe msg
    , currency : Maybe String
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
        , hasClearIcon = False
        , onBlur = Nothing
        , onEnterPress = Nothing
        , currency = Nothing
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


withOnBlur : msg -> TextInput msg -> TextInput msg
withOnBlur msg (TextInput config) =
    TextInput { config | onBlur = Just msg }


withOnEnterPress : msg -> TextInput msg -> TextInput msg
withOnEnterPress msg (TextInput config) =
    TextInput { config | onEnterPress = Just msg }


withCurrency : String -> TextInput msg -> TextInput msg
withCurrency currency (TextInput config) =
    TextInput { config | currency = Just currency }


withClearInput : TextInput msg -> TextInput msg
withClearInput (TextInput config) =
    TextInput
        { config
            | hasClearIcon = True
        }


onEnterPress : msg -> Attribute msg
onEnterPress msg =
    let
        isEnter code =
            if code == 13 then
                Json.succeed msg

            else
                Json.fail "not ENTER"
    in
    on "keydown" (Json.andThen isEnter keyCode)



-- VIEW


view : List (Attribute msg) -> TextInput msg -> Html msg
view attributes (TextInput config) =
    let
        viewSearchIcon =
            if config.hasSearchIcon then
                Icons.search
                    [ css
                        [ width (rem 1)
                        , height (rem 1)
                        , opacity (num 0.5)
                        , position absolute
                        , color
                            (if config.showError then
                                Colors.darkRed

                             else
                                Colors.nordeaBlue
                            )
                        , left (rem 0.7)
                        , top (pct 50)
                        , transform (translateY (pct -50))
                        , pointerEvents none
                        ]
                    ]

            else
                Html.nothing

        viewClearIcon =
            if config.hasClearIcon then
                Icons.roundedCross
                    (Maybe.values
                        [ Just
                            (css
                                [ width (rem 2.5)
                                , color Colors.mediumGray
                                , position absolute
                                , padding4 (rem 0.35) (rem 0.25) (rem 0.25) (rem 0.25)
                                , right (rem 0)
                                , cursor pointer
                                ]
                            )
                        , config.onInput |> Maybe.map (\onInput -> onClick (onInput ""))
                        , Just (tabindex 0)
                        ]
                    )
                    |> showIf (config.value |> String.isEmpty |> not)

            else
                Html.nothing
    in
    Html.div
        (css [ displayFlex, position relative ] :: attributes)
        [ viewSearchIcon
        , styled input
            (getStyles config)
            (getAttributes config ++ attributes)
            []
        , viewCurrency config
        , viewClearIcon
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


getAttributes : Config msg -> List (Attribute msg)
getAttributes config =
    Maybe.values
        [ config.value |> value |> Just
        , config.onInput |> Maybe.map onInput
        , config.placeholder |> Maybe.map placeholder
        , config.maxLength |> Maybe.map maxlength
        , config.pattern |> Maybe.map pattern
        , config.onBlur |> Maybe.map onBlur
        , config.onEnterPress |> Maybe.map onEnterPress
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
    in
    [ fontSize (rem 1)
    , height (rem 2.5)
    , padding2 (rem 0) (rem 0.75)
    , borderRadius (rem 0.25)
    , border3 (rem 0.0625) solid borderColorStyle
    , boxSizing borderBox
    , width (pct 100)
    , disabled [ backgroundColor Colors.grayWarm ]
    , paddingLeft (rem 2) |> styleIf config.hasSearchIcon
    , paddingRight (rem 3)
        |> styleIf
            ((config.value |> String.isEmpty |> not)
                && config.hasClearIcon
            )
    , focus
        [ outline none
        , Themes.borderColor Colors.nordeaBlue
        ]
    ]
