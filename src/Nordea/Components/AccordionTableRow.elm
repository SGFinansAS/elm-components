module Nordea.Components.AccordionTableRow exposing (init, view, withChevron, withDetails, withSmallSize, withSummary)

import Css exposing (alignItems, backgroundColor, border3, borderRadius, borderRadius4, center, color, cursor, display, hover, important, marginTop, padding, padding2, pointer, rem, solid, unset, width)
import Css.Global exposing (children, typeSelector)
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes exposing (attribute, css)
import Html.Styled.Events as Events
import Json.Decode as Decode
import Nordea.Css exposing (displayContents, displayGrid, gridColumn, gridTemplateColumns)
import Nordea.Html exposing (nothing)
import Nordea.Html.Attributes exposing (boolProperty)
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Icons as Icons
import Nordea.Themes as Themes


type alias Component msg =
    { attributes : List (Attribute msg)
    , content : List (Html msg)
    }


type alias Config msg =
    { summary : Component msg
    , details : Component msg
    , isOpen : Bool
    , onToggle : Bool -> msg
    , size : Size
    , showChevron : Bool
    }


type Size
    = Standard
    | Small


placeholder : Component msg
placeholder =
    { attributes = []
    , content = []
    }


init : Bool -> (Bool -> msg) -> Config msg
init isOpen onToggle =
    { summary = placeholder
    , details = placeholder
    , isOpen = isOpen
    , onToggle = onToggle
    , size = Standard
    , showChevron = True
    }


withSmallSize : Config msg -> Config msg
withSmallSize config =
    { config
        | size = Small
    }


withChevron : Bool -> Config msg -> Config msg
withChevron show config =
    { config
        | showChevron = show
    }


withSummary : List (Html.Attribute msg) -> List (Html msg) -> Config msg -> Config msg
withSummary attrs content config =
    { config
        | summary =
            { attributes = attrs
            , content = content
            }
    }


withDetails : List (Html.Attribute msg) -> List (Html msg) -> Config msg -> Config msg
withDetails attrs content config =
    { config
        | details =
            { attributes = attrs
            , content = content
            }
    }


view : List (Html.Attribute msg) -> Config msg -> Html msg
view attrs config =
    Html.details
        ([ css [ displayContents ]
         , boolProperty "open" config.isOpen
         , Events.on "toggle" (Decode.map config.onToggle decodeNewState)
         ]
            ++ attrs
        )
        [ viewSummary config
        , viewDetails config
        ]


viewSummary : Config msg -> Html msg
viewSummary config =
    let
        openCss =
            if config.isOpen then
                [ css
                    [ important (backgroundColor Colors.deepBlue)
                    , important (color Colors.white)
                    , important (borderRadius4 (rem 0.5) (rem 0.5) (rem 0) (rem 0))
                    ]
                ]

            else
                []

        ( horizontalPadding, verticalPadding ) =
            case config.size of
                Small ->
                    ( 0.75, 0.5 )

                Standard ->
                    ( 1, 0.75 )
    in
    Html.summary
        ([ css
            [ displayGrid
            , gridColumn "1/-1"
            , gridTemplateColumns "subgrid"
            , alignItems center
            , cursor pointer
            , marginTop (rem 1)
            , padding2 (rem verticalPadding) (rem horizontalPadding)
            , borderRadius (rem 0.5)
            , Themes.color Colors.darkestGray
            , backgroundColor Colors.grayWarm
            , hover [ cursor pointer, backgroundColor Colors.deepBlue, color Colors.white ]
            ]
         , attribute "role" "row"
         ]
            ++ openCss
            ++ config.summary.attributes
        )
        (config.summary.content
            ++ [ if config.showChevron then
                    viewChevron config.isOpen

                 else
                    nothing
               ]
        )


viewDetails : Config msg -> Html msg
viewDetails config =
    Html.div
        (css
            [ padding (rem 1.5)
            , border3 (rem 0.1875) solid Colors.deepBlue
            , borderRadius4 (rem 0) (rem 0) (rem 0.5) (rem 0.5)
            , gridColumn "1/-1"
            ]
            :: config.details.attributes
        )
        config.details.content


viewChevron : Bool -> Html msg
viewChevron isOpen =
    let
        icon =
            if isOpen then
                Icons.chevronUp []

            else
                Icons.chevronDown []
    in
    Html.div
        [ css
            [ width (rem 1)
            , children [ typeSelector "*" [ display unset |> important ] ]
            ]
        ]
        [ icon ]


decodeNewState : Decode.Decoder Bool
decodeNewState =
    Decode.field "newState" Decode.string
        |> Decode.andThen
            (\state ->
                case state of
                    "open" ->
                        Decode.succeed True

                    "closed" ->
                        Decode.succeed False

                    _ ->
                        Decode.fail "Invalid state"
            )
