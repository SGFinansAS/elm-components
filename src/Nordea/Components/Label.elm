module Nordea.Components.Label exposing
    ( Label
    , LabelType(..)
    , RequirednessHint(..)
    , init
    , view
    , withCharCounter
    , withErrorMessage
    , withHintText
    , withRequirednessHint
    , withShowFocusOutline
    )

import Css
    exposing
        ( Style
        , border
        , column
        , displayFlex
        , flexBasis
        , flexDirection
        , flexWrap
        , marginInlineEnd
        , marginInlineStart
        , padding
        , pct
        , pseudoClass
        , rem
        , width
        , wrap
        )
import Css.Global exposing (descendants, everything, typeSelector)
import Html.Styled
    exposing
        ( Attribute
        , Html
        , div
        , fieldset
        , label
        , legend
        , styled
        )
import Html.Styled.Attributes exposing (css)
import Maybe.Extra as Maybe
import Nordea.Components.Common as Common exposing (CharCounter, RequirednessHint, bottomInfo, topInfo)
import Nordea.Html exposing (showIf, styleIf)
import Nordea.Resources.Colors as Colors
import Nordea.Themes as Themes
import Nordea.Types exposing (Translation)


type LabelType
    = InputLabel
    | GroupLabel
    | TextLabel


type RequirednessHint
    = Mandatory (Translation -> String)
    | Optional (Translation -> String)
    | Custom String


type alias InputProperties =
    { labelText : String
    , labelType : LabelType
    , requirednessHint : Maybe RequirednessHint
    , showFocusOutline : Bool
    , errorMessage : Maybe String
    , hintText : Maybe String
    , charCounter : Maybe CharCounter
    }


type Label
    = Label InputProperties


init : String -> LabelType -> Label
init labelText labelType =
    Label
        { labelText = labelText
        , labelType = labelType
        , requirednessHint = Nothing
        , showFocusOutline = True
        , errorMessage = Nothing
        , hintText = Nothing
        , charCounter = Nothing
        }


view : List (Attribute msg) -> List (Html msg) -> Label -> Html msg
view attrs children (Label config) =
    let
        commonConfig =
            let
                fromLabelRequirednessHint requirednessHint =
                    requirednessHint
                        |> Maybe.map
                            (\hint ->
                                case hint of
                                    Mandatory a ->
                                        Common.Mandatory a

                                    Optional a ->
                                        Common.Optional a

                                    Custom a ->
                                        Common.Custom a
                            )
            in
            { labelText = config.labelText
            , requirednessHint = config.requirednessHint |> fromLabelRequirednessHint
            , showFocusOutline = config.showFocusOutline
            , errorMessage = config.errorMessage
            , hintText = config.hintText
            , charCounter = config.charCounter
            }
    in
    case config.labelType of
        InputLabel ->
            styled label
                [ displayFlex
                , flexWrap wrap
                , focusStyle |> styleIf config.showFocusOutline
                , Css.Global.children [ everything [ flexBasis (pct 100) ] ]
                ]
                attrs
                (topInfo commonConfig :: children ++ bottomInfo commonConfig)

        GroupLabel ->
            styled fieldset
                [ displayFlex
                , flexWrap wrap
                , focusStyle |> styleIf config.showFocusOutline
                , marginInlineStart (rem 0)
                , marginInlineEnd (rem 0)
                , padding (rem 0)
                , border (rem 0)
                ]
                attrs
                ((legend
                    [ css [ width (pct 100), padding (rem 0), Css.Global.children [ everything [ flexBasis (pct 100) ] ] ] ]
                    [ topInfo commonConfig ]
                    |> showIf (not (String.isEmpty config.labelText) || Maybe.isJust config.requirednessHint)
                 )
                    :: children
                    ++ bottomInfo commonConfig
                )

        TextLabel ->
            styled div
                [ displayFlex
                , flexDirection column
                , focusStyle |> styleIf config.showFocusOutline
                , Css.Global.children [ everything [ flexBasis (pct 100) ] ]
                ]
                attrs
                (topInfo commonConfig :: children ++ bottomInfo commonConfig)


focusStyle : Style
focusStyle =
    Css.batch
        [ pseudoClass "focus-within"
            [ descendants
                [ typeSelector "span"
                    [ Themes.color Themes.PrimaryColorLight Colors.blueNordea ]
                ]
            ]
        ]


withRequirednessHint : Maybe RequirednessHint -> Label -> Label
withRequirednessHint requirednessHint (Label config) =
    Label { config | requirednessHint = requirednessHint }


withErrorMessage : Maybe String -> Label -> Label
withErrorMessage errorMessage (Label config) =
    Label { config | errorMessage = errorMessage }


withHintText : Maybe String -> Label -> Label
withHintText hintText (Label config) =
    Label { config | hintText = hintText }


withCharCounter : Maybe CharCounter -> Label -> Label
withCharCounter charCounter (Label config) =
    Label { config | charCounter = charCounter }


withShowFocusOutline : Bool -> Label -> Label
withShowFocusOutline focus (Label config) =
    Label { config | showFocusOutline = focus }
