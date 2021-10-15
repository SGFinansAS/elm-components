module Nordea.Components.StepIndicator exposing
    ( StepIndicator
    , init
    , view
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
        , color
        , column
        , displayFlex
        , flexDirection
        , fontSize
        , fontWeight
        , height
        , int
        , justifyContent
        , lineHeight
        , listStyleType
        , margin
        , margin4
        , none
        , paddingLeft
        , pct
        , position
        , relative
        , rem
        , solid
        , textAlign
        , top
        , width
        , zIndex
        )
import Html.Styled
    exposing
        ( Html
        , div
        , li
        , ol
        , p
        , span
        , styled
        , text
        )
import Html.Styled.Attributes exposing (attribute)
import Nordea.Css exposing (backgroundColorWithVariable)
import Nordea.Html exposing (showIf)
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Fonts as Fonts
import Nordea.Resources.Icons as Icons


type StepIndicator
    = StepIndicator Config


type alias Config =
    { stepNames : List String
    , currentStep : Int
    }


init : List String -> Int -> StepIndicator
init stepNames currentStep =
    StepIndicator
        { stepNames = stepNames
        , currentStep = currentStep
        }


view : StepIndicator -> Html msg
view (StepIndicator config) =
    div [ attribute "role" "group", attribute "aria-label" "Step progress" ]
        [ viewSteps config.stepNames config.currentStep
        ]


enumerateList : List a -> List ( Int, a )
enumerateList list =
    List.indexedMap (\i a -> ( i + 1, a )) list


viewSteps : List String -> Int -> Html msg
viewSteps stepNames currentStep =
    let
        list =
            List.map (viewStepItem currentStep) (enumerateList stepNames)
    in
    styled ol listStyles [] list


viewStepItem : Int -> ( Int, String ) -> Html msg
viewStepItem currentStep ( item, stepName ) =
    if item < currentStep then
        styled li
            listStylesLi
            []
            [ styled div divStylesActive [] [ Icons.check ]
            , styled p textStyles [] [ text stepName ]
            , showIf (item /= 1) viewLineActive
            ]

    else if item == currentStep then
        styled li
            listStylesLi
            [ attribute "aria-current" "step" ]
            [ styled div divStylesCurrent [] [ text (String.fromInt item) ]
            , styled p textStyles [] [ text stepName ]
            , showIf (item /= 1) viewLineActive
            ]

    else
        styled li
            listStylesLi
            []
            [ styled div divStyles [] [ text (String.fromInt item) ]
            , styled p textStyles [] [ text stepName ]
            , viewLine
            ]


listStyles : List Style
listStyles =
    [ displayFlex
    , listStyleType none
    , alignItems center
    , paddingLeft (rem 0)
    ]


listStylesLi : List Style
listStylesLi =
    [ displayFlex
    , alignItems center
    , flexDirection column
    , position relative
    , zIndex (int 1)
    , margin4 (rem 1) (rem 3) (rem 2) (rem 3)
    ]


divStyles : List Style
divStyles =
    [ displayFlex
    , justifyContent center
    , alignItems center
    , height (rem 2)
    , width (rem 2)
    , borderRadius (pct 50)
    , border3 (rem 0.125) solid Colors.grayMedium
    , fontSize (rem 1)
    , color Colors.grayEclipse
    , backgroundColor Colors.white
    ]


divStylesCurrent : List Style
divStylesCurrent =
    [ displayFlex
    , justifyContent center
    , alignItems center
    , height (rem 2)
    , width (rem 2)
    , borderRadius (pct 50)
    , border3 (rem 0.125) solid Colors.black
    , backgroundColor Colors.white
    , fontSize (rem 1)
    , boxSizing borderBox
    , color Colors.black
    ]


divStylesActive : List Style
divStylesActive =
    [ displayFlex
    , justifyContent center
    , alignItems center
    , height (rem 2)
    , width (rem 2)
    , borderRadius (pct 50)
    , border3 (rem 0.125) solid Colors.white
    , backgroundColorWithVariable "--themePrimaryColor" Colors.blueDeep
    , color Colors.white
    ]


textStyles : List Style
textStyles =
    [ textAlign center
    , position absolute
    , top (rem 2.5)
    , width (rem 7)
    , Fonts.fromSize 0.875
    , fontWeight (int 400)
    , lineHeight (rem 1.125)
    , margin (rem 0)
    ]


viewLineActive : Html msg
viewLineActive =
    styled span
        [ Css.before
            [ Css.property "content" "\"\""
            , Css.position Css.absolute
            , Css.top (Css.rem 1)
            , Css.right (Css.rem 2)
            , Css.width (Css.rem 6)
            , Css.height (Css.rem 0.1)
            , Css.backgroundColor Colors.black
            ]
        ]
        []
        []


viewLine : Html msg
viewLine =
    styled span
        [ Css.before
            [ Css.property "content" "\"\""
            , Css.position Css.absolute
            , Css.top (Css.rem 1)
            , Css.right (Css.rem 2)
            , Css.width (Css.rem 6)
            , Css.height (Css.rem 0.1)
            , Css.backgroundColor Colors.grayMedium
            ]
        ]
        []
        []
