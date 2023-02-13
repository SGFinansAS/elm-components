module Nordea.Components.AccordionMenu exposing (init, view, withItem)

import Css exposing (alignItems, center, cursor, displayFlex, justifyContent, marginTop, paddingLeft, pointer, rem, spaceBetween, width)
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events exposing (onClick)
import Nordea.Components.Text as Text exposing (Headline)
import Nordea.Resources.Icons as Icons


type alias Item msg =
    { icon : Html msg, text : String }


type alias Config msg =
    { open : Bool
    , toggle : msg
    , items : List (Item msg)
    , iconClosed : Html msg
    , iconOpen : Html msg
    , headTextSize : Headline msg
    , itemTextSize : Headline msg
    , distanceTextIconInRem : Float
    , distanceBetweenItemsInRem : Float
    }


type Model msg
    = Model (Config msg)


init : Bool -> msg -> Model msg
init open msg =
    Model
        { open = open
        , toggle = msg
        , items = []
        , iconClosed = Icons.chevronLeft [ css [ width (rem 1) ] ]
        , iconOpen = Icons.chevronDown [ css [ width (rem 1) ] ]
        , headTextSize = Text.textLight
        , itemTextSize = Text.textSmallLight
        , distanceTextIconInRem = 0.5
        , distanceBetweenItemsInRem = 0.5
        }


withItem : Item msg -> Model msg -> Model msg
withItem item (Model config) =
    Model { config | items = List.append config.items [ item ] }


view : Model msg -> Html msg
view (Model config) =
    Html.div [] [ viewHead config, viewRest config ]


viewHead : Config msg -> Html msg
viewHead config =
    case config.items of
        x :: _ :: _ ->
            Html.div
                [ onClick config.toggle, css [ cursor pointer, displayFlex, justifyContent spaceBetween ] ]
                [ viewHeadContent config x
                , if config.open then
                    config.iconOpen

                  else
                    config.iconClosed
                ]

        x :: _ ->
            Html.div
                [ onClick config.toggle, css [ displayFlex, justifyContent spaceBetween ] ]
                [ viewHeadContent config x ]

        [] ->
            Html.div [] []


viewHeadContent : Config msg -> Item msg -> Html msg
viewHeadContent config item =
    Html.div
        [ css [ displayFlex, alignItems center ] ]
        [ item.icon, Text.view [ css [ paddingLeft (rem config.distanceTextIconInRem) ] ] [ Html.text item.text ] config.headTextSize ]


viewRest : Config msg -> Html msg
viewRest config =
    case List.tail config.items of
        Just tail ->
            Html.div [] (List.map (config |> viewItem) tail)

        Nothing ->
            Html.div [] []


viewItem : Config msg -> Item msg -> Html msg
viewItem config item =
    if config.open then
        Html.div [ css [ alignItems center, displayFlex, marginTop (rem config.distanceBetweenItemsInRem) ] ] [ item.icon, Text.view [ css [ paddingLeft (rem config.distanceTextIconInRem) ] ] [ Html.text item.text ] config.itemTextSize ]

    else
        Html.div [] []
