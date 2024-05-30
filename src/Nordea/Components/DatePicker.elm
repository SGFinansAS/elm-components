module Nordea.Components.DatePicker exposing (DatePicker, InternalState, OptionalConfig(..), init, updateInternalState, view)

import Css
    exposing
        ( absolute
        , alignItems
        , alignSelf
        , backgroundColor
        , border3
        , borderBox
        , borderRadius
        , borderRadius4
        , boxSizing
        , center
        , column
        , cursor
        , display
        , displayFlex
        , flexDirection
        , flexEnd
        , focus
        , fontSize
        , height
        , hover
        , int
        , justifyContent
        , none
        , outline
        , padding
        , padding2
        , paddingRight
        , pct
        , pointer
        , pointerEvents
        , position
        , relative
        , rem
        , right
        , row
        , solid
        , spaceBetween
        , top
        , width
        , zIndex
        )
import Date exposing (Date)
import Html.Styled as Html exposing (Attribute, Html, input, styled)
import Html.Styled.Attributes exposing (css, placeholder, tabindex, value)
import Html.Styled.Events as Events exposing (onBlur, onClick, onInput)
import Json.Decode as Decode
import List.Extra as List exposing (groupsOf)
import Maybe.Extra exposing (toList)
import Nordea.Components.Button as Button
import Nordea.Components.OnClickOutsideSupport as OnClickOutsideSupport
import Nordea.Components.Text as Text
import Nordea.Css exposing (gap)
import Nordea.Html as Html
import Nordea.Html.Events as Events
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Icons as Icons
import Nordea.Themes as Themes
import Time exposing (Month, Weekday)


type alias Config msg =
    { today : Date
    , onSelect : Date -> InternalState -> msg
    , internalState : InternalState
    , onInternalStateChange : InternalState -> msg
    , currentValue : Maybe Date
    }


type DatePicker msg
    = DatePicker (Config msg)


type InternalState
    = InternalState
        { hasFocus : Bool
        , input : String
        , selectedMonth : Maybe ( Month, Int )
        }


type OptionalConfig msg
    = Placeholder String
    | DateParser (String -> Result String Date)
    | DateFormatter (Date -> String)
    | FirstDayOfWeek Weekday
    | ShowError msg
    | Error Bool


init : Date -> (Date -> InternalState -> msg) -> (InternalState -> msg) -> DatePicker msg
init today onSelect onInternalStateChange =
    DatePicker
        { today = today
        , onSelect = onSelect
        , internalState =
            InternalState
                { hasFocus = False
                , input = ""
                , selectedMonth = Nothing
                }
        , onInternalStateChange = onInternalStateChange
        , currentValue = Nothing
        }



-- UPDATE


updateInternalState : InternalState -> DatePicker msg -> DatePicker msg
updateInternalState internalState (DatePicker config) =
    DatePicker { config | internalState = internalState }



-- VIEW


view : List (Attribute msg) -> List (OptionalConfig msg) -> DatePicker msg -> Html msg
view attrs optional (DatePicker config) =
    let
        internalState =
            getInternalState config.internalState

        { placeholder, parser, formatter, firstDayOfWeek, onBlur, error } =
            optional
                |> List.foldl
                    (\e acc ->
                        case e of
                            Placeholder v ->
                                { acc | placeholder = v }

                            DateParser v ->
                                { acc | parser = v }

                            DateFormatter v ->
                                { acc | formatter = v }

                            FirstDayOfWeek v ->
                                { acc | firstDayOfWeek = v }

                            ShowError v ->
                                { acc | onBlur = Just v }

                            Error v ->
                                { acc | error = v }
                    )
                    { placeholder = "dd.MM.yyyy"
                    , parser = defaultDateParser
                    , formatter = Date.format "dd.MM.yyyy"
                    , firstDayOfWeek = Time.Mon
                    , onBlur = Nothing
                    , error = False
                    }

        chosenDate =
            parser internalState.input
                |> Result.withDefault config.today
    in
    Html.column
        (Events.on "outsideclick" (Decode.succeed (config.onInternalStateChange (InternalState { internalState | hasFocus = False })))
            :: css [ position relative ]
            :: attrs
        )
        [ OnClickOutsideSupport.view { isActive = internalState.hasFocus }
        , dateInput config parser placeholder onBlur error
        , Html.div
            [ css
                [ border3 (rem 0.0625) solid Colors.mediumGray
                , borderRadius4 (rem 0.25) (rem 0) (rem 0.25) (rem 0.25)
                , position absolute
                , top (pct 100)
                , right (rem 0)
                , zIndex (int 1)
                , backgroundColor Colors.white
                , alignSelf flexEnd
                , cursor pointer
                , if internalState.hasFocus then
                    displayFlex

                  else
                    display none
                , flexDirection column
                ]
            ]
            [ pickerHeader config chosenDate
            , pickerBody config formatter firstDayOfWeek chosenDate
            ]
        ]


