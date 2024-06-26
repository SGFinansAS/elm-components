module Nordea.Components.SortableTable exposing
    ( Sorting(..)
    , dataRow
    , element
    , headerRow
    , mobileDataRow
    , mobileElement
    , mobileElementFull
    , mobileTextElement
    , numericElement
    , numericHeader
    , sortableNumericHeader
    , sortableTextHeader
    , sortingAsDict
    , sortingToString
    , tbody
    , textElement
    , textHeader
    , thead
    , view
    )

import Css
    exposing
        ( alignItems
        , backgroundColor
        , block
        , borderRadius
        , center
        , color
        , column
        , cursor
        , display
        , displayFlex
        , ellipsis
        , flex
        , flexDirection
        , flexShrink
        , flexStart
        , height
        , hidden
        , int
        , marginBottom
        , marginLeft
        , marginRight
        , noWrap
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
        , right
        , textAlign
        , textDecoration
        , textOverflow
        , underline
        , whiteSpace
        , width
        )
import Css.Media
import Dict exposing (Dict)
import Html.Styled as Html exposing (Attribute, Html, styled)
import Html.Styled.Attributes as Attrs exposing (css)
import Html.Styled.Events as Events
import Nordea.Components.Text as Text
import Nordea.Css exposing (gap)
import Nordea.Html
import Nordea.Resources.Colors as Color
import Nordea.Resources.Icons


type Sorting
    = Desc
    | Asc


view : List (Attribute msg) -> List (Html msg) -> Html msg
view attrs children =
    Html.table
        (css
            [ displayFlex
            , flexDirection column
            , borderRadius (rem 0.5)
            ]
            :: attrs
        )
        children


thead : List (Attribute msg) -> List (Html msg) -> Html msg
thead =
    Html.thead


headerRow : List (Attribute msg) -> List (Html msg) -> Html msg
headerRow =
    styled
        Html.tr
        [ displayFlex
        , position relative
        , alignItems center
        , padding2 (rem 0) (rem 1.5)
        , marginBottom (rem 0.5)
        , smallerScreenOnly [ padding2 (rem 0) (rem 0.875) ]
        ]


headerElement : List (Attribute msg) -> List (Html msg) -> Html msg
headerElement attrs =
    Html.th
        (css [ flex (num 1), pseudoClass "not(:first-child)" [ marginLeft (rem 1) ] ] :: attrs)


sortableTextHeaderStyled : { css : List Css.Style, textCss : List Css.Style, chevronAlignRight : Bool, sorting : Maybe Sorting, onClick : msg, label : String } -> Html msg
sortableTextHeaderStyled config =
    let
        chevronStyle =
            [ css
                [ flexShrink (int 0)
                , width (rem 0.5)
                , (if config.chevronAlignRight then
                    marginRight

                   else
                    marginLeft
                  )
                    (rem 1)
                ]
            ]

        scrollDirectionChevron =
            case config.sorting of
                Just Desc ->
                    Nordea.Resources.Icons.triangleDown chevronStyle

                Just Asc ->
                    Nordea.Resources.Icons.triangleUp chevronStyle

                Nothing ->
                    Nordea.Html.nothing

        activeSortingHeaderStyle : List Css.Style
        activeSortingHeaderStyle =
            case config.sorting of
                Nothing ->
                    []

                _ ->
                    [ textDecoration underline ]

        content =
            [ Html.text config.label
            , scrollDirectionChevron
            ]
    in
    headerElement
        [ Events.onClick config.onClick
        , Attrs.title config.label
        , css
            (config.css
                ++ Css.hover [ textDecoration underline ]
                :: cursor pointer
                :: activeSortingHeaderStyle
            )
        ]
        [ Text.textTinyLight
            |> Text.view
                [ css
                    ([ displayFlex
                     , textOverflow ellipsis
                     , overflow hidden
                     , color Color.eclipse
                     ]
                        ++ config.textCss
                    )
                ]
                (if config.chevronAlignRight then
                    List.reverse content

                 else
                    content
                )
        ]


sortableTextHeader : { css : List Css.Style, sorting : Maybe Sorting, onClick : msg, label : String } -> Html msg
sortableTextHeader config =
    sortableTextHeaderStyled { css = config.css, textCss = [], chevronAlignRight = False, sorting = config.sorting, onClick = config.onClick, label = config.label }


