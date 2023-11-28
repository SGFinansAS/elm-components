module Nordea.Components.Tabs exposing
    ( Tab
    , init
    , view
    , withHtmlTag
    , withIsActive
    )

import Css
    exposing
        ( Style
        , backgroundColor
        , borderBottom3
        , borderStyle
        , center
        , cursor
        , fontWeight
        , int
        , none
        , padding2
        , pointer
        , rem
        , solid
        , textAlign
        , textDecoration
        , transparent
        )
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes exposing (css, tabindex)
import Nordea.Html as Html exposing (styleIf)
import Nordea.Resources.Colors as Color
import Nordea.Themes as Themes


type alias Config msg =
    { isActive : Bool
    , htmlTag : List (Attribute msg) -> List (Html msg) -> Html msg
    }


type Tab msg
    = Tab (Config msg)


init : Tab msg
init =
    Tab
        { isActive = False
        , htmlTag = Html.a
        }


view : List (Attribute msg) -> List (Html msg) -> Tab msg -> Html msg
view attrs tab (Tab config) =
    config.htmlTag
        (css
            [ commonTabStyle config.isActive ]
            :: tabindex 0
            :: attrs
        )
        tab


withIsActive : Bool -> Tab msg -> Tab msg
withIsActive isActive (Tab config) =
    Tab { config | isActive = isActive }


withHtmlTag : (List (Attribute msg) -> List (Html msg) -> Html msg) -> Tab msg -> Tab msg
withHtmlTag htmlTag (Tab config) =
    Tab { config | htmlTag = htmlTag }


commonTabStyle : Bool -> Style
commonTabStyle isActive =
    Css.batch
        [ padding2 (rem 0.75) (rem 1.25)
        , textAlign center
        , cursor pointer
        , borderStyle none
        , borderBottom3 (rem 0.25) solid Color.transparent
        , Css.hover [ borderBottom3 (rem 0.25) solid Color.lightGray ] |> styleIf (not isActive)
        , textDecoration none
        , Themes.color Color.deepBlue
        , backgroundColor transparent
        , Themes.borderColor Color.mediumBlue |> styleIf isActive
        , fontWeight (int 500) |> styleIf isActive
        ]
