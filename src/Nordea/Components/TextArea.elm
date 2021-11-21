module Nordea.Components.TextArea exposing
    ( init
    , view
    , withCharCounter
    , withErrorMessage
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
        , column
        , displayFlex
        , flexBasis
        , flexDirection
        , flexWrap
        , focus
        , fontFamilies
        , fontSize
        , lineHeight
        , maxWidth
        , minHeight
        , none
        , outline
        , padding
        , pct
        , rem
        , solid
        , width
        , wrap
        )
import Css.Global exposing (everything, withAttribute)
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attrs
    exposing
        ( css
        , disabled
        , maxlength
        , placeholder
        , value
        )
import Html.Styled.Events exposing (onBlur)
import Maybe.Extra as Maybe
import Nordea.Components.Common as Common exposing (CharCounter)
import Nordea.Components.Label as Label exposing (LabelType(..))
import Nordea.Html exposing (maybeAttr, styleIf)
import Nordea.Resources.Colors as Colors


type alias InputProperties msg =
    { label : String
    , placeholder : Maybe String
    , value : String
    , onInput : Maybe (String -> msg)
    , onBlur : Maybe msg
    , isDisabled : Bool
    , errorMessage : Maybe String
    , charCounter : Maybe CharCounter
    , maxLength : Int
    }


type TextArea msg
    = TextArea (InputProperties msg)


init : String -> String -> TextArea msg
init label contentValue =
    TextArea
        { label = label
        , placeholder = Nothing
        , value = contentValue
        , onInput = Nothing
        , onBlur = Nothing
        , isDisabled = False
        , errorMessage = Nothing
        , charCounter = Nothing
        , maxLength = 120
        }


view : List (Attribute msg) -> TextArea msg -> Html msg
view attrs (TextArea config) =
    let
        additionalInfoConfig =
            { labelText = config.label
            , requirednessHint = Nothing
            , showFocusOutline = False
            , errorMessage = config.errorMessage
            , hintText = Nothing
            , charCounter = config.charCounter
            }

        textArea =
            Html.textarea
                ([ config.placeholder |> Maybe.map placeholder |> maybeAttr
                 , disabled config.isDisabled
                 , maxlength config.maxLength
                 , css
                    [ maxWidth (pct 100)
                    , minHeight (rem 6)
                    , padding (rem 0.75)
                    , border3 (rem 0.0625) solid Colors.grayMedium
                    , borderColor Colors.redDark |> styleIf (Maybe.isJust config.errorMessage)
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
    in
    Html.div
        [ css
            [ displayFlex
            , flexDirection column
            , flexWrap wrap

            -- , Common.focusStyle |> styleIf config.showFocusOutline
            , Css.Global.children [ everything [ flexBasis (pct 100) ] ]
            ]
        ]
        ([ Label.init config.label InputLabel |> Label.view [] []
         , textArea []
         ]
            ++ Common.bottomInfo additionalInfoConfig
        )


withErrorMessage : String -> TextArea msg -> TextArea msg
withErrorMessage errorMessage (TextArea config) =
    TextArea { config | errorMessage = Just errorMessage }


withOnBlur : msg -> TextArea msg -> TextArea msg
withOnBlur msg (TextArea config) =
    TextArea { config | onBlur = Just msg }


withPlaceholder : String -> TextArea msg -> TextArea msg
withPlaceholder placeholder (TextArea config) =
    TextArea { config | placeholder = Just placeholder }


withMaxLength : Int -> TextArea msg -> TextArea msg
withMaxLength maxLength (TextArea config) =
    TextArea { config | maxLength = maxLength }


withCharCounter : CharCounter -> TextArea msg -> TextArea msg
withCharCounter charCounter (TextArea config) =
    TextArea { config | charCounter = Just charCounter }


{-| The Grammarly extension may modify the DOM, which may cause Elm to crash.
See: <https://github.com/jinjor/elm-break-dom>
-}
disableGrammarlyBrowserExtension : Attribute msg
disableGrammarlyBrowserExtension =
    Attrs.attribute "data-gramm_editor" "false"
