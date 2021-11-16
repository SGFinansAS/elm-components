module Nordea.Components.TextArea exposing
    ( init
    , view
    , withHasError
    , withMaxLength
    , withOnBlur
    , withPlaceholder
    )

import Css
    exposing
        ( backgroundColor
        , border3
        , borderColor
        , borderRadius
        , focus
        , fontFamilies
        , fontSize
        , lineHeight
        , minHeight
        , none
        , outline
        , padding
        , pct
        , rem
        , solid
        , width
        )
import Css.Global exposing (withAttribute)
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attrs exposing (css, disabled, maxlength, placeholder, value)
import Html.Styled.Events exposing (onBlur, onInput)
import Maybe.Extra as Maybe
import Nordea.Html exposing (maybeAttr, styleIf)
import Nordea.Resources.Colors as Colors


type alias InputProperties msg =
    { placeholder : Maybe String
    , value : String
    , onInput : String -> msg
    , onBlur : Maybe msg
    , isDisabled : Bool
    , hasError : Bool
    , maxlength : Int
    }


type TextArea msg
    = TextArea (InputProperties msg)


init : (String -> msg) -> String -> TextArea msg
init onInput contentValue =
    TextArea
        { placeholder = Nothing
        , value = contentValue
        , onInput = onInput
        , onBlur = Nothing
        , isDisabled = False
        , hasError = False
        , maxlength = 120
        }


view : List (Attribute msg) -> TextArea msg -> Html msg
view attrs (TextArea config) =
    Html.textarea
        ([ onInput config.onInput
         , config.placeholder |> Maybe.map placeholder |> maybeAttr
         , disabled config.isDisabled
         , maxlength config.maxlength
         , css
            [ width (pct 100)
            , minHeight (rem 6)
            , padding (rem 0.75)
            , border3 (rem 0.0625) solid Colors.grayMedium
            , borderColor Colors.redDark |> styleIf config.hasError
            , borderRadius (rem 0.25)
            , outline none
            , focus [ Colors.inputOutline ]
            , withAttribute "disabled" [ backgroundColor Colors.grayCool ]
            , fontFamilies [ "Nordea Sans Small", "sans-serif" ]
            , fontSize (rem 1)
            , lineHeight (rem 1.5)
            ]
         , value config.value
         , maybeAttr (config.onBlur |> Maybe.map onBlur)
         , disableGrammarlyBrowserExtension
         ]
            ++ attrs
        )
        []


withHasError : Bool -> TextArea msg -> TextArea msg
withHasError hasError (TextArea config) =
    TextArea { config | hasError = hasError }


withOnBlur : msg -> TextArea msg -> TextArea msg
withOnBlur msg (TextArea config) =
    TextArea { config | onBlur = Just msg }


withPlaceholder : String -> TextArea msg -> TextArea msg
withPlaceholder placeholder (TextArea config) =
    TextArea { config | placeholder = Just placeholder }


withMaxLength : Int -> TextArea msg -> TextArea msg
withMaxLength maxLength (TextArea config) =
    TextArea { config | maxlength = maxLength }


{-| The Grammarly extension may modify the DOM, which may cause Elm to crash.
See: <https://github.com/jinjor/elm-break-dom>
-}
disableGrammarlyBrowserExtension : Attribute msg
disableGrammarlyBrowserExtension =
    Attrs.attribute "data-gramm_editor" "false"
