module Nordea.Components.Coachmark exposing
    ( OptionalConfig(..)
    , step
    , view
    )

import Css
    exposing
        ( absolute
        , alignItems
        , animationDelay
        , animationDuration
        , animationName
        , auto
        , backgroundColor
        , before
        , borderRadius
        , borderStyle
        , borderWidth
        , bottom
        , cursor
        , displayFlex
        , fixed
        , flexStart
        , focus
        , height
        , int
        , justifyContent
        , left
        , marginLeft
        , ms
        , none
        , num
        , opacity
        , outline
        , padding
        , padding2
        , pct
        , pointer
        , position
        , relative
        , rem
        , right
        , scale
        , spaceBetween
        , top
        , transform
        , transforms
        , translate2
        , transparent
        , width
        , zIndex
        )
import Css.Animations as Animations exposing (keyframes)
import Css.Global
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attrs exposing (css)
import Html.Styled.Events as Events
import List.Extra as List
import Maybe.Extra as Maybe
import Nordea.Components.Button as Button
import Nordea.Components.Text as Text
import Nordea.Components.Tooltip as Tooltip
import Nordea.Html as Html
import Nordea.Html.Attributes as Attrs
import Nordea.Resources.Colors as Colors
import Nordea.Resources.I18N exposing (Translation)
import Nordea.Resources.Icons as Icons
import Nordea.Themes as Themes
import Set


type OptionalConfig
    = HighlightedClass String
    | Placement Tooltip.Placement
    | ShowStep (Maybe Int)
    | ShowStepLegend Bool


type alias RequiredProps msg =
    { onChangeStep : Maybe Int -> msg
    , translate : Translation -> String
    , ariaLabel : String
    }


type alias Step msg =
    { translate : Translation -> String
    , onChangeStep : Maybe Int -> msg
    , currentStep : Int
    , totalSteps : Int
    , showStepLegend : Bool
    }
    -> Html msg


view : RequiredProps msg -> List OptionalConfig -> List (Attribute msg) -> List (Step msg) -> Html msg
view { onChangeStep, translate, ariaLabel } optionalConfig attrs children_ =
    let
        { classesToHighlight, placement, showStep, showStepLegend } =
            optionalConfig
                |> List.foldl
                    (\e acc ->
                        case e of
                            HighlightedClass class_ ->
                                { acc | classesToHighlight = Set.insert class_ acc.classesToHighlight }

                            Placement placement_ ->
                                { acc | placement = placement_ }

                            ShowStep stepNum ->
                                { acc | showStep = stepNum }

                            ShowStepLegend showStepLegend_ ->
                                { acc | showStepLegend = showStepLegend_ }
                    )
                    { classesToHighlight = Set.empty
                    , placement = Tooltip.Top
                    , showStep = Nothing
                    , showStepLegend = True
                    }

        prepare steps =
            steps
                |> List.indexedMap
                    (\i step_ ->
                        step_
                            { translate = translate
                            , onChangeStep = onChangeStep
                            , currentStep = i
                            , totalSteps = List.length steps - 1
                            , showStepLegend = showStepLegend && i > 0
                            }
                    )
                |> List.getAt (showStep |> Maybe.withDefault 0)
                |> Maybe.toList

        rippleAnimation delay =
            let
                anim =
                    keyframes
                        [ ( 0
                          , [ Animations.transform [ translate2 (pct -50) (pct -50), scale 0.5 ]
                            , Animations.opacity (num 1)
                            ]
                          )
                        , ( 100
                          , [ Animations.transform [ translate2 (pct -50) (pct -50), scale 1.6 ]
                            , Animations.opacity (num 0)
                            ]
                          )
                        ]
            in
            Html.div
                [ css
                    [ position absolute
                    , top (pct 50)
                    , left (pct 50)
                    , transforms [ translate2 (pct -50) (pct -50), scale 0.5 ]
                    , width (pct 100)
                    , height (pct 100)
                    , borderWidth (rem 0.2)
                    , borderRadius (pct 50)
                    , Themes.borderColor Themes.PrimaryColorLight Colors.black
                    , animationName anim
                    , animationDuration (ms 1000)
                    , animationDelay (ms (1000 + delay))
                    , Css.property "animation-iteration-count" "1"
                    , Css.property "animation-timing-function" "linear"
                    , Css.property "animation-fill-mode" "forwards"
                    ]
                ]
                []
    in
    Tooltip.init
        |> Tooltip.withVisibility
            (if showStep == Nothing then
                Tooltip.Hidden

             else
                Tooltip.Show
            )
        |> Tooltip.withPlacement placement
        |> Tooltip.withContent
            (\arrow ->
                Html.column
                    (Attrs.class "tooltip-content-default-margin"
                        :: css
                            [ width (rem 13)
                            , borderRadius (rem 0.25)
                            , padding (rem 0.75)
                            , Themes.backgroundColor Themes.PrimaryColorLight Colors.cloudBlue
                            , position relative
                            ]
                        :: attrs
                    )
                    (prepare children_ ++ [ arrow [] ])
            )
        |> Tooltip.view attrs
            [ Html.button
                [ if showStep /= Nothing then
                    Events.onClick (onChangeStep Nothing)

                  else
                    Events.onClick (onChangeStep (Just 0))
                , Attrs.attribute "aria-label" ariaLabel
                , css
                    [ width (rem 2.5)
                    , height (rem 2.5)
                    , borderStyle none
                    , borderRadius (pct 50)
                    , backgroundColor transparent
                    , cursor pointer
                    , focus
                        [ Css.property "box-shadow" ("0rem 0rem 0rem 0.0625rem " ++ Themes.colorVariable Themes.SecondaryColor Colors.blueNordea)
                        , outline none
                        ]
                    , before
                        [ Css.property "content" "''"
                        , position absolute
                        , top (pct 50)
                        , left (pct 50)
                        , transform (translate2 (pct -50) (pct -50))
                        , width (pct 100)
                        , height (pct 100)
                        , borderRadius (pct 50)
                        , Themes.backgroundColor Themes.PrimaryColorLight Colors.cloudBlue
                        , opacity (num 0.5)
                        ]
                    , zIndex (int 100)
                    , position relative
                    ]
                ]
                [ Icons.lightBulb
                    [ css
                        [ position absolute
                        , top (pct 50)
                        , left (pct 50)
                        , transform (translate2 (pct -50) (pct -50))
                        , width (pct 60)
                        , height (pct 60)
                        , padding (pct 16)
                        , borderRadius (pct 50)
                        , Themes.backgroundColor Themes.PrimaryColorLight Colors.cloudBlue
                        ]
                    ]
                , rippleAnimation 0
                , rippleAnimation 300
                , rippleAnimation 600
                ]
            , highlightElements classesToHighlight |> Html.showIf (Maybe.withDefault 0 showStep > 0)
            ]


