module Nordea.Components.Label exposing
    ( CharCounter
    , Label
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
        , alignItems
        , auto
        , border
        , center
        , color
        , column
        , displayFlex
        , flex
        , flexBasis
        , flexDirection
        , flexWrap
        , fontFamilies
        , fontSize
        , justifyContent
        , lineHeight
        , margin
        , marginBottom
        , marginLeft
        , marginRight
        , marginTop
        , none
        , padding
        , pct
        , pseudoClass
        , rem
        , spaceBetween
        , width
        , wrap
        )
import Css.Global exposing (descendants, typeSelector)
import Html.Styled as Html
    exposing
        ( Attribute
        , Html
        , div
        , fieldset
        , label
        , legend
        , styled
        , text
        )
import Html.Styled.Attributes exposing (css)
import Maybe.Extra as Maybe
import Nordea.Html as Html exposing (showIf, styleIf)
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Icons as Icons
import Nordea.Themes as Themes


type LabelType
    = InputLabel
    | GroupLabel
    | TextLabel


type RequirednessHint
    = Mandatory ({ no : String, se : String, dk : String } -> String)
    | Optional ({ no : String, se : String, dk : String } -> String)
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


type alias CharCounter =
    { current : Int
    , max : Int
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
    case config.labelType of
        InputLabel ->
            styled label
                [ displayFlex
                , flexWrap wrap
                , focusStyle |> styleIf config.showFocusOutline
                ]
                attrs
                (topInfo config :: children ++ bottomInfo config)

        GroupLabel ->
            styled fieldset
                [ displayFlex
                , flexWrap wrap
                , focusStyle |> styleIf config.showFocusOutline
                , margin (rem 0)
                , padding (rem 0)
                , border (rem 0)
                ]
                attrs
                ((legend
                    [ css [ flexBasis (pct 100), padding (rem 0) ] ]
                    [ topInfo config ]
                    |> showIf (not (String.isEmpty config.labelText) || Maybe.isJust config.requirednessHint)
                 )
                    :: children
                    ++ bottomInfo config
                )

        TextLabel ->
            styled div
                [ displayFlex
                , flexDirection column
                , focusStyle |> styleIf config.showFocusOutline
                ]
                attrs
                (topInfo config :: children ++ bottomInfo config)


topInfo : InputProperties -> Html msg
topInfo config =
    let
        textStyle =
            if Maybe.isJust config.errorMessage then
                color Colors.redDark |> Css.important

            else
                color Colors.black

        toI18NString requirednessHint =
            case requirednessHint of
                Mandatory translate ->
                    translate strings.mandatory

                Optional translate ->
                    translate strings.optional

                Custom string ->
                    string
    in
    div [ css [ displayFlex, justifyContent spaceBetween, flexBasis (pct 100), marginBottom (rem 0.5) ] ]
        [ bodyText [ css [ textStyle ] ] [ text config.labelText ]
        , config.requirednessHint
            |> Html.viewMaybe
                (\requirednessHint ->
                    bodyText
                        [ css [ color Colors.grayDark |> Css.important ] ]
                        [ requirednessHint |> toI18NString |> text ]
                )
        ]


bottomInfo : InputProperties -> List (Html msg)
bottomInfo config =
    let
        charCounterView =
            config.charCounter
                |> Html.viewMaybe
                    (\charCounter ->
                        bodyText [ css [ marginLeft auto, color Colors.grayDark |> Css.important ] ]
                            [ String.fromInt charCounter.current ++ "/" ++ String.fromInt charCounter.max |> text ]
                    )
    in
    [ div [ css [ displayFlex, flexBasis (pct 100), justifyContent spaceBetween, marginTop (rem 0.5), Css.property "gap" "1rem" ] ]
        [ config.errorMessage
            |> Html.viewMaybe
                (\errText ->
                    div
                        [ css
                            [ displayFlex
                            , alignItems center
                            , color Colors.redDark
                            , fontSize (rem 0.875)
                            ]
                        ]
                        [ Icons.error [ css [ marginRight (rem 0.5), flex none ] ]
                        , text errText
                        ]
                )
        , charCounterView
        ]
        |> showIf (Maybe.isJust config.errorMessage)
    , div [ css [ displayFlex, flexBasis (pct 100), justifyContent spaceBetween, marginTop (rem 0.5), Css.property "gap" "1rem" ] ]
        [ config.hintText
            |> Html.viewMaybe
                (\hintText ->
                    Html.div [ css [ color Colors.grayDark, fontSize (rem 0.875) ] ] [ text hintText ]
                )
        , charCounterView |> showIf (Maybe.isNothing config.errorMessage)
        ]
        |> showIf (Maybe.isJust config.hintText || Maybe.isJust config.charCounter)
    ]


bodyText : List (Attribute msg) -> List (Html msg) -> Html msg
bodyText =
    styled Html.span
        [ fontSize (rem 0.875)
        , fontFamilies [ "Nordea Sans Small" ]
        , lineHeight (rem 1.5)
        , color Colors.black
        ]


focusStyle : Style
focusStyle =
    Css.batch
        [ pseudoClass "focus-within"
            [ descendants
                [ typeSelector "span"
                    [ Themes.color Themes.PrimaryColor70 Colors.blueNordea ]
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


strings =
    { mandatory =
        { no = "Obligatorisk"
        , se = "Obligatoriskt"
        , dk = "Obligatorisk"
        }
    , optional =
        { no = "Valgfritt"
        , se = "Valfritt"
        , dk = "Valgfrit"
        }
    }
