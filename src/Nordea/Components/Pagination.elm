module Nordea.Components.Pagination exposing (NavigationButtonType(..), OptionalConfig(..), Pagination, init, updateCurrentPage, view)

import Css exposing (backgroundColor, borderRadius, boxShadow, color, displayFlex, flexDirection, focus, hidden, listStyleType, none, paddingBottom, paddingTop, pseudoClass, rem, textDecoration, visibility, visible)
import Html.Attributes.Extra as Attrs
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attrs exposing (css, fromUnstyled)
import Html.Styled.Events exposing (onClick)
import List.Extra as List
import Nordea.Components.Button as Button
import Nordea.Components.Text as Text exposing (Variant(..))
import Nordea.Html as Html
import Nordea.Resources.Colors as Colors exposing (white)
import Nordea.Themes as Themes


type Pagination msg
    = Pagination (Properties msg)


type NavigationButtonType
    = PrevButton
    | NextButton


type OptionalConfig
    = NavigationButton NavigationButtonType String


type alias Properties msg =
    { totalPages : Int
    , currentPage : Int
    , windowSize : Int
    , pageOnClickMsg : Int -> msg
    }


init : Properties msg -> Pagination msg
init properties =
    Pagination properties


updateCurrentPage : Int -> Pagination msg -> Pagination msg
updateCurrentPage currentPage (Pagination properties) =
    Pagination { properties | currentPage = currentPage }


view : List OptionalConfig -> List (Attribute msg) -> Pagination msg -> Html msg
view optionals attr (Pagination properties) =
    let
        optionalConfig =
            optionals
                |> List.foldl
                    (\o acc ->
                        case o of
                            NavigationButton t s ->
                                case t of
                                    PrevButton ->
                                        { acc | prevButton = Just s }

                                    NextButton ->
                                        { acc | nextButton = Just s }
                    )
                    { prevButton = Nothing, nextButton = Nothing }

        paginationElement attrs ( numPage, textShownForPage ) =
            Html.li attrs
                [ Button.flatLinkStyle
                    |> Button.view
                        [ if numPage >= 1 && numPage <= properties.totalPages then
                            onClick (properties.pageOnClickMsg numPage)

                          else
                            Attrs.empty |> fromUnstyled
                        , css
                            ((if numPage == properties.currentPage then
                                [ backgroundColor Colors.deepBlue |> Css.important
                                , color white |> Css.important
                                , borderRadius (rem 0.2)
                                ]

                              else
                                []
                             )
                                ++ [ paddingTop (rem 0.25)
                                   , paddingBottom (rem 0.25)
                                   , textDecoration none
                                   , focus [ boxShadow none ]
                                   , pseudoClass "focus-visible" [ Css.property "box-shadow" ("0rem 0rem 0rem 0.25rem " ++ Themes.colorVariable Colors.haasBlue) ]
                                   ]
                             --override the focus and underline from the main component
                            )
                        ]
                        [ Text.init TextTinyHeavy |> Text.view [] [ Html.text textShownForPage ] ]
                ]

        navigationElement ofType textOnButton =
            let
                ( hiddenOnPage, offset ) =
                    case ofType of
                        PrevButton ->
                            ( 1, -1 )

                        NextButton ->
                            ( properties.totalPages, 1 )
            in
            paginationElement
                [ css
                    [ if properties.currentPage == hiddenOnPage then
                        visibility hidden

                      else
                        visibility visible
                    ]
                ]
                ( properties.currentPage + offset, textOnButton )

        prevButton =
            optionalConfig.prevButton
                |> Maybe.map (navigationElement PrevButton)
                |> Maybe.withDefault Html.nothing

        nextButton =
            optionalConfig.nextButton
                |> Maybe.map (navigationElement NextButton)
                |> Maybe.withDefault Html.nothing

        adjustOffset computedWindow =
            let
                positiveOffset =
                    if List.member 1 computedWindow then
                        1

                    else
                        0

                negativeOffset =
                    if List.member properties.totalPages computedWindow then
                        -1

                    else
                        0
            in
            computedWindow |> List.map (\n -> n + positiveOffset + negativeOffset)

        numExpectedOverflowingRightNumbers =
            max 0 (properties.currentPage + (properties.windowSize - 1) // 2 - properties.totalPages)

        leftNumbers =
            -- [, curPage)
            List.range
                (max 1 (properties.currentPage - properties.windowSize // 2 - numExpectedOverflowingRightNumbers))
                (properties.currentPage - 1)

        rightNumbers =
            -- [curPage, ]
            List.range properties.currentPage
                ((properties.currentPage + ((properties.windowSize - 1) // 2))
                    |> max (properties.currentPage + (properties.windowSize - List.length leftNumbers) - 1)
                    |> min properties.totalPages
                )

        numbers =
            List.concat [ [ 1 ], (leftNumbers ++ rightNumbers) |> adjustOffset, [ properties.totalPages ] ] |> List.unique

        addDots ns =
            case ns of
                a :: b :: c ->
                    let
                        ( aVal, bVal ) =
                            ( Tuple.first a, Tuple.first b )

                        distanceToCurrentPage p =
                            abs (properties.currentPage - p)

                        closestPageToCurrentPage =
                            if distanceToCurrentPage aVal < distanceToCurrentPage bVal then
                                aVal

                            else
                                bVal

                        dotValue =
                            if bVal > aVal then
                                closestPageToCurrentPage - 1

                            else
                                closestPageToCurrentPage + 1
                    in
                    if abs (bVal - aVal) >= 2 then
                        a :: ( dotValue, "..." ) :: b :: c

                    else
                        ns

                _ ->
                    ns

        res =
            numbers
                |> List.map (\n -> ( n, String.fromInt n ))
                |> addDots
                |> List.reverse
                |> addDots
                |> List.reverse
                |> List.map (paginationElement [])
    in
    Html.ul (css [ listStyleType none, displayFlex, flexDirection Css.row ] :: attr)
        (prevButton :: res ++ [ nextButton ])
