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
    )

import Css
    exposing
        ( Style
        , border
        , borderColor
        , color
        , column
        , displayFlex
        , flex
        , flexBasis
        , flexDirection
        , flexWrap
        , justifyContent
        , marginBottom
        , marginInlineEnd
        , marginInlineStart
        , marginRight
        , marginTop
        , none
        , outline
        , padding
        , pct
        , pseudoClass
        , rem
        , spaceBetween
        , width
        , wrap
        )
import Css.Global exposing (descendants, everything, selector, typeSelector)
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes exposing (class, css)
import Nordea.Components.Text as Text
import Nordea.Html as Html exposing (showIf)
import Nordea.Resources.Colors as Colors
import Nordea.Resources.I18N exposing (Translation)
import Nordea.Resources.Icons as Icons
import Nordea.Themes as Themes


type LabelType
    = InputLabel
    | GroupLabel
    | TextLabel


type RequirednessHint
    = Mandatory (Translation -> String)
    | Optional (Translation -> String)
    | Custom String


type alias CharCounter =
    { current : Int
    , max : Int
    }


type alias InputProperties =
    { labelText : String
    , labelType : LabelType
    , requirednessHint : Maybe RequirednessHint
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
        , errorMessage = Nothing
        , hintText = Nothing
        , charCounter = Nothing
        }


view : List (Attribute msg) -> List (Html msg) -> Label -> Html msg
view attrs children (Label config) =
    let
        topInfo =
            let
                requirednessHintView requirednessHint =
                    Text.textSmallLight
                        |> Text.view
                            [ css [ color Colors.darkGray ] ]
                            [ Html.text <|
                                case requirednessHint of
                                    Mandatory translate ->
                                        translate strings.mandatory

                                    Optional translate ->
                                        translate strings.optional

                                    Custom string ->
                                        string
                            ]
            in
            Html.row
                [ css
                    [ justifyContent spaceBetween
                    , marginBottom (rem 0.2)
                    ]
                ]
                [ Text.textSmallLight
                    |> Text.view
                        [ class "input-focus-color" ]
                        [ Html.text config.labelText ]
                , config.requirednessHint |> Html.viewMaybe requirednessHintView
                ]

        bottomInfo attrs_ =
            let
                viewHintText text =
                    Text.textSmallLight
                        |> Text.view [ css [ color Colors.darkGray ] ] [ Html.text text ]

                viewError errorText =
                    Text.textSmallLight
                        |> Text.view
                            [ class "input-focus-color", css [ displayFlex ] ]
                            [ Icons.error [ css [ marginRight (rem 0.5), flex none ] ]
                            , Html.text errorText
                            ]

                viewCharCounter counter =
                    Text.textSmallLight
                        |> Text.view
                            [ css [ color Colors.darkGray ] ]
                            [ String.fromInt counter.current ++ "/" ++ String.fromInt counter.max |> Html.text ]
            in
            Html.row
                (css
                    [ justifyContent spaceBetween
                    , marginTop (rem 0.2)
                    ]
                    :: attrs_
                )
                [ Html.column []
                    [ config.errorMessage |> Html.viewMaybe viewError
                    , config.hintText |> Html.viewMaybe viewHintText
                    ]
                , config.charCounter |> Html.viewMaybe viewCharCounter
                ]
                |> showIf (config.errorMessage /= Nothing || config.hintText /= Nothing || config.charCounter /= Nothing)
    in
    case config.labelType of
        InputLabel ->
            Html.label
                (css
                    [ displayFlex
                    , flexDirection column
                    , stateStyles { hasError = config.errorMessage /= Nothing }
                    ]
                    :: attrs
                )
                (topInfo :: children ++ [ bottomInfo [] ])

        GroupLabel ->
            Html.fieldset
                (css
                    [ displayFlex
                    , flexWrap wrap
                    , stateStyles { hasError = config.errorMessage /= Nothing }
                    , marginInlineStart (rem 0)
                    , marginInlineEnd (rem 0)
                    , padding (rem 0)
                    , border (rem 0)
                    ]
                    :: attrs
                )
                ((Html.legend
                    [ css
                        [ padding (rem 0)
                        , width (pct 100)
                        , Css.Global.children [ everything [ flexBasis (pct 100) ] ]
                        ]
                    ]
                    [ topInfo ]
                    |> showIf (config.labelText /= "" || config.requirednessHint /= Nothing)
                 )
                    :: children
                    ++ [ bottomInfo [ css [ flexBasis (pct 100) ] ] ]
                )

        TextLabel ->
            Html.column
                (css [ stateStyles { hasError = config.errorMessage /= Nothing } ] :: attrs)
                (topInfo :: children ++ [ bottomInfo [] ])


stateStyles : { hasError : Bool } -> Style
stateStyles { hasError } =
    let
        color =
            if hasError then
                Colors.toString Colors.darkRed

            else
                Themes.colorVariable Colors.nordeaBlue

        outlineStyle =
            Css.batch
                [ Css.property "box-shadow" ("0rem 0rem 0rem 0.0625rem " ++ color) |> Css.important
                , outline none
                ]

        styles =
            descendants
                [ typeSelector "input" [ outlineStyle, borderColor Css.transparent |> Css.important ]
                , typeSelector "select" [ outlineStyle, borderColor Css.transparent |> Css.important ]
                , selector ".input-focus-color" [ Css.property "color" color ]
                ]
    in
    Css.batch
        [ outline none
        , if hasError then
            styles

          else
            pseudoClass "focus-within" [ styles ]
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


strings =
    { mandatory =
        { no = "Påkrevd"
        , se = "Krävs"
        , dk = "Påkrævet"
        , en = "Required"
        }
    , optional =
        { no = "Valgfritt"
        , se = "Valfritt"
        , dk = "Valgfrit"
        , en = "Optional"
        }
    }
