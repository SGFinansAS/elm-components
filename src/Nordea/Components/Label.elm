module Nordea.Components.Label exposing
    ( Label
    , LabelType(..)
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
import Nordea.Components.Common exposing (CharCounter, topInfo)
import Nordea.Components.Util.Hint as Hint
import Nordea.Components.Util.RequirednessHint as RequirednessHint exposing (RequirednessHint)
import Nordea.Html exposing (showIf, styleIf)
import Nordea.Resources.Colors as Colors
import Nordea.Themes as Themes


type LabelType
    = InputLabel
    | GroupLabel
    | TextLabel


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
                                    RequirednessHint.Mandatory a ->
                                        RequirednessHint.Mandatory a

                                    RequirednessHint.Optional a ->
                                        RequirednessHint.Optional a

                                    RequirednessHint.Custom a ->
                                        RequirednessHint.Custom a
                            )
            in
            { labelText = config.labelText
            , requirednessHint = config.requirednessHint |> fromLabelRequirednessHint
            , showFocusOutline = config.showFocusOutline
            , errorMessage = config.errorMessage
            , hintText = config.hintText
            , charCounter = config.charCounter
            }

        viewHint =
            [ Hint.init { text = commonConfig.hintText |> Maybe.withDefault "" }
                |> Hint.withCharCounter commonConfig.charCounter
                |> Hint.withError commonConfig.errorMessage
                |> Hint.view
            ]
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
                (topInfo commonConfig
                    :: children
                    ++ viewHint
                )

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
                    ++ viewHint
                )

        TextLabel ->
            styled div
                [ displayFlex
                , flexDirection column
                , focusStyle |> styleIf config.showFocusOutline
                , Css.Global.children [ everything [ flexBasis (pct 100) ] ]
                ]
                attrs
                (topInfo commonConfig :: children ++ viewHint)


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