sortableNumericHeader : { css : List Css.Style, sorting : Maybe Sorting, onClick : msg, label : String } -> Html msg
sortableNumericHeader config =
    sortableTextHeaderStyled { css = config.css, textCss = [ textAlign right, display block ], chevronAlignRight = True, sorting = config.sorting, onClick = config.onClick, label = config.label }


textHeaderStyled : { css : List Css.Style, textCss : List Css.Style, label : String } -> Html msg
textHeaderStyled config =
    headerElement
        [ Attrs.title config.label
        , css (flex (num 1) :: config.css)
        ]
        [ Text.textTinyLight
            |> Text.view
                [ css
                    ([ displayFlex
                     , textOverflow ellipsis
                     , overflow hidden
                     , whiteSpace noWrap
                     , color Color.eclipse
                     ]
                        ++ config.textCss
                    )
                ]
                [ Html.text config.label ]
        ]


textHeader : { css : List Css.Style, label : String } -> Html msg
textHeader config =
    textHeaderStyled { css = config.css, textCss = [], label = config.label }


numericHeader : { css : List Css.Style, label : String } -> Html msg
numericHeader config =
    textHeaderStyled { css = config.css, textCss = [ textAlign right, display block ], label = config.label }


tbody : List (Attribute msg) -> List (Html msg) -> Html msg
tbody attrs =
    Html.tbody (css [ displayFlex, flexDirection column ] :: attrs)


dataRow : List (Attribute msg) -> List (Html msg) -> Html msg
dataRow =
    styled Html.tr
        [ displayFlex
        , alignItems center
        , position relative
        , height (rem 3.2)
        , marginBottom (rem 0.5)
        , padding2 (rem 0.5) (rem 1.5)
        , borderRadius (rem 0.5)
        , backgroundColor Color.white
        , smallerScreenOnly [ padding2 (rem 0) (rem 0.875) ]
        ]


element : List (Attribute msg) -> List (Html msg) -> Html msg
element attrs =
    Html.td
        (css
            [ flex (num 1)
            , displayFlex
            , pseudoClass "not(:first-child)" [ marginLeft (rem 1) ]
            ]
            :: attrs
        )


textElement : { css : List Css.Style, label : String } -> Html msg
textElement config =
    element
        [ Attrs.title config.label
        , css (flex (num 1) :: config.css)
        ]
        [ Text.textLight
            |> Text.view
                [ css
                    [ textOverflow ellipsis
                    , overflow hidden
                    , whiteSpace noWrap
                    ]
                ]
                [ Html.text config.label ]
        ]


numericElement : { css : List Css.Style, label : String } -> Html msg
numericElement config =
    textElement { css = [ textAlign right, display block ] ++ config.css, label = config.label }


mobileDataRow : List (Attribute msg) -> List (Html msg) -> Html msg
mobileDataRow =
    styled Html.tr
        [ displayFlex
        , Css.flexWrap Css.wrap
        , marginBottom (rem 1)
        , position relative
        , padding (rem 1.5)
        , borderRadius (rem 1)
        , backgroundColor Color.white
        , gap (rem 1)
        ]


mobileElement : List (Attribute msg) -> List (Html msg) -> Html msg
mobileElement attrs =
    Html.td
        (css [ displayFlex, flexDirection column, alignItems flexStart ] :: attrs)


mobileElementFull : List (Attribute msg) -> List (Html msg) -> Html msg
mobileElementFull attrs =
    Html.td
        (css [ Css.flexBasis (pct 100), displayFlex, flexDirection column, alignItems flexStart ] :: attrs)


mobileTextElement : { css : List Css.Style, label : String } -> Html msg
mobileTextElement config =
    mobileElement
        [ Attrs.title config.label, css config.css ]
        [ Html.text config.label ]


smallerScreenOnly : List Css.Style -> Css.Style
smallerScreenOnly styleAttrs =
    Css.Media.withMedia
        [ Css.Media.all [ Css.Media.maxWidth (px 950) ] ]
        styleAttrs


sortingToString : Sorting -> String
sortingToString sorting =
    case sorting of
        Asc ->
            "asc"

        Desc ->
            "desc"


sortingAsDict : Dict String Sorting
sortingAsDict =
    Dict.fromList
        [ ( sortingToString Asc, Asc )
        , ( sortingToString Desc, Desc )
        ]
