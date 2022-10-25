module Nordea.Components.Hamburger exposing
    ( Config
    , Hamburger
    , init
    , view
    , withCustomColor
    , withText
    )

import Css
    exposing
        ( Color
        , backgroundColor
        , block
        , boxShadow
        , color
        , deg
        , display
        , focus
        , fontSize
        , fontWeight
        , height
        , hover
        , int
        , lastChild
        , marginBottom
        , marginLeft
        , none
        , normal
        , opacity
        , paddingLeft
        , paddingRight
        , rem
        , rotate
        , scale2
        , textDecoration
        , transforms
        , translate2
        , underline
        , width
        )
import Css.Transitions as Transitions
import Html.Styled exposing (Html, span, styled, text)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events exposing (onClick)
import Nordea.Components.Button as Button
import Nordea.Html as Layout exposing (showIf)
import Nordea.Resources.Colors as Colors
import Nordea.Resources.I18N exposing (Translation)
import Nordea.Themes as Themes



-- CONFIG


type alias Config msg =
    { isActive : Bool
    , hasText : Bool
    , toggle : msg
    , translate : Translate
    , customColor : Maybe Color
    }


type alias Translate =
    Translation -> String


type Hamburger msg
    = Hamburger (Config msg)


init : Translate -> Bool -> msg -> Hamburger msg
init translate isActive toggle =
    Hamburger
        { isActive = isActive
        , hasText = False
        , toggle = toggle
        , translate = translate
        , customColor = Nothing
        }


withText : Hamburger msg -> Hamburger msg
withText (Hamburger config) =
    Hamburger { config | hasText = True }


withCustomColor : Color -> Hamburger msg -> Hamburger msg
withCustomColor color (Hamburger config) =
    Hamburger { config | customColor = Just color }



-- VIEW


view : Hamburger msg -> Html msg
view (Hamburger config) =
    let
        hamburgerLine attrs =
            styled span
                [ display block
                , width (rem 1.25)
                , height (rem 0.2)
                , case config.customColor of
                    Nothing ->
                        Themes.backgroundColor Themes.TextColorOnPrimaryColorBackground Colors.white

                    Just customColor ->
                        backgroundColor customColor
                , marginBottom (rem 0.3125)
                , lastChild [ marginBottom (rem 0) ]
                , Transitions.transition
                    [ Transitions.transformOrigin2 4 0
                    , Transitions.transform3 500 0 Transitions.easeInOut
                    , Transitions.background3 500 0 Transitions.easeInOut
                    , Transitions.opacity3 550 0 Transitions.ease
                    ]
                ]
                attrs
                []
    in
    Button.tertiary
        |> Button.view
            [ onClick config.toggle
            , css
                [ fontSize (rem 1.25) |> Css.important
                , paddingRight (rem 0) |> Css.important
                , paddingLeft (rem 0) |> Css.important
                , case config.customColor of
                    Nothing ->
                        Themes.color Themes.TextColorOnPrimaryColorBackground Colors.white |> Css.important

                    Just customColor ->
                        color customColor |> Css.important
                , fontWeight normal |> Css.important
                , hover [ textDecoration underline ]
                , focus [ boxShadow none |> Css.important ]
                ]
            ]
            (if config.isActive then
                [ showIf config.hasText (text (config.translate strings.close))
                , Layout.column [ css [ marginLeft (rem 0.5) ] ]
                    [ hamburgerLine
                        [ css [ transforms [ rotate (deg 45), translate2 (rem 0.3125) (rem 0.375) ] ] ]
                    , hamburgerLine
                        [ css [ transforms [ scale2 0.2 0.2 ], opacity (int 0) ] ]
                    , hamburgerLine
                        [ css [ transforms [ rotate (deg -45), translate2 (rem 0.375) (rem -0.375) ] ] ]
                    ]
                ]

             else
                [ showIf config.hasText (text (config.translate strings.menu))
                , Layout.column [ css [ marginLeft (rem 0.5) ] ]
                    [ hamburgerLine []
                    , hamburgerLine []
                    , hamburgerLine []
                    ]
                ]
            )


strings =
    { menu =
        { no = "Meny"
        , se = "Meny"
        , dk = "Menu"
        , en = "Menu"
        }
    , close =
        { no = "Lukk"
        , se = "Stäng"
        , dk = "Luk"
        , en = "Close"
        }
    }