dateInput : Config msg -> (String -> Result String Date) -> String -> Maybe msg -> Bool -> Html msg
dateInput config parser datePlaceholder onBlurMsg error =
    let
        internalState =
            getInternalState config.internalState

        ( borderColor, calendarIconColor ) =
            if error then
                ( Colors.darkRed, Themes.color Colors.darkRed )

            else
                ( Colors.mediumGray, Themes.color Colors.deepBlue )

        borderRadiusStyle =
            if internalState.hasFocus then
                borderRadius4 (rem 0.25) (rem 0.25) (rem 0) (rem 0.25)

            else
                borderRadius (rem 0.25)

        getAttributes =
            [ internalState.input |> value
            , (\input ->
                parser input
                    |> Result.map (\date -> config.onSelect date (InternalState { internalState | input = input }))
                    |> Result.withDefault (config.onInternalStateChange (InternalState { internalState | input = input, selectedMonth = Nothing }))
              )
                |> onInput
            , datePlaceholder |> placeholder
            , config.onInternalStateChange (InternalState { internalState | hasFocus = not internalState.hasFocus }) |> onClick
            , config.onInternalStateChange (InternalState { internalState | hasFocus = not internalState.hasFocus }) |> Events.onEnterOrSpacePress
            ]
                ++ (onBlurMsg |> Maybe.map onBlur |> toList)
    in
    Html.div
        [ css [ displayFlex, position relative ] ]
        [ styled input
            [ fontSize (rem 1)
            , height (rem 2.5)
            , padding2 (rem 0) (rem 0.75)
            , paddingRight (rem 3)
            , borderRadiusStyle
            , border3 (rem 0.0625) solid borderColor
            , boxSizing borderBox
            , width (pct 100)
            , focus
                [ outline none
                , Themes.borderColor Colors.nordeaBlue
                ]
            ]
            getAttributes
            []
        , Icons.calendar
            [ css
                [ width (rem 2.5)
                , position absolute
                , right (rem 0)
                , padding (rem 0.375)
                , pointerEvents none
                , calendarIconColor
                ]
            ]
        ]


pickerHeader : Config msg -> Date -> Html msg
pickerHeader config chosenDate =
    let
        internalState =
            getInternalState config.internalState

        date =
            internalState.selectedMonth
                |> Maybe.map (\( month, year ) -> Date.fromCalendarDate year month 1)
                |> Maybe.withDefault chosenDate

        prevMonthDate =
            Date.add Date.Months -1 date

        nextMonthDate =
            Date.add Date.Months 1 date
    in
    Html.row [ css [ justifyContent spaceBetween, padding2 (rem 1) (rem 0.75), Themes.color Colors.deepBlue ] ]
        [ Button.flatLinkStyle
            |> Button.view
                [ css [ Themes.color Colors.mediumGray ]
                , config.onInternalStateChange (InternalState { internalState | selectedMonth = Just ( Date.month prevMonthDate, Date.year prevMonthDate ) }) |> onClick
                ]
                [ Icons.chevronLeft [ css [ width (rem 1) ] ] ]
        , Text.textHeavy |> Text.view [ css [ alignSelf center ] ] [ Html.text (Date.format "MMMM YYYY" date) ]
        , Button.flatLinkStyle
            |> Button.view
                [ css [ Themes.color Colors.mediumGray ]
                , config.onInternalStateChange (InternalState { internalState | selectedMonth = Just ( Date.month nextMonthDate, Date.year nextMonthDate ) }) |> onClick
                ]
                [ Icons.chevronRight [ css [ width (rem 1) ] ] ]
        ]


