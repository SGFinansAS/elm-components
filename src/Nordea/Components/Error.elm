module Nordea.Components.Error exposing (internalServerError, pageNotFound, view, withCustomIllustration)

import Css
    exposing
        ( Style
        , alignItems
        , backgroundColor
        , center
        , column
        , display
        , displayFlex
        , flexDirection
        , fontWeight
        , height
        , inlineBlock
        , int
        , marginBottom
        , maxWidth
        , padding
        , paddingRight
        , pct
        , rem
        , textAlign
        , vh
        , width
        )
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes exposing (css, href)
import Nordea.Components.FlatLink as FlatLink
import Nordea.Components.Text as Text
import Nordea.Resources.Colors as Colors
import Nordea.Resources.I18N exposing (Translation)
import Nordea.Resources.Illustrations as Illustrations
import Svg.Styled exposing (Svg)


type alias InternalServerErrorConfig msg =
    { supportEmail : String
    , translate : Translation -> String
    , customIllustration : Maybe (Svg msg)
    }


type alias PageNotFoundErrorConfig msg =
    { translate : Translation -> String
    , customIllustration : Maybe (Svg msg)
    }


type Error msg
    = InternalServerError (InternalServerErrorConfig msg)
    | PageNotFound (PageNotFoundErrorConfig msg)


internalServerError : (Translation -> String) -> String -> Error msg
internalServerError translate supportEmail =
    InternalServerError
        { supportEmail = supportEmail
        , translate = translate
        , customIllustration = Nothing
        }


pageNotFound : (Translation -> String) -> Error msg
pageNotFound translate =
    PageNotFound
        { translate = translate
        , customIllustration = Nothing
        }


view : List (Attribute msg) -> List (Html msg) -> Error msg -> Html msg
view attributes children error =
    case error of
        InternalServerError config ->
            viewInternalServerError attributes children config

        PageNotFound config ->
            viewPageNotFoundError attributes children config


viewInternalServerError : List (Attribute msg) -> List (Html msg) -> InternalServerErrorConfig msg -> Html msg
viewInternalServerError attributes children config =
    Html.div
        (css [ errorContainerStyle ] :: attributes)
        ([ config.customIllustration |> Maybe.withDefault (Illustrations.errorSvg [ css [ width (rem 12), marginBottom (rem 0.75) ] ])
         , viewHeading (texts.heading |> config.translate)
         , viewDescription (texts.internalServerError.description |> config.translate)
         , viewActionForInternalServerError config
         ]
            ++ children
        )


viewPageNotFoundError : List (Attribute msg) -> List (Html msg) -> PageNotFoundErrorConfig msg -> Html msg
viewPageNotFoundError attributes children config =
    Html.div
        (css [ errorContainerStyle ] :: attributes)
        ([ config.customIllustration |> Maybe.withDefault (Illustrations.errorSvg [ css [ width (rem 12), marginBottom (rem 0.75) ] ])
         , viewHeading (texts.heading |> config.translate)
         , viewDescription (texts.pageNotFound.description |> config.translate)
         ]
            ++ children
        )


errorContainerStyle : Style
errorContainerStyle =
    Css.batch
        [ backgroundColor Colors.white
        , width (pct 100)
        , height (vh 100)
        , padding (rem 1.5)
        , displayFlex
        , flexDirection column
        , alignItems center
        ]


viewHeading : String -> Html msg
viewHeading heading =
    Text.bodyTextHeavy
        |> Text.withHtmlTag Html.h1
        |> Text.view
            [ css [ textAlign center, marginBottom (rem 0.5), fontWeight (int 600) ] ]
            [ Html.text heading ]


viewDescription : String -> Html msg
viewDescription description =
    Text.textLight
        |> Text.view
            [ css
                [ marginBottom (rem 1.25)
                , maxWidth (rem 50)
                , textAlign center
                ]
            ]
            [ Html.text description ]


viewActionForInternalServerError : InternalServerErrorConfig msg -> Html msg
viewActionForInternalServerError config =
    let
        errorActionText =
            texts.internalServerError.action |> config.translate
    in
    Html.div
        [ css
            [ maxWidth (rem 30)
            , paddingRight (rem 0.25)
            , textAlign center
            ]
        ]
        [ Text.textLight
            |> Text.view [ css [ marginBottom (rem 1) ] ]
                [ Html.text errorActionText ]
        , FlatLink.default
            |> FlatLink.view
                [ href ("mailto:" ++ config.supportEmail)
                , css [ display inlineBlock ]
                ]
                [ Text.textHeavy
                    |> Text.view [ css [ fontWeight (int 600) ] ]
                        [ Html.text config.supportEmail ]
                ]
        ]


withCustomIllustration : Svg msg -> Error msg -> Error msg
withCustomIllustration illustration error =
    case error of
        InternalServerError config ->
            InternalServerError { config | customIllustration = Just illustration }

        PageNotFound config ->
            PageNotFound { config | customIllustration = Just illustration }


texts : { heading : Translation, internalServerError : { description : Translation, action : Translation }, pageNotFound : { description : Translation } }
texts =
    { heading =
        { no = "Oops! Her var det ikke mye å hente"
        , se = "Oops! Här fanns inte mycket att hämta"
        , dk = "Oops! Her var ikke meget at hente"
        , en = "Wops! There was not much to find here"
        }
    , internalServerError =
        { description =
            { no = "Grunnen til at du har kommet hit kan være at det er noen nettverksproblemer eller at noe er galt hos oss."
            , se = "Anledningen till att du har kommit hit kan vara att det är några nätverksproblem eller att något är fel hos oss."
            , dk = "Grunden til at du er kommet hertil kan være at der er nogle netværksproblemer eller at der er noget galt hos os."
            , en = "The reason why you ended up here could be due to network issues or that something is wrong in our systems."
            }
        , action =
            { no = "Prøv å oppdatere siden eller kontakt oss på "
            , se = "Försök att uppdatera sidan eller kontakta oss på "
            , dk = "Prøv at opdatere siden eller kontakt os på "
            , en = "Please try to refresh the page or contact us on "
            }
        }
    , pageNotFound =
        { description =
            { no = "Grunnen til at du har kommet hit kan være at det er noe feil med linken, eller at siden er slettet."
            , se = "Anledningen till att du har kommit hit kan vara att det är något fel på länken eller att sidan har raderats."
            , dk = "Grunden til at du er kommet hertil kan være, at der er noget galt med linket, eller at siden er blevet slettet."
            , en = "The reason why you have come here may be that there is something wrong with the link, or that the page has been deleted."
            }
        }
    }
