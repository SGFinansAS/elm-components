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
        , borderRadius
        , bottom
        , center
        , color
        , column
        , displayFlex
        , flexDirection
        , fontSize
        , height
        , int
        , lineHeight
        , listStyleType
        , margin
        , none
        , pct
        , position
        , relative
        , rem
        , solid
        , textAlign
        , width
        , zIndex
        )
import Html.Styled exposing (Html, div, li, p, span, styled, text, ul)
import List.Extra as List
import Nordea.Resources.Colors as Colors
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
    div []
        [ viewSteps config.stepNames config.currentStep
        ]


enumerateList : List a -> List ( Int, a )
enumerateList list =
    List.zip (List.range 1 (List.length list)) list


viewSteps : List String -> Int -> Html msg
viewSteps stepNames currentStep =
    let
        list =
            List.map (viewStepItem currentStep) (enumerateList stepNames)
    in
    styled ul listStyles [] list


viewStepItem : Int -> ( Int, String ) -> Html msg
viewStepItem currentStep ( item, stepName ) =
    if item == 1 then
        if item == currentStep then
            styled li
                listStylesLi
                []
                [ styled div divStylesCurrent [] [ text (String.fromInt item) ]
                , styled p textStyles [] [ text stepName ]
                ]

        else
            styled li
                listStylesLi
                []
                [ styled div divStylesActive [] [ Icons.check ]
                , styled p textStyles [] [ text stepName ]
                ]

    else if item < currentStep then
        styled li
            listStylesLi
            []
            [ styled div divStylesActive [] [ Icons.check ]
            , styled p textStyles [] [ text stepName ]
            , viewLineActive
            ]

    else if item == currentStep then
        styled li
            listStylesLi
            []
            [ styled div divStylesCurrent [] [ text (String.fromInt item) ]
            , styled p textStyles [] [ text stepName ]
            , viewLineActive
            ]

    else
        styled li
            listStylesLi
            []
            [ styled div divStyles [] []
            , styled p textStyles [] [ text stepName ]
            , viewLine
            ]


listStyles : List Style
listStyles =
    [ displayFlex
    , listStyleType none
    , alignItems center
    ]


listStylesLi : List Style
listStylesLi =
    [ displayFlex
    , alignItems center
    , flexDirection column
    , position relative
    , zIndex (int 1)
    , margin (rem 3)
    ]


divStyles : List Style
divStyles =
    [ height (rem 2)
    , width (rem 2)
    , borderRadius (pct 50)
    , border3 (rem 0.125) solid Colors.gray
    , textAlign center
    , position relative
    , lineHeight (rem 1.8)
    , fontSize (rem 1)
    ]


divStylesCurrent : List Style
divStylesCurrent =
    [ height (rem 2)
    , width (rem 2)
    , borderRadius (pct 50)
    , border3 (rem 0.125) solid Colors.black
    , textAlign center
    , position relative
    , lineHeight (rem 1.8)
    , fontSize (rem 1)
    ]


divStylesActive : List Style
divStylesActive =
    [ height (rem 2)
    , width (rem 2)
    , borderRadius (pct 50)
    , border3 (rem 0.125) solid Colors.white
    , backgroundColor Colors.blueDeep
    , color Colors.white
    , textAlign center
    , position relative
    , lineHeight (rem 2.2)
    ]


textStyles : List Style
textStyles =
    [ textAlign center
    , position absolute
    , bottom (rem -3)
    , width (rem 7)
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
            , Css.color Colors.blueDeep
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
            , Css.color Colors.blueDeep
            , Css.backgroundColor Colors.gray
            ]
        ]
        []
        []
