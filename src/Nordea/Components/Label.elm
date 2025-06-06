module Nordea.Components.Label exposing
    ( Label
    , LabelType(..)
    , RequirednessHint(..)
    , init
    , view
    , withCharCounter
    , withErrorMessage
    , withHintText
    , withNoReservedErrorSpace
    , withRequirednessHint
    , withSmallSize
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
        , hidden
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
        , visibility
        , width
        , wrap
        )
import Css.Global exposing (descendants, everything, selector, typeSelector)
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes exposing (class, css)
import Maybe.Extra as Maybe
import Nordea.Components.Text as Text
import Nordea.Css as Css exposing (columnGap)
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
    , withError : Bool
    , reserveSpaceForError : Bool
    , hintText : Maybe String
    , charCounter : Maybe CharCounter
    , size : Size
    }


type Size
    = Small
    | Standard


type Label
    = Label InputProperties


init : String -> LabelType -> Label
init labelText labelType =
    Label
        { labelText = labelText
        , labelType = labelType
        , requirednessHint = Nothing
        , errorMessage = Nothing
        , withError = False
        , reserveSpaceForError = True
        , hintText = Nothing
        , charCounter = Nothing
        , size = Standard
        }


view : List (Attribute msg) -> List (Html msg) -> Label -> Html msg
view attrs children (Label config) =
    let
        topInfo =
            let
                requirednessHintView requirednessHint =
                    initText config.size
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
                    , columnGap (rem 1)
                    ]
                ]
                [ initText config.size
                    |> Text.view
                        [ class "input-focus-color" ]
                        [ Html.text config.labelText ]
                , config.requirednessHint |> Html.viewMaybe requirednessHintView
                ]

        bottomInfo attrs_ =
            let
                viewHintText text =
                    initText config.size
                        |> Text.view [ css [ color Colors.darkGray ] ] [ Html.text text ]

                viewError maybeError =
                    initText config.size
                        |> Text.view
                            [ class "input-focus-color"
                            , css
                                [ displayFlex
                                , visibility hidden |> Css.cssIf (Maybe.isNothing maybeError)
                                ]
                            ]
                            [ Icons.error [ css [ marginRight (rem 0.5), flex none ] ]
                            , maybeError |> Maybe.withDefault "No errors" |> Html.text
                            ]

                viewCharCounter counter =
                    initText config.size
                        |> Text.view
                            [ css [ color Colors.darkGray ] ]
                            [ String.fromInt counter.current ++ "/" ++ String.fromInt counter.max |> Html.text ]

                showErrorRow =
                    config.withError && config.reserveSpaceForError
            in
            Html.row
                (css
                    [ justifyContent spaceBetween
                    , marginTop (rem 0.2)
                    ]
                    :: attrs_
                )
                [ Html.column []
                    [ viewError config.errorMessage |> Html.showIf showErrorRow
                    , config.hintText |> Html.viewMaybe viewHintText
                    ]
                , config.charCounter |> Html.viewMaybe viewCharCounter
                ]
                |> showIf (showErrorRow || config.hintText /= Nothing || config.charCounter /= Nothing)
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
                        [ Css.property "display" "contents"
                        , Css.Global.children [ everything [ marginBottom (rem -0.05) |> Css.important, flexBasis (pct 100) ] ]
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
                [ Css.property "box-shadow" ("0rem 0rem 0rem 0.0625rem " ++ color)
                , outline none
                ]

        styles =
            descendants
                [ typeSelector "input" [ outlineStyle, borderColor Css.transparent ]
                , typeSelector "select" [ outlineStyle, borderColor Css.transparent ]
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


initText : Size -> Text.Headline msg
initText size =
    case size of
        Standard ->
            Text.textSmallLight

        Small ->
            Text.textTinyLight


withRequirednessHint : Maybe RequirednessHint -> Label -> Label
withRequirednessHint requirednessHint (Label config) =
    Label { config | requirednessHint = requirednessHint }


withErrorMessage : Maybe String -> Label -> Label
withErrorMessage errorMessage (Label config) =
    Label { config | errorMessage = errorMessage, withError = True }


withNoReservedErrorSpace : Label -> Label
withNoReservedErrorSpace (Label config) =
    Label { config | reserveSpaceForError = False }


withHintText : Maybe String -> Label -> Label
withHintText hintText (Label config) =
    Label { config | hintText = hintText }


withCharCounter : Maybe CharCounter -> Label -> Label
withCharCounter charCounter (Label config) =
    Label { config | charCounter = charCounter }


withSmallSize : Label -> Label
withSmallSize (Label config) =
    Label { config | size = Small }


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
