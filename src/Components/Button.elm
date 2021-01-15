module Components.Button exposing
    ( Button
    , Variant(..)
    , asHtml
    , new
    , withAttributes
    , withChildren
    , withVariant
    )

import Css
    exposing
        ( Style
        , backgroundColor
        , border
        , border3
        , borderRadius
        , color
        , cursor
        , em
        , fontSize
        , hover
        , none
        , padding2
        , pointer
        , px
        , rem
        , solid
        , zero
        )
import Html.Styled as Html exposing (Attribute, Html, button, styled)
import Resources.Colors as Colors


type Variant
    = Primary
    | Secondary
    | Tertiary


type Button msg
    = Button
        { variant : Variant
        , attributes : List (Attribute msg)
        , children : List (Html msg)
        }


new : Button msg
new =
    Button
        { variant = Primary
        , children = []
        , attributes = []
        }


withVariant : Variant -> Button msg -> Button msg
withVariant variant (Button options) =
    Button { options | variant = variant }


withAttributes : List (Attribute msg) -> Button msg -> Button msg
withAttributes attributes (Button options) =
    Button { options | attributes = attributes }


withChildren : List (Html msg) -> Button msg -> Button msg
withChildren children (Button options) =
    Button { options | children = children }


asHtml : Button msg -> Html msg
asHtml (Button options) =
    styled button (styles options.variant) options.attributes options.children


base : List Style
base =
    [ fontSize (rem 1)
    , padding2 (em 0.5) (em 2)
    , borderRadius (em 2)
    , cursor pointer
    ]


primary : List Style
primary =
    [ backgroundColor Colors.blueDeep
    , color Colors.white
    , border zero
    , hover
        [ backgroundColor Colors.blueNordea
        ]
    ]


secondary : List Style
secondary =
    [ backgroundColor Colors.white
    , color Colors.blueDeep
    , border3 (px 2) solid Colors.blueDeep
    , hover
        [ backgroundColor Colors.blueHaas
        ]
    ]


tertiary : List Style
tertiary =
    [ backgroundColor Colors.transparent
    , color Colors.blueDeep
    , border zero
    , hover
        [ color Colors.blueNordea
        ]
    ]


styles : Variant -> List Style
styles variant =
    base
        ++ (case variant of
                Primary ->
                    primary

                Secondary ->
                    secondary

                Tertiary ->
                    tertiary
           )
