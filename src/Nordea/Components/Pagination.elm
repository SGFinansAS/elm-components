module Nordea.Components.Pagination exposing (OptionalConfig(..), Pagination, init, view)

import Css exposing (backgroundColor, boxShadow, color, displayFlex, flexDirection, focus, hidden, listStyleType, none, pseudoClass, textDecoration, visibility, visible)
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


type OptionalConfig
    = PrevButton String
    | NextButton String


type alias Properties msg =
    { totalPages : Int
    , currentPage : Int
    , windowSize : Int
    , pageOnClickMsg : Int -> msg
    }


init : Properties msg -> Pagination msg
init properties =
    Pagination properties


view : List OptionalConfig -> List (Attribute msg) -> Pagination msg -> Html msg
view optionals attr (Pagination properties) =
    let
        optionalConfig =
            optionals
                |> List.foldl
                    (\o acc ->
                        case o of
                            PrevButton s ->
                                { acc | prevButton = Just s }

                            NextButton s ->
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
                                ]

                              else
                                []
                             )
                                ++ [ textDecoration none
                                   , focus [ boxShadow none ]
                                   , pseudoClass "focus-visible" [ Css.property "box-shadow" ("0rem 0rem 0rem 0.25rem " ++ Themes.colorVariable Colors.haasBlue) ]
                                   ]
                             --override the focus and underline from the main component
                            )
                        ]
                        [ Text.init TextTinyHeavy |> Text.view [] [ Html.text textShownForPage ] ]
                ]

        prev =
            optionalConfig.prevButton
                |> Maybe.map
                    (\s ->
                        paginationElement
                            [ css
                                [ if properties.currentPage == 1 then
                                    visibility hidden

                                  else
                                    visibility visible
                                ]
                            ]
                            ( properties.currentPage - 1, s )
                    )
                |> Maybe.withDefault Html.nothing

        next =
            optionalConfig.nextButton
                |> Maybe.map
                    (\s ->
                        paginationElement
                            [ css
                                [ if properties.currentPage == properties.totalPages then
                                    visibility hidden

                                  else
                                    visibility visible
                                ]
                            ]
                            ( properties.currentPage + 1, s )
                    )
                |> Maybe.withDefault Html.nothing

        fixUnderflowingNumbers l =
            let
                numUnderFlowing =
                    l |> List.takeWhile (\n -> n < 1) |> List.length
            in
            (l |> List.drop numUnderFlowing)
                ++ (List.range 1 numUnderFlowing
                        |> List.map (\n -> n + properties.windowSize + properties.currentPage - (1 + properties.windowSize // 2))
                        |> List.takeWhile (\n -> n <= properties.totalPages)
                   )

        fixOverflowingNumbers l =
            let
                numOverflowing =
                    l |> List.takeWhileRight (\n -> n > properties.totalPages) |> List.length
            in
            (List.range 1 numOverflowing
                |> List.map (\n -> -n + 1 + properties.currentPage - (1 + properties.windowSize // 2))
                |> List.reverse
                |> List.takeWhileRight (\n -> n >= 1)
            )
                ++ (l |> List.dropWhileRight (\n -> n > properties.totalPages))

        adjustOffset l =
            if List.member 1 l then
                l |> List.map (\n -> n + 1)

            else
                l

        adjustTailOffset l =
            if List.member properties.totalPages l then
                l |> List.map (\n -> n - 1)

            else
                l

        numbers =
            1
                :: (List.range 1 (min properties.totalPages properties.windowSize)
                        |> List.map (\n -> n + properties.currentPage - (2 + properties.windowSize) // 2)
                        |> fixUnderflowingNumbers
                        |> fixOverflowingNumbers
                        |> adjustOffset
                        |> adjustTailOffset
                   )
                ++ [ properties.totalPages ]
                |> List.unique

        addDots ns =
            case ns of
                a :: b :: c ->
                    let
                        ( aVal, bVal ) =
                            ( min (Tuple.first a) (Tuple.first b), max (Tuple.first a) (Tuple.first b) )

                        closestPageToCurrentPage =
                            if abs (properties.currentPage - aVal) < abs (properties.currentPage - bVal) then
                                aVal

                            else
                                bVal

                        dotValue =
                            if b > a then
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
        (prev :: res ++ [ next ])
