module Nordea.Components.Coachmark exposing
    ( OptionalConfig(..)
    , OptionalPageConfig(..)
    , nextButton
    , page
    , view
    )

import Css
    exposing
        ( absolute
        , alignItems
        , auto
        , backgroundColor
        , before
        , borderRadius
        , borderStyle
        , bottom
        , displayFlex
        , fixed
        , flexStart
        , height
        , int
        , justifyContent
        , left
        , marginLeft
        , none
        , num
        , opacity
        , padding
        , padding2
        , pct
        , position
        , relative
        , rem
        , right
        , spaceBetween
        , top
        , transform
        , translate2
        , width
        , zIndex
        )
import Css.Global exposing (children)
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
    | ShowPage (Maybe Int)
    | ShowStepLegend Bool


type alias RequiredProps msg =
    { onClickOpen : msg, onClickClose : msg, translate : Translation -> String }


type alias Page msg =
    { translate : Translation -> String
    , onClickClose : msg
    , stepLegend : Maybe { currentStep : Int, totalSteps : Int }
    }
    -> Html msg


view : RequiredProps msg -> List OptionalConfig -> List (Attribute msg) -> List (Page msg) -> Html msg
view { onClickOpen, onClickClose, translate } optionalConfig attrs children_ =
    let
        { classesToHighlight, placement, showPage, showStepLegend } =
            optionalConfig
                |> List.foldl
                    (\e acc ->
                        case e of
                            HighlightedClass class_ ->
                                { acc | classesToHighlight = Set.insert class_ acc.classesToHighlight }

                            Placement placement_ ->
                                { acc | placement = placement_ }

                            ShowPage pageNum ->
                                { acc | showPage = pageNum }

                            ShowStepLegend showStepLegend_ ->
                                { acc | showStepLegend = showStepLegend_ }
                    )
                    { classesToHighlight = Set.empty
                    , placement = Tooltip.Top
                    , showPage = Nothing
                    , showStepLegend = False
                    }

        prepare pages =
            pages
                |> List.indexedMap
                    (\i p ->
                        p
                            { translate = translate
                            , onClickClose = onClickClose
                            , stepLegend =
                                if showStepLegend && i > 0 then
                                    Just { currentStep = i, totalSteps = List.length pages - 1 }

                                else
                                    Nothing
                            }
                    )
                |> List.getAt (showPage |> Maybe.withDefault 0)
                |> Maybe.toList
    in
    Tooltip.init
        |> Tooltip.withVisibility
            (if showPage == Nothing then
                Tooltip.Hidden

             else
                Tooltip.Show
            )
        |> Tooltip.withPlacement placement
        |> Tooltip.withContent
            (\arrow ->
                Html.wrappedRow
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
                [ Events.onClick onClickOpen
                , css
                    [ width (rem 2.5)
                    , height (rem 2.5)
                    , borderStyle none
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
                    , zIndex (int 10)
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
                ]
            , highlightElements classesToHighlight |> Html.showIf (Maybe.withDefault 0 showPage > 0)
            ]


type OptionalPageConfig msg
    = NextButton (Html msg)


page : List (OptionalPageConfig msg) -> List (Attribute msg) -> List (Html msg) -> Page msg
page optionalConfig attrs children_ { translate, stepLegend, onClickClose } =
    let
        { nextButton_ } =
            optionalConfig
                |> List.foldl
                    (\e acc ->
                        case e of
                            NextButton nextButton__ ->
                                { acc | nextButton_ = Just nextButton__ }
                    )
                    { nextButton_ = Nothing }

        stepLegendView =
            stepLegend
                |> Html.viewMaybe
                    (\{ currentStep, totalSteps } ->
                        Text.textTinyHeavy
                            |> Text.view
                                (css
                                    [ borderRadius (rem 1.25)
                                    , padding2 (rem 0.25) (rem 0.5)
                                    , backgroundColor Colors.mediumBlue
                                    , Css.alignSelf flexStart
                                    ]
                                    :: Attrs.class "coachmark-step-legend"
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
                    )
    in
    Html.column
        (css
            [ Css.property "gap" "1rem"
            , justifyContent spaceBetween
            ]
            :: attrs
        )
        [ Html.row [ css [ Css.property "gap" "1rem", alignItems flexStart ] ]
            (children_
                ++ [ Html.button
                        [ css [ marginLeft auto, borderStyle none ]
                        , Events.onClick onClickClose
                        ]
                        [ Icons.cross [ css [ width (rem 1) ] ] ]
                   ]
            )
        , Html.row
            []
            [ stepLegendView
            , nextButton_ |> Html.viewMaybe identity
            ]
        ]


nextButton : List (Attribute msg) -> List (Html msg) -> OptionalPageConfig msg
nextButton attrs children =
    Button.flatLinkStyle
        |> Button.view (css [ marginLeft auto ] :: attrs) children
        |> NextButton


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
            , zIndex (int 9)
            , backgroundColor Colors.black
            , opacity (num 0.5)
            , Css.pointerEvents Css.none
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
        , dk = "Steg"
        , en = "Step"
        }
    , of_ =
        { no = "av"
        , se = "av"
        , dk = "av"
        , en = "of"
        }
    }
