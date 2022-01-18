module Nordea.Components.Error exposing (internalServerError, pageNotFound, view, withCustomSupportEmail)

import Css
    exposing
        ( alignItems
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
import Html.Styled.Attributes as Attributes exposing (css, href)
import Nordea.Components.FlatLink as FlatLink
import Nordea.Components.Text as Text
import Nordea.Html exposing (showIf)
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Icons as Icons
import Svg.Styled as Svg exposing (Svg)
import Svg.Styled.Attributes as SvgAttrs exposing (d)


type alias Translation =
    { no : String, se : String, dk : String } -> String


type alias ErrorConfig =
    { errorType : ErrorType
    , customSupportEmail : Maybe String
    , translate : Translation
    }


type ErrorType
    = InternalServerError
    | PageNotFound


type Error msg
    = Error ErrorConfig


internalServerError : Translation -> Error msg
internalServerError translate =
    init
        { errorType = InternalServerError
        , customSupportEmail = Nothing
        , translate = translate
        }


pageNotFound : Translation -> Error msg
pageNotFound locale =
    init
        { errorType = PageNotFound
        , customSupportEmail = Nothing
        , translate = locale
        }


init : ErrorConfig -> Error msg
init config =
    Error
        { translate = config.translate
        , customSupportEmail = Nothing
        , errorType = config.errorType
        }


withCustomSupportEmail : String -> Error msg -> Error msg
withCustomSupportEmail customSupportEmail (Error config) =
    Error { config | customSupportEmail = Just customSupportEmail }


view : List (Attribute msg) -> List (Html msg) -> Error msg -> Html msg
view attributes children (Error config) =
    let
        errorDescription =
            case config.errorType of
                PageNotFound ->
                    texts.pageNotFound.description |> config.translate

                InternalServerError ->
                    texts.internalServerError.description |> config.translate
    in
    Html.div
        [ css
            [ backgroundColor Colors.white
            , width (pct 100)
            , height (vh 100)
            , padding (rem 1.5)
            , displayFlex
            , flexDirection column
            , alignItems center
            ]
        ]
        ([ Text.headlineTwo
            |> Text.withHtmlTag Html.h1
            |> Text.view
                [ css [ textAlign center, marginBottom (rem 1) ] ]
                [ Html.text (texts.heading |> config.translate) ]
         , Text.bodyTextLight
            |> Text.view
                [ css
                    [ marginBottom (rem 2)
                    , maxWidth (rem 30)
                    , textAlign center
                    ]
                ]
                [ Html.text errorDescription ]
         , Icons.errorSvg [ css [ width (rem 30) ] ]
         , viewActionForInternalServerError config
            |> showIf (config.errorType == InternalServerError)
         ]
            ++ children
        )


viewActionForInternalServerError : ErrorConfig -> Html msg
viewActionForInternalServerError config =
    let
        ( errorActionText, customerServiceEmail ) =
            ( texts.internalServerError.action |> config.translate
            , config.customSupportEmail |> Maybe.withDefault (texts.customerServiceEmail |> config.translate)
            )
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
                    [ href ("mailto:" ++ customerServiceEmail)
                    , css [ display inlineBlock ]
                    ]
                    [ Html.text customerServiceEmail ]
            ]


texts =
    { heading =
        { no = "Oops! Her var det ikke mye å hente"
        , se = "Oops! Här fanns inte mycket att hämta"
        , dk = "Oops! Her var ikke meget at hente"
        }
    , internalServerError =
        { description =
            { no = "Grunnen til at du har kommet hit kan være at det er noen nettverksproblemer eller at noe er galt hos oss."
            , se = "Anledningen till att du har kommit hit kan vara att det är några nätverksproblem eller att något är fel på oss."
            , dk = "Grunden til at du er kommet hertil kan være at der er nogle netværksproblemer eller at der er noget galt med os."
            }
        , action =
            { no = "Prøv å oppdatere siden eller kontakt oss på "
            , se = "Försök att uppdatera sidan eller kontakta oss på "
            , dk = "Prøv å oppdatere siden eller kontakt oss på "
            }
        }
    , pageNotFound =
        { description =
            { no = "Grunnen til at du har kommet hit kan være at det er noe feil med linken, eller at siden er slettet."
            , se = "Anledningen till att du har kommit hit kan vara att det är något fel på länken, eller att sidan har raderats."
            , dk = "Grunden til at du er kommet hertil kan være, at der er noget galt med linket, eller at siden er blevet slettet."
            }
        }
    , customerServiceEmail =
        { no = "kundeservice.no@nordeafinance.com"
        , se = "eq-kundeportal.se@nordeafinance.com"
        , dk = "kundeservice.dk@nordeafinance.com"
        }
    }