step : List (Attribute msg) -> List (Html msg) -> Step msg
step attrs children_ { translate, showStepLegend, onChangeStep, currentStep, totalSteps } =
    let
        nextButtonView =
            Button.flatLinkStyle
                |> Button.view
                    [ css [ marginLeft auto ]
                    , if currentStep < totalSteps then
                        Events.onClick (onChangeStep (Just (currentStep + 1)))

                      else
                        Events.onClick (onChangeStep Nothing)
                    ]
                    [ if currentStep == 0 && totalSteps > 1 then
                        Html.text (translate strings.start)

                      else if currentStep < totalSteps then
                        Html.text (translate strings.next)

                      else
                        Html.text (translate strings.close)
                    ]

        stepLegendView =
            Text.textTinyHeavy
                |> Text.view
                    (css
                        [ borderRadius (rem 1.25)
                        , padding2 (rem 0.25) (rem 0.5)
                        , backgroundColor Colors.mediumBlue
                        , Css.alignSelf flexStart
                        ]
                        :: attrs
                    )
                    [ [ translate strings.step
                      , String.fromInt currentStep
                      , translate strings.of_
                      , String.fromInt totalSteps
                      ]
                        |> String.join " "
                        |> Html.text
                    ]
    in
    Html.column
        (css
            [ Css.property "gap" "1rem"
            , justifyContent spaceBetween
            ]
            :: attrs
        )
        [ Text.textSmallLight
            |> Text.withHtmlTag Html.row
            |> Text.view [ css [ Css.property "gap" "1rem", alignItems flexStart ] ]
                (children_
                    ++ [ Html.button
                            [ Attrs.attribute "aria-label" (translate strings.close)
                            , css
                                [ marginLeft auto
                                , borderStyle none
                                , backgroundColor transparent
                                , cursor pointer
                                ]
                            , Events.onClick (onChangeStep Nothing)
                            ]
                            [ Icons.cross [ css [ width (rem 1) ] ] ]
                       ]
                )
        , Html.row
            []
            [ stepLegendView |> Html.showIf showStepLegend
            , nextButtonView
            ]
        ]


highlightElements : Set.Set String -> Html msg
highlightElements classes =
    Html.div
        [ css
            [ position fixed
            , displayFlex
            , left (rem 0)
            , top (rem 0)
            , right (rem 0)
            , bottom (rem 0)
            , zIndex (int 99)
            , backgroundColor Colors.black
            , opacity (num 0.5)
            ]
        ]
        [ classes
            |> Set.toList
            |> List.map (\highlightedClass -> Css.Global.class highlightedClass [ Css.property "z-index" "100" ])
            |> Css.Global.global
        ]


strings =
    { step =
        { no = "Steg"
        , se = "Steg"
        , dk = "Trin"
        , en = "Step"
        }
    , of_ =
        { no = "av"
        , se = "av"
        , dk = "af"
        , en = "of"
        }
    , start =
        { no = "Start"
        , se = "Start"
        , dk = "Start"
        , en = "Start"
        }
    , next =
        { no = "Neste"
        , se = "Nästa"
        , dk = "Næste"
        , en = "Next"
        }
    , close =
        { no = "Lukk"
        , se = "Stänga"
        , dk = "Luk"
        , en = "Close"
        }
    }
