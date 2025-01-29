module Nordea.Components.PhasedProgressBar exposing (view)

import Base64
import Css
    exposing
        ( alignItems
        , alignSelf
        , backgroundColor
        , backgroundSize
        , borderRadius
        , center
        , color
        , column
        , displayFlex
        , flexDirection
        , flexEnd
        , flexWrap
        , height
        , hidden
        , justifyContent
        , margin
        , marginRight
        , overflow
        , pct
        , rem
        , width
        , wrap
        )
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes exposing (css, disabled)
import List.Extra as List
import Nordea.Components.Text as Text
import Nordea.Css exposing (columnGap, gap)
import Nordea.Html exposing (showIf)
import Nordea.Resources.Colors as Colors


type alias PhaseInfo =
    { amount : Float
    , label : String
    }


view :
    { phaseOne : PhaseInfo
    , phaseTwo : PhaseInfo
    , phaseThree : PhaseInfo
    , formatter : Float -> String
    }
    -> List (Attribute msg)
    -> Html msg
view { phaseOne, phaseTwo, phaseThree, formatter } attrs =
    let
        isDisabled =
            List.member (disabled True) attrs

        total =
            phaseOne.amount + phaseTwo.amount + phaseThree.amount

        firstColor =
            if isDisabled then
                backgroundColor Colors.mediumGray

            else
                backgroundColor Colors.haasBlue

        secondColor =
            if isDisabled then
                backgroundColor Colors.nordeaGray

            else
                Css.property "background-image" ("url('data:image/svg+xml;base64," ++ stripedBackground ++ "')")

        thirdColor =
            if isDisabled then
                backgroundColor Colors.darkestGray

            else
                backgroundColor Colors.nordeaBlue

        barsView =
            Html.div [ css [ displayFlex, height (rem 2) ] ]
                [ Html.div
                    [ css
                        [ width (pct (100 * (phaseOne.amount / total)))
                        , borderRadius (rem 1.5)
                        , firstColor
                        ]
                    ]
                    []
                    |> showIf (phaseOne.amount > 0.0)
                , Html.div
                    [ css
                        [ width (pct (100 * (phaseTwo.amount / total)))
                        , borderRadius (rem 1.5)
                        , secondColor
                        ]
                    ]
                    []
                    |> showIf (phaseTwo.amount > 0.0)
                , Html.div
                    [ css
                        [ width (pct (100 * (phaseThree.amount / total)))
                        , borderRadius (rem 1.5)
                        , thirdColor
                        ]
                    ]
                    []
                    |> showIf (phaseThree.amount > 0.0)
                ]

        labelView =
            let
                labelElement bulletCss description price =
                    Html.div [ css [ displayFlex, justifyContent center, alignItems center ] ]
                        [ Html.div
                            [ css
                                ([ width (rem 1)
                                 , height (rem 1)
                                 , borderRadius (pct 50)
                                 ]
                                    ++ bulletCss
                                )
                            ]
                            []
                        , Text.textSmallLight
                            |> Text.view [ css [ margin (rem 0.25), color Colors.darkestGray ] ]
                                [ description |> Html.text ]
                        , Text.textSmallHeavy
                            |> Text.view [ css [ margin (rem 0.25), color Colors.darkestGray ] ]
                                [ price |> formatter |> Html.text ]
                        ]
            in
            Html.div
                [ css
                    [ displayFlex
                    , columnGap (rem 2)
                    , alignSelf flexEnd
                    , flexWrap wrap
                    ]
                ]
                [ labelElement
                    [ firstColor ]
                    phaseOne.label
                    phaseOne.amount
                    |> showIf (phaseOne.amount > 0.0)
                , labelElement
                    [ secondColor ]
                    phaseTwo.label
                    phaseTwo.amount
                    |> showIf (phaseTwo.amount > 0.0)
                , labelElement
                    [ thirdColor ]
                    phaseThree.label
                    phaseThree.amount
                    |> showIf (phaseThree.amount > 0.0)
                ]
    in
    Html.div (css [ displayFlex, flexDirection column, gap (rem 0.5) ] :: attrs)
        [ barsView
        , labelView
        ]


stripedBackground =
    Base64.encode
        """<?xml version="1.0" encoding="utf-8"?>
    <svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
         viewBox="0 0 125 125" style="enable-background:new 0 0 125 125;" xml:space="preserve">
      <style type="text/css">
        .st0{fill:#AED5FF;}
        .st1{fill:#DCEDFF;}
      </style>
      <rect y="0" class="st0" width="125" height="125"/>
      <g>
        <polygon class="st1" points="92.21,125 125,125 125,92.21"/>
          <polygon class="st1" points="0,92.3 0,125 1.54,125 125,1.54 125,0 92.3,0"/>
          <polygon class="st1" points="62.9,125 125,62.9 125,30.84 30.84,125"/>
          <polygon class="st1" points="1.63,0 0,0 0,1.63"/>
          <polygon class="st1" points="30.93,0 0,30.93 0,63 63,0"/>
      </g>
  </svg>
  """
