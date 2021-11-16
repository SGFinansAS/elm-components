module Nordea.Components.Table exposing (..)

import Css
    exposing
        ( Style
        , alignItems
        , backgroundColor
        , border3
        , borderRadius
        , center
        , column
        , cursor
        , displayFlex
        , ellipsis
        , flex
        , flexDirection
        , flexShrink
        , flexStart
        , fontWeight
        , height
        , hidden
        , hover
        , int
        , justifyContent
        , left
        , marginBottom
        , marginLeft
        , noWrap
        , normal
        , num
        , overflow
        , padding
        , padding2
        , pct
        , pointer
        , position
        , pseudoClass
        , px
        , relative
        , rem
        , row
        , solid
        , stretch
        , textAlign
        , textDecoration
        , textOverflow
        , underline
        , whiteSpace
        , width
        )
import Css.Media as Media
import Html.Styled exposing (Attribute, Html, div, h1, input, span, styled, table, tbody, td, text, th, thead, tr)
import Html.Styled.Attributes exposing (maxlength, pattern, placeholder, value)
import Html.Styled.Events as Events
import List.Extra exposing (zip)
import Maybe.Extra as Maybe
import Nordea.Resources.Colors as Colors
import Nordea.Themes as Themes



-- CONFIG


type alias Config a msg =
    { columns : List (Column a)
    , rows : List a
    , rowToHtml : a -> List (Html msg)
    , onChange : Maybe (String -> msg)
    , compareFn : Maybe (a -> a -> Order)
    }


type Table a msg
    = Table (Config a msg)


type alias Column a =
    { title : String
    , orderFn : Maybe (a -> a -> Order)
    , style : List Style
    }


init : List (Column a) -> (a -> List (Html msg)) -> Table a msg
init columns rowToHtml =
    Table
        { columns = columns
        , rows = []
        , onChange = Nothing
        , rowToHtml = rowToHtml
        , compareFn = Nothing
        }


withRows : List a -> Table a msg -> Table a msg
withRows rows (Table config) =
    Table { config | rows = rows }


withOrder : (a -> a -> Order) -> Table a msg -> Table a msg
withOrder orderFn (Table config) =
    Table { config | compareFn = Just orderFn }



-- withPlaceholder : String -> Table msg -> Table msg
-- withPlaceholder placeholder (Table config) =
--     Table { config | placeholder = Just placeholder }
-- withMaxLength : Int -> Table msg -> Table msg
-- withMaxLength maxLength (Table config) =
--     Table { config | maxLength = Just maxLength }
-- withPattern : String -> Table msg -> Table msg
-- withPattern pattern (Table config) =
--     Table { config | pattern = Just pattern }
-- withError : Bool -> Table msg -> Table msg
-- withError condition (Table config) =
--     Table { config | showError = condition }
-- VIEW


smallerScreenOnly : List Style -> Style
smallerScreenOnly styleAttrs =
    Media.withMedia
        [ Media.only Media.screen [ Media.maxWidth (px 950) ] ]
        styleAttrs


headerRowStyle : List Style
headerRowStyle =
    [ displayFlex
    , position relative
    , alignItems center
    , textAlign left
    , padding2 (rem 0) (rem 1.5)
    , marginBottom (rem 0.5)
    , smallerScreenOnly [ padding2 (rem 0) (rem 0.875) ]
    ]


rowStyle : List Style
rowStyle =
    [ displayFlex
    , alignItems center
    , position relative
    , textAlign left
    , height (rem 3.2)
    , marginBottom (rem 0.5)
    , padding2 (rem 0.5) (rem 1.5)
    , borderRadius (rem 0.5)
    , backgroundColor Colors.white
    , smallerScreenOnly [ padding2 (rem 0) (rem 0.875) ]
    ]


zip : List a -> List b -> List ( a, b )
zip la lb =
    List.map2 Tuple.pair la lb


view : List (Attribute msg) -> Table a msg -> Html msg
view attributes (Table config) =
    styled table
        [ displayFlex
        , flexDirection column
        , borderRadius (rem 0.5)
        ]
        []
        [ thead []
            [ styled tr
                headerRowStyle
                []
                (config.columns
                    |> List.map
                        (\column ->
                            styled th
                                ([ flex (num 1), pseudoClass "not(:first-child)" [ marginLeft (rem 1) ] ]
                                    ++ column.style
                                )
                                []
                                [ text column.title
                                ]
                        )
                )
            ]
        , styled tbody
            [ displayFlex, flexDirection column ]
            []
            (config.compareFn
                |> Maybe.map (\fn -> List.sortWith fn config.rows)
                |> Maybe.withDefault config.rows
                |> List.map config.rowToHtml
                --|> List.indexedMap Tuple.pair
                |> List.map
                    (\row ->
                        styled tr
                            rowStyle
                            []
                            (row
                                |> zip config.columns
                                |> List.map (\( column, field ) -> styled td ([ flex (num 1), pseudoClass "not(:first-child)" [ marginLeft (rem 1) ] ] ++ column.style) [] [ field ])
                            )
                    )
            )
        ]



-- getAttributes : Config msg -> List (Attribute msg)
-- getAttributes config =
--     Maybe.values
--         [ Just config.value |> Maybe.map value
--         , config.onInput |> Maybe.map onInput
--         , config.placeholder |> Maybe.map placeholder
--         , config.maxLength |> Maybe.map maxlength
--         , config.pattern |> Maybe.map pattern
--         ]
-- STYLES
-- getStyles : Config msg -> List Style
-- getStyles config =
--     let
--         borderColorStyle =
--             if config.showError then
--                 Colors.redDark
--             else
--                 Colors.grayMedium
--     in
--     [ fontSize (rem 1)
--     , height (em 2.5)
--     , padding2 (em 0.75) (em 0.75)
--     , borderRadius (em 0.125)
--     , border3 (em 0.0625) solid borderColorStyle
--     , boxSizing borderBox
--     , width (pct 100)
--     , disabled [ backgroundColor Colors.grayWarm ]
--     , focus
--         [ outline none
--         , Themes.borderColor Themes.PrimaryColorLight Colors.blueNordea
--         ]
--     ]
