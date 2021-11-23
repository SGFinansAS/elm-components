module Nordea.Components.Text exposing
    ( Headline
    , Variant(..)
    , bodyTextHeavy
    , bodyTextLight
    , bodyTextSmall
    , headlineFourHeavy
    , headlineFourLight
    , headlineOne
    , headlineThree
    , headlineTwo
    , init
    , textHeavy
    , textLight
    , textSmallHeavy
    , textSmallLight
    , textTiny
    , titleHeavy
    , titleLight
    , view
    , withHtmlTag
    )

import Css
    exposing
        ( Style
        , fontFamilies
        , fontSize
        , fontWeight
        , int
        , lineHeight
        , margin
        , normal
        , rem
        , zero
        )
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes exposing (css)



-- CONFIG


type Variant
    = HeadlineOne
    | HeadlineTwo
    | HeadlineThree
    | HeadlineFourLight
    | HeadlineFourHeavy
    | TitleLight
    | TitleHeavy
    | BodyTextHeavy
    | BodyTextLight
    | BodyTextSmall
    | TextHeavy
    | TextLight
    | TextSmallLight
    | TextSmallHeavy
    | TextTiny


type alias Config msg =
    { variant : Variant, htmlTag : List (Attribute msg) -> List (Html msg) -> Html msg }


type Headline msg
    = Headline (Config msg)


headlineOne : Headline msg
headlineOne =
    init HeadlineOne


headlineTwo : Headline msg
headlineTwo =
    init HeadlineTwo


headlineThree : Headline msg
headlineThree =
    init HeadlineThree


headlineFourLight : Headline msg
headlineFourLight =
    init HeadlineFourLight


headlineFourHeavy : Headline msg
headlineFourHeavy =
    init HeadlineFourHeavy


titleLight : Headline msg
titleLight =
    init TitleLight


titleHeavy : Headline msg
titleHeavy =
    init TitleHeavy


bodyTextHeavy : Headline msg
bodyTextHeavy =
    init BodyTextHeavy


bodyTextLight : Headline msg
bodyTextLight =
    init BodyTextLight


bodyTextSmall : Headline msg
bodyTextSmall =
    init BodyTextSmall


textHeavy : Headline msg
textHeavy =
    init TextHeavy


textLight : Headline msg
textLight =
    init TextLight


textSmallLight : Headline msg
textSmallLight =
    init TextSmallLight


textSmallHeavy : Headline msg
textSmallHeavy =
    init TextSmallHeavy


textTiny : Headline msg
textTiny =
    init TextTiny


init : Variant -> Headline msg
init variant =
    Headline
        { variant = variant
        , htmlTag =
            case variant of
                HeadlineOne ->
                    Html.h1

                HeadlineTwo ->
                    Html.h2

                HeadlineThree ->
                    Html.h3

                HeadlineFourLight ->
                    Html.h4

                HeadlineFourHeavy ->
                    Html.h4

                TitleLight ->
                    Html.span

                TitleHeavy ->
                    Html.span

                BodyTextHeavy ->
                    Html.span

                BodyTextLight ->
                    Html.span

                BodyTextSmall ->
                    Html.p

                TextHeavy ->
                    Html.span

                TextLight ->
                    Html.span

                TextSmallLight ->
                    Html.span

                TextSmallHeavy ->
                    Html.span

                TextTiny ->
                    Html.span
        }


withHtmlTag : (List (Attribute msg) -> List (Html msg) -> Html msg) -> Headline msg -> Headline msg
withHtmlTag htmlTag (Headline config) =
    Headline { config | htmlTag = htmlTag }



-- VIEW


view : List (Attribute msg) -> List (Html msg) -> Headline msg -> Html msg
view attributes children (Headline config) =
    config.htmlTag (css [ variantStyle config.variant ] :: attributes) children



-- STYLES


variantStyle : Variant -> Style
variantStyle variant =
    case variant of
        HeadlineOne ->
            Css.batch
                [ fontFamilies [ "Nordea Sans Large" ]
                , fontWeight (int 500)
                , fontSize (rem 3)
                , lineHeight (rem 3.5)
                , margin zero
                ]

        HeadlineTwo ->
            Css.batch
                [ fontFamilies [ "Nordea Sans Large" ]
                , fontWeight (int 500)
                , fontSize (rem 2.5)
                , lineHeight (rem 2.75)
                , margin zero
                ]

        HeadlineThree ->
            Css.batch
                [ fontFamilies [ "Nordea Sans Large" ]
                , fontWeight (int 500)
                , fontSize (rem 2)
                , lineHeight (rem 2.25)
                , margin zero
                ]

        HeadlineFourLight ->
            Css.batch
                [ fontFamilies [ "Nordea Sans Large" ]
                , fontWeight normal
                , fontSize (rem 1.625)
                , lineHeight (rem 2)
                , margin zero
                ]

        HeadlineFourHeavy ->
            Css.batch
                [ fontFamilies [ "Nordea Sans Large" ]
                , fontWeight (int 500)
                , fontSize (rem 1.625)
                , lineHeight (rem 2)
                , margin zero
                ]

        TitleLight ->
            Css.batch
                [ fontFamilies [ "Nordea Sans Small" ]
                , fontWeight normal
                , fontSize (rem 1.375)
                , lineHeight (rem 1.75)
                , margin zero
                ]

        TitleHeavy ->
            Css.batch
                [ fontFamilies [ "Nordea Sans Small" ]
                , fontWeight (int 500)
                , fontSize (rem 1.375)
                , lineHeight (rem 1.75)
                , margin zero
                ]

        BodyTextHeavy ->
            Css.batch
                [ fontFamilies [ "Nordea Sans Small" ]
                , fontWeight (int 500)
                , fontSize (rem 1.125)
                , lineHeight (rem 1.5)
                , margin zero
                ]

        BodyTextLight ->
            Css.batch
                [ fontFamilies [ "Nordea Sans Small" ]
                , fontWeight normal
                , fontSize (rem 1.125)
                , lineHeight (rem 1.5)
                , margin zero
                ]

        BodyTextSmall ->
            Css.batch
                [ fontFamilies [ "Nordea Sans Small" ]
                , fontWeight normal
                , fontSize (rem 1)
                , lineHeight (rem 1.5)
                , margin zero
                ]

        TextHeavy ->
            Css.batch
                [ fontFamilies [ "Nordea Sans Small" ]
                , fontWeight (int 500)
                , fontSize (rem 1)
                , lineHeight (rem 1.25)
                , margin zero
                ]

        TextLight ->
            Css.batch
                [ fontFamilies [ "Nordea Sans Small" ]
                , fontWeight normal
                , fontSize (rem 1)
                , lineHeight (rem 1.25)
                , margin zero
                ]

        TextSmallLight ->
            Css.batch
                [ fontFamilies [ "Nordea Sans Small" ]
                , fontWeight normal
                , fontSize (rem 0.875)
                , lineHeight (rem 1.125)
                , margin zero
                ]

        TextSmallHeavy ->
            Css.batch
                [ fontFamilies [ "Nordea Sans Small" ]
                , fontWeight (int 500)
                , fontSize (rem 0.875)
                , lineHeight (rem 1.125)
                , margin zero
                ]

        TextTiny ->
            Css.batch
                [ fontFamilies [ "Nordea Sans Small" ]
                , fontWeight normal
                , fontSize (rem 0.8125)
                , lineHeight (rem 1)
                , margin zero
                ]
