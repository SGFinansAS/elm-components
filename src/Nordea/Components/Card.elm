module Nordea.Components.Card exposing
    ( Card
    , footer
    , header
    , infoBox
    , init
    , title
    , view
    , viewCollapsible
    , withShadow
    , withTitle
    )

import Css
    exposing
        ( active
        , alignItems
        , alignSelf
        , auto
        , backgroundColor
        , before
        , border3
        , borderRadius
        , borderStyle
        , boxShadow4
        , center
        , color
        , column
        , cursor
        , default
        , displayFlex
        , ellipsis
        , flexBasis
        , flexDirection
        , flexEnd
        , flexGrow
        , height
        , hidden
        , hover
        , left
        , listStyle
        , margin2
        , marginBottom
        , marginLeft
        , marginRight
        , marginTop
        , maxWidth
        , noWrap
        , none
        , num
        , opacity
        , overflow
        , padding
        , padding2
        , paddingRight
        , pct
        , pointer
        , pseudoClass
        , rem
        , scale2
        , solid
        , textAlign
        , textOverflow
        , transform
        , whiteSpace
        , width
        )
import Css.Global as Css
import Css.Transitions exposing (transition)
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Html exposing (css)
import Nordea.Components.AccordionMenu as AccordionMenu
import Nordea.Components.Text as Text
import Nordea.Html as Html exposing (styleIf, viewMaybe)
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Icons as Icons


type alias CardProperties =
    { title : Maybe String
    , hasShadow : Bool
    }


type Card msg
    = Card CardProperties


init : Card msg
init =
    Card
        { title = Nothing
        , hasShadow = False
        }


view : List (Attribute msg) -> List (Html msg) -> Card msg -> Html msg
view attrs children (Card config) =
    Html.div
        (css
            [ borderRadius (rem 0.5)
            , padding (rem 1.5)
            , textAlign left
            , displayFlex
            , flexDirection column
            , backgroundColor Colors.white
            , boxShadow4 (rem 0) (rem 0.25) (rem 2.5) Colors.lightGray
                |> styleIf config.hasShadow
            ]
            :: attrs
        )
        ((config.title |> viewMaybe (\title_ -> header [] [ title [] [ Html.text title_ ] ]))
            :: children
        )


viewCollapsible : List (Attribute msg) -> Html msg -> Bool -> List (Html msg) -> Card msg -> Html msg
viewCollapsible attrs emphasisedText isOpen children (Card config) =
    AccordionMenu.view { isOpen = isOpen }
        (css
            [ cursor Css.default
            , borderRadius (rem 0.5)
            , padding (rem 1.5)
            , backgroundColor Colors.white
            ]
            :: attrs
        )
        [ Html.summary
            (css [ displayFlex, alignItems center, cursor pointer ] :: attrs)
            [ config.title |> viewMaybe (\title_ -> Text.bodyTextHeavy |> Text.view [ css [] ] [ Html.text title_ ])
            , emphasisedText
            , Icons.chevronDown
                [ Html.class "accordion-open-icon"
                , css [ width (rem 1.25), color Colors.deepBlue ]
                ]
            , Icons.chevronUp
                [ Html.class "accordion-closed-icon"
                , css [ width (rem 1.25), color Colors.deepBlue ]
                ]
            ]
        , Html.wrappedRow
            [ css
                [ marginTop (rem 2)
                , marginBottom (rem -1.5)
                , marginRight (rem -1)
                , Css.children
                    [ Css.everything
                        [ marginBottom (rem 1.5)
                        , marginRight (rem 1)
                        ]
                    ]
                ]
            ]
            children
        ]


header : List (Attribute msg) -> List (Html msg) -> Html msg
header attrs children =
    Html.div
        (css [] :: attrs)
        (children
            ++ [ Html.hr
                    [ css
                        [ width auto
                        , borderStyle none
                        , height (rem 0.0625)
                        , backgroundColor Colors.coolGray
                        , margin2 (rem 1) (rem -1.5)
                        ]
                    ]
                    []
               ]
        )


title : List (Attribute msg) -> List (Html msg) -> Html msg
title attrs children =
    Text.bodyTextHeavy
        |> Text.view attrs children


infoBox : List (Attribute msg) -> List (Html msg) -> Html msg
infoBox attrs content =
    Html.column
        (css
            [ borderRadius (rem 0.5)
            , border3 (rem 0.0625) solid Colors.lightGray
            , padding (rem 1)
            ]
            :: attrs
        )
        content


footer : List (Attribute msg) -> List (Html msg) -> Html msg
footer attrs children =
    Html.div
        (css [] :: attrs)
        (Html.hr
            [ css
                [ width auto
                , borderStyle none
                , height (rem 0.0625)
                , backgroundColor Colors.coolGray
                , margin2 (rem 1) (rem -1.5)
                ]
            ]
            []
            :: children
        )


withTitle : String -> Card msg -> Card msg
withTitle title_ (Card config) =
    Card { config | title = Just title_ }


withShadow : Card msg -> Card msg
withShadow (Card config) =
    Card { config | hasShadow = True }
