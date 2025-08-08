module Nordea.Components.Card exposing
    ( Card
    , footer
    , infoBox
    , init
    , isCollapsible
    , title
    , view
    , withHtmlTitle
    , withShadow
    , withTitle
    )

import Css
    exposing
        ( alignItems
        , auto
        , backgroundColor
        , border3
        , borderRadius
        , borderStyle
        , boxShadow4
        , center
        , color
        , column
        , cursor
        , displayFlex
        , firstChild
        , flexDirection
        , height
        , left
        , margin2
        , marginBottom
        , marginLeft
        , marginTop
        , none
        , padding
        , pointer
        , rem
        , solid
        , textAlign
        , width
        )
import Css.Global as Css
import Css.Transitions as Transitions exposing (transition)
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Html exposing (attribute, css)
import Html.Styled.Events exposing (onClick)
import Maybe.Extra as Maybe
import Nordea.Components.AccordionMenu as AccordionMenu
import Nordea.Components.Text as Text
import Nordea.Html as Html exposing (styleIf, viewMaybe)
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Icons as Icons


type alias CardProperties msg =
    { title : Maybe (Html msg)
    , emphasisedText : Maybe (Html msg)
    , hasShadow : Bool
    , isCollapsible : Bool
    , isOpen : Bool
    , onClick : Maybe msg
    }


type Card msg
    = Card (CardProperties msg)


init : Card msg
init =
    Card
        { title = Nothing
        , emphasisedText = Nothing
        , hasShadow = False
        , isCollapsible = False
        , isOpen = False
        , onClick = Nothing
        }


view : List (Attribute msg) -> List (Html msg) -> Card msg -> Html msg
view attrs children (Card config) =
    let
        baseStyle =
            css
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
    in
    if config.isCollapsible then
        AccordionMenu.view { isOpen = config.isOpen }
            baseStyle
            [ headerCollapsible (Maybe.values [ config.onClick |> Maybe.map onClick ])
                [ config.title
                    |> viewMaybe (\title_ -> title_)
                , config.emphasisedText
                    |> viewMaybe
                        (\emphasisedText_ -> emphasisedTextWithTransition emphasisedText_)
                ]
            , Html.div [ css [ marginTop (rem 1.5) ] ] children
            ]

    else
        case config.title of
            Just title_ ->
                Html.div
                    (css
                        [ Css.children [ Css.everything [ firstChild [ marginBottom (rem 1.5) ] ] ] ]
                        :: baseStyle
                    )
                    (title_ :: children)

            Nothing ->
                Html.div baseStyle children


headerCollapsible : List (Attribute msg) -> List (Html msg) -> Html msg
headerCollapsible attrs children =
    Html.summary
        (css [ displayFlex, alignItems center, cursor pointer ] :: attrs)
        (children
            ++ [ Icons.chevronDown
                    [ Html.class "accordion-open-icon"
                    , attribute "aria-hidden" "true"
                    , css [ width (rem 1.25), color Colors.deepBlue ]
                    ]
               , Icons.chevronUp
                    [ Html.class "accordion-closed-icon"
                    , attribute "aria-hidden" "true"
                    , css [ width (rem 1.25), color Colors.deepBlue ]
                    ]
               ]
        )


emphasisedTextWithTransition : Html msg -> Html msg
emphasisedTextWithTransition emphasisedText =
    Html.div
        [ css
            [ transition [ Transitions.opacity3 400 0 Transitions.ease ]
            , displayFlex
            , marginLeft auto
            ]
        , Html.class "accordion-closed-text"
        ]
        [ emphasisedText ]


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
    Card { config | title = Just (title [] [ Html.text title_ ]) }


withHtmlTitle : Html msg -> Card msg -> Card msg
withHtmlTitle title_ (Card config) =
    Card { config | title = Just title_ }


withShadow : Card msg -> Card msg
withShadow (Card config) =
    Card { config | hasShadow = True }


isCollapsible :
    Maybe { emphasisedText : Maybe (Html msg), isOpen : Bool, onClick : msg }
    -> Card msg
    -> Card msg
isCollapsible collapsibleProps (Card config) =
    case collapsibleProps of
        Nothing ->
            Card config

        Just props ->
            Card
                { config
                    | isCollapsible = True
                    , emphasisedText = props.emphasisedText
                    , isOpen = props.isOpen
                    , onClick = Just props.onClick
                }