pickerBody : Config msg -> (Date -> String) -> Weekday -> Date -> Html msg
pickerBody config formatter firstDayOfWeek chosenDate =
    let
        internalState =
            getInternalState config.internalState

        ( chosenMonth, chosenYear ) =
            internalState.selectedMonth |> Maybe.withDefault ( Date.month chosenDate, Date.year chosenDate )

        headerCell day =
            Html.th
                [ css
                    [ width (rem 2)
                    , height (rem 2)
                    , displayFlex
                    , justifyContent center
                    , alignItems center
                    ]
                ]
                [ Text.textHeavy |> Text.view [] [ Html.text day ] ]

        bodyCell date =
            let
                ( textColor, backgroundColor ) =
                    if date == chosenDate then
                        ( Themes.color Colors.white, Themes.backgroundColor Colors.deepBlue )

                    else if date == config.today then
                        ( Themes.color Colors.black, Themes.backgroundColor Colors.lightGray )

                    else if Date.month date == chosenMonth && Date.year date == chosenYear then
                        ( Themes.color Colors.darkGray, Themes.backgroundColor Colors.white )

                    else
                        ( Themes.color Colors.lightGray, Themes.backgroundColor Colors.white )
            in
            Html.td
                [ css
                    [ width (rem 2)
                    , height (rem 2)
                    , displayFlex
                    , justifyContent center
                    , alignItems center
                    , textColor
                    , backgroundColor
                    , borderRadius (pct 50)
                    , hover
                        [ Themes.backgroundColor Colors.cloudBlue
                        , Themes.color Colors.black
                        ]
                    , focus
                        [ outline none
                        , Themes.color Colors.white
                        , Themes.backgroundColor Colors.deepBlue
                        ]
                    ]
                , tabindex 0
                , onClick (config.onSelect date (InternalState { internalState | hasFocus = False, input = formatter date }))
                , Events.onEnterOrSpacePress (config.onSelect date (InternalState { internalState | hasFocus = False, input = formatter date }))
                ]
                [ Text.bodyTextSmall |> Text.view [] [ Date.format "d" date |> Html.text ] ]
    in
    Html.table [ css [ displayFlex, flexDirection column, padding2 (rem 1) (rem 0.75) ] ]
        [ Html.thead []
            [ Html.tr [ css [ displayFlex, flexDirection row, gap (rem 0.75) ] ]
                ([ "M", "T", "W", "T", "F", "S", "S" ]
                    |> List.map headerCell
                )
            ]
        , Html.tbody []
            (getDatesForMonth firstDayOfWeek chosenMonth chosenYear
                |> groupsOf 7
                |> List.map
                    (\week ->
                        Html.tr [ css [ displayFlex, flexDirection row, gap (rem 0.75) ] ]
                            (week |> List.map bodyCell)
                    )
            )
        ]


getDatesForMonth : Weekday -> Month -> Int -> List Date
getDatesForMonth firstDayOfWeek month year =
    let
        startDate =
            Date.floor Date.Monday (Date.fromCalendarDate year month 1)

        endDate =
            let
                exactEndDate =
                    Date.add Date.Months 1 (Date.fromCalendarDate year month 1) |> Date.add Date.Days -1
            in
            if Date.weekday exactEndDate == firstDayOfWeek then
                Date.add Date.Days 7 exactEndDate

            else
                Date.ceiling (weekdayToInterval firstDayOfWeek) exactEndDate |> Date.add Date.Days -1
    in
    Date.range Date.Day 1 startDate (Date.add Date.Days 1 endDate)


weekdayToInterval : Time.Weekday -> Date.Interval
weekdayToInterval weekday =
    case weekday of
        Time.Mon ->
            Date.Monday

        Time.Tue ->
            Date.Tuesday

        Time.Wed ->
            Date.Wednesday

        Time.Thu ->
            Date.Thursday

        Time.Fri ->
            Date.Friday

        Time.Sat ->
            Date.Saturday

        Time.Sun ->
            Date.Sunday


defaultDateParser : String -> Result String Date
defaultDateParser date =
    date
        |> String.replace "." "-"
        |> String.split "-"
        |> List.reverse
        |> String.join "-"
        |> Date.fromIsoString


getInternalState : InternalState -> { hasFocus : Bool, input : String, selectedMonth : Maybe ( Month, Int ) }
getInternalState (InternalState state) =
    state
