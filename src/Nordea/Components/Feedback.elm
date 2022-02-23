module Nordea.Components.Feedback exposing (floatingButton, view)

import Css
    exposing
        ( auto
        , backgroundColor
        , borderBottomLeftRadius
        , borderBottomRightRadius
        , borderRadius
        , borderTopLeftRadius
        , borderTopRightRadius
        , boxShadow4
        , column
        , deg
        , displayFlex
        , fixed
        , flexDirection
        , focus
        , hover
        , int
        , marginLeft
        , maxHeight
        , minHeight
        , none
        , outline
        , overflow
        , padding
        , paddingLeft
        , pct
        , position
        , rem
        , right
        , rotateZ
        , top
        , transforms
        , translateX
        , translateY
        , vh
        , width
        , zIndex
        )
import Css.Transitions exposing (transition)
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events exposing (onClick)
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Fonts as Fonts
import Nordea.Themes as Themes


view : List (Attribute msg) -> List (Html msg) -> Html msg
view attrs children =
    Html.div
        (css
            [ displayFlex
            , flexDirection column
            , position fixed
            , right (rem 1)
            , transforms [ translateY (pct -50) ]
            , top (pct 50)
            , marginLeft (rem 1)
            , backgroundColor Colors.white
            , zIndex (int 99)
            , boxShadow4 (rem 0) (rem 0.25) (rem 2.5) Colors.grayLight
            , padding (rem 1.5)
            , borderRadius (rem 0.25)
            , width (pct 100)
            , Css.property "max-width" "min(23rem, calc(100% - 2rem))"
            , minHeight (rem 27)
            , maxHeight (vh 100)
            , overflow auto
            ]
            :: attrs
        )
        children



-- receiptView : { header : String, body : String } -> List (Html msg)
-- receiptView { header, body } =
--     [ closeButton
--     , Icons.feedbackEnvelope [ css [ width (rem 10), alignSelf center ] ]
--     , Html.h3
--         [ css [ fontWeight normal, margin (rem 0), marginTop (rem 2), alignSelf center ] ]
--         [ Text.panelTitle [] [ Html.text header ] ]
--     , Html.p [ css [ marginTop (rem 1.5) ] ]
--         [ Text.body [ css [ lineHeight (rem 1) |> Css.important ] ] [ Html.text text ] ]
--     ]
-- closeButton : msg -> Html msg
-- closeButton onClickClose =
--     Button.tertiary
--         |> Button.view
--             [ css [ alignItems center, marginLeft auto, marginRight (rem -1) ]
--             , onClick onClickClose
--             ]
--             [ Icons.cross
--                 [ css
--                     [ width (rem 1)
--                     , height (rem 1)
--                     , Themes.color Themes.PrimaryColor Colors.deepBlue
--                     ]
--                 ]
--             ]


floatingButton : ({ no : String, se : String, dk : String } -> String) -> msg -> Html msg
floatingButton translate onClick_ =
    Html.button
        [ css
            [ position fixed
            , right (rem -0.25)
            , top (pct 50)
            , padding (rem 0.75)
            , paddingLeft (rem 1)
            , transforms [ translateY (pct -50) ]
            , borderTopRightRadius (rem 0)
            , borderBottomRightRadius (rem 0)
            , borderTopLeftRadius (rem 0.25)
            , borderBottomLeftRadius (rem 0.25)
            , transition [ Css.Transitions.transform 100 ]
            , zIndex (int 99)
            , Fonts.fromSize 1
            , Themes.backgroundColor Themes.PrimaryColor Colors.blueDeep
            , Themes.color Themes.TextColorOnPrimaryColorBackground Colors.white
            , hover
                [ transforms [ translateY (pct -50), translateX (rem -0.25) ]
                , Themes.backgroundColor Themes.SecondaryColor Colors.blueCloud
                , Themes.color Themes.PrimaryColor Colors.blueDeep
                ]
            , focus
                [ outline none
                , Themes.backgroundColor Themes.PrimaryColorLight Colors.blueNordea
                , Themes.color Themes.SecondaryColor Colors.blueHaas
                , Css.property "box-shadow" ("0rem 0rem 0rem 0.25rem " ++ Themes.colorVariable Themes.SecondaryColor Colors.blueHaas)
                ]
            ]
        , onClick onClick_
        ]
        [ Html.div
            [ css
                [ Css.property "text-orientation" "sideways"
                , Css.property "writing-mode" "vertical-lr"
                , transforms [ rotateZ (deg 180) ]
                ]
            ]
            [ strings.feedback |> translate |> Html.text ]
        ]



-- Translations


strings =
    { feedback =
        { no = "Tilbakemelding"
        , se = "Återkoppling"
        , dk = "Tilbagemelding"
        }

    -- , feedbackDescription =
    --     { no = "Hvordan kan vi gjøre Partnerhub bedre? Har du problemer med noe du vil melde inn?"
    --     , se = "Hur kan vi göra PartnerHub bättre? Upplever du problem med något, återkoppla till oss."
    --     , dk = "Hvordan kan vi gøre vores Partnerhub endnu bedre? Har du udfordringer og ønsker at give os besked?"
    --     }
    -- , feedbackMessageLabel =
    --     { no = "Din tilbakemelding"
    --     , se = "Din återkoppling"
    --     , dk = "Din tilbagemelding:"
    --     }
    -- , submit =
    --     { no = "Send inn"
    --     , se = "Skicka in"
    --     , dk = "Indsend"
    --     }
    -- , thanksForFeedback =
    --     { no = "Takk for tilbakemeldingen!"
    --     , se = "Tack för återkopplingen!"
    --     , dk = "Tak for tilbagemeldingen."
    --     }
    -- , thanksForFeedbackDescription =
    --     { no = "Tusen takk for din tilbakemelding! Vi leser alle tilbakemeldingene vi får, og vil følge deg opp dersom vi har spørsmål."
    --     , se = "Vi läser alla återkopplingar som vi får in från er och vi följer upp om vi har eventuella frågor."
    --     , dk = "Tusind tak for din tilbagemelding. Vi læser alle tilbagemeldinger som vi modtager, og vil kontakte dig, hvis vi har spørgsmål til din tilbagemelding."
    --     }
    -- , close =
    --     { no = "Lukk"
    --     , se = "Stäng"
    --     , dk = "Luk"
    --     }
    -- , includeEmail =
    --     { no = "Jeg ønsker å legge ved min e-postadresse for å eventuelt bli fulgt opp"
    --     , se = "Jag önskar att bli kontaktad via e-post vid en eventuell uppföljning"
    --     , dk = "Jeg ønsker at indsætte min e-mail for eventuel opfølgning på min tilbagemelding"
    --     }
    }
