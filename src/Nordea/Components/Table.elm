module Nordea.Components.Table exposing (..)

import Css exposing (Style, backgroundColor, border3, borderBox, borderColor, borderRadius, boxSizing, disabled, em, focus, fontSize, height, none, order, outline, padding2, pct, rem, solid, width)
import Html as HtmlUnstyled
import Html.Styled exposing (Attribute, Html, div, h1, input, span, styled, table, tbody, td, text, th, thead, tr)
import Html.Styled.Attributes exposing (maxlength, pattern, placeholder, value)
import Html.Styled.Events as Events
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


view : List (Attribute msg) -> Table a msg -> Html msg
view attributes (Table config) =
    table []
        [ thead []
            [ tr []
                (config.columns
                    |> List.map
                        (\s ->
                            th []
                                [ text s.title
                                ]
                        )
                )
            ]
        , tbody []
            (config.compareFn
                |> Maybe.map (\fn -> List.sortWith fn config.rows)
                |> Maybe.withDefault config.rows
                |> List.map config.rowToHtml
                |> List.map (\row -> tr [] (row |> List.map (\field -> td [] [ field ])))
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
