module Nordea.Components.Error exposing (internalServerError, pageNotFound, view)

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
        , height
        , inlineBlock
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
import Nordea.Components.Common exposing (Translation)
import Nordea.Components.FlatLink as FlatLink
import Nordea.Components.Text as Text
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Illustrations as Illustrations


type alias InternalServerErrorConfig =
    { supportEmail : String
    , translate : Translation -> String
    }


type alias PageNotFoundErrorConfig =
    { translate : Translation -> String }


type Error
    = InternalServerError InternalServerErrorConfig
    | PageNotFound PageNotFoundErrorConfig


internalServerError : (Translation -> String) -> String -> Error
internalServerError translate supportEmail =
    InternalServerError
        { supportEmail = supportEmail
        , translate = translate
        }


pageNotFound : (Translation -> String) -> Error
pageNotFound translate =
    PageNotFound
        { translate = translate
        }


view : List (Attribute msg) -> List (Html msg) -> Error -> Html msg
view attributes children error =
    case error of
        InternalServerError config ->
            viewInternalServerError attributes children config

        PageNotFound config ->
            viewPageNotFoundError attributes children config


viewInternalServerError : List (Attribute msg) -> List (Html msg) -> InternalServerErrorConfig -> Html msg
viewInternalServerError attributes children config =
    Html.div
        (css [ errorContainerStyle ] :: attributes)
        ([ Illustrations.errorSvg [ css [ width (rem 12), marginBottom (rem 2.5) ] ]
         , viewHeading (texts.heading |> config.translate)
         , viewDescription (texts.internalServerError.description |> config.translate)
         , viewActionForInternalServerError config
         ]
            ++ children
        )


viewPageNotFoundError : List (Attribute msg) -> List (Html msg) -> PageNotFoundErrorConfig -> Html msg
viewPageNotFoundError attributes children config =
    Html.div
        (css [ errorContainerStyle ] :: attributes)
        ([ Illustrations.errorSvg [ css [ width (rem 12), marginBottom (rem 2.5) ] ]
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
    Text.headlineTwo
        |> Text.withHtmlTag Html.h1
        |> Text.view
            [ css [ textAlign center, marginBottom (rem 1) ] ]
            [ Html.text heading ]


viewDescription : String -> Html msg
viewDescription description =
    Text.bodyTextLight
        |> Text.view
            [ css
                [ marginBottom (rem 1)
                , maxWidth (rem 30)
                , textAlign center
                ]
            ]
            [ Html.text description ]


viewActionForInternalServerError : InternalServerErrorConfig -> Html msg
viewActionForInternalServerError config =
    let
        errorActionText =
            texts.internalServerError.action |> config.translate
    in
    Text.bodyTextLight
        |> Text.view
            [ css
                [ maxWidth (rem 30)
                , paddingRight (rem 0.25)
                , textAlign center
                ]
            ]
            [ Html.text errorActionText
            , FlatLink.default
                |> FlatLink.view
                    [ href ("mailto:" ++ config.supportEmail)
                    , css [ display inlineBlock ]
                    ]
                    [ Html.text config.supportEmail ]
            ]


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
            , se = "Anledningen till att du har kommit hit kan vara att det är några nätverksproblem eller att något är fel på oss."
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
            , se = "Anledningen till att du har kommit hit kan vara att det är något fel på länken, eller att sidan har raderats."
            , dk = "Grunden til at du er kommet hertil kan være, at der er noget galt med linket, eller at siden er blevet slettet."
            , en = "The reason why you have come here may be that there is something wrong with the link, or that the page has been deleted."
            }
        }
    }
