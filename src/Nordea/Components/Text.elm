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
    , textTinyHeavy
    , textTinyLight
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
import Nordea.Resources.Fonts as Fonts



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
    | TextTinyLight
    | TextTinyHeavy


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


{-| Deprecated, use textTinyLight
-}
textTiny : Headline msg
textTiny =
    init TextTinyLight


textTinyLight : Headline msg
textTinyLight =
    init TextTinyLight


textTinyHeavy : Headline msg
textTinyHeavy =
    init TextTinyHeavy


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
                    Html.div

                TitleHeavy ->
                    Html.div

                BodyTextHeavy ->
                    Html.div

                BodyTextLight ->
                    Html.div

                BodyTextSmall ->
                    Html.div

                TextHeavy ->
                    Html.div

                TextLight ->
                    Html.div

                TextSmallLight ->
                    Html.div

                TextSmallHeavy ->
                    Html.div

                TextTinyLight ->
                    Html.div

                TextTinyHeavy ->
                    Html.div
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
                [ Fonts.fromSize 3
                , fontWeight (int 500)
                , lineHeight (rem 3.5)
                , margin zero
                ]

        HeadlineTwo ->
            Css.batch
                [ Fonts.fromSize 2.5
                , fontWeight (int 500)
                , lineHeight (rem 2.75)
                , margin zero
                ]

        HeadlineThree ->
            Css.batch
                [ Fonts.fromSize 2
                , fontWeight (int 500)
                , lineHeight (rem 2.25)
                , margin zero
                ]

        HeadlineFourLight ->
            Css.batch
                [ Fonts.fromSize 1.625
                , fontWeight normal
                , lineHeight (rem 2)
                , margin zero
                ]

        HeadlineFourHeavy ->
            Css.batch
                [ Fonts.fromSize 1.625
                , fontWeight (int 500)
                , lineHeight (rem 2)
                , margin zero
                ]

        TitleLight ->
            Css.batch
                [ Fonts.fromSize 1.375
                , fontWeight normal
                , lineHeight (rem 1.75)
                ]

        TitleHeavy ->
            Css.batch
                [ Fonts.fromSize 1.375
                , fontWeight (int 500)
                , fontSize (rem 1.375)
                , lineHeight (rem 1.75)
                ]

        BodyTextHeavy ->
            Css.batch
                [ Fonts.fromSize 1.125
                , fontWeight (int 500)
                , lineHeight (rem 1.5)
                , margin zero
                ]

        BodyTextLight ->
            Css.batch
                [ Fonts.fromSize 1.125
                , fontWeight normal
                , lineHeight (rem 1.5)
                , margin zero
                ]

        BodyTextSmall ->
            Css.batch
                [ Fonts.fromSize 1
                , fontWeight normal
                , lineHeight (rem 1.5)
                , margin zero
                ]

        TextHeavy ->
            Css.batch
                [ Fonts.fromSize 1
                , fontWeight (int 500)
                , lineHeight (rem 1.25)
                ]

        TextLight ->
            Css.batch
                [ Fonts.fromSize 1
                , fontWeight normal
                , lineHeight (rem 1.25)
                ]

        TextSmallLight ->
            Css.batch
                [ Fonts.fromSize 0.875
                , fontWeight normal
                , lineHeight (rem 1.125)
                ]

        TextSmallHeavy ->
            Css.batch
                [ Fonts.fromSize 0.875
                , fontWeight (int 500)
                , lineHeight (rem 1.125)
                ]

        TextTinyLight ->
            Css.batch
                [ Fonts.fromSize 0.75
                , fontWeight normal
                , lineHeight (rem 1)
                ]

        TextTinyHeavy ->
            Css.batch
                [ Fonts.fromSize 0.75
                , fontWeight (int 500)
                , lineHeight (rem 1)
                ]
