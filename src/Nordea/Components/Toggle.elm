module Nordea.Components.Toggle exposing (Toggle, init, view, withHtmlTag, withInputAttrs, withIsChecked)

import Css
    exposing
        ( absolute
        , after
        , alignItems
        , backgroundColor
        , block
        , border3
        , borderRadius
        , center
        , cursor
        , display
        , displayFlex
        , height
        , hex
        , left
        , marginRight
        , opacity
        , pct
        , pointer
        , position
        , property
        , pseudoClass
        , relative
        , rem
        , solid
        , top
        , transform
        , translateY
        , width
        , zero
        )
import Css.Transitions as Transitions
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attrs exposing (class, css, name, type_)
import Html.Styled.Events as Events
import Maybe.Extra as Maybe
import Nordea.Html as Html
import Nordea.Resources.Colors as Colors
import Nordea.Themes as Themes


type Toggle msg
    = Toggle (ToggleProperties msg)


type alias HtmlTag msg =
    List (Attribute msg) -> List (Html msg) -> Html msg


type alias ToggleProperties msg =
    { name : String
    , onCheck : Bool -> msg
    , isChecked : Bool
    , customHtmlTag : Maybe (HtmlTag msg)
    , inputAttrs : List (Attribute msg)
    }


init : String -> (Bool -> msg) -> Toggle msg
init name onCheck =
    { name = name
    , onCheck = onCheck
    , isChecked = False
    , customHtmlTag = Nothing
    , inputAttrs = []
    }
        |> Toggle


view : List (Attribute msg) -> List (Html msg) -> Toggle msg -> Html msg
view attrs content (Toggle config) =
    let
        isDisabled =
            List.member (Attrs.disabled True) attrs

        onCheckValue =
            not config.isChecked
    in
    (config.customHtmlTag |> Maybe.withDefault labelTag)
        (css [ position relative ] :: attrs)
        ([ Html.input
            ([ type_ "checkBox"
             , name config.name
             , Attrs.checked config.isChecked
             , Attrs.disabled isDisabled
             , Events.onCheck config.onCheck
             , css
                [ opacity zero
                , height zero
                , width zero
                , pseudoClass "checked ~ .nfe-toggle"
                    [ Themes.backgroundColor Colors.deepBlue
                    , Themes.borderColor Colors.deepBlue
                    , after [ left (rem 1.125) ]
                    ]
                , pseudoClass "disabled ~ .nfe-toggle"
                    [ backgroundColor Colors.lightGray
                    , border3 (rem 0.125) solid Colors.lightGray
                    , after [ backgroundColor Colors.mediumGray ]
                    ]
                ]
             ]
                ++ config.inputAttrs
            )
            []
         , Html.span
            [ class "nfe-toggle"

            -- If the container isn't a label, we need to catch the click here or it gets lost.
            , Events.onClick (config.onCheck onCheckValue) |> Html.attrIf (Maybe.isJust config.customHtmlTag)
            , Attrs.attribute "aria-hidden" "true"
            , css
                [ height (rem 1.5)
                , width (rem 2.625)
                , backgroundColor Colors.mediumGray
                , border3 (rem 0.125) solid Colors.mediumGray
                , borderRadius (rem 1)
                , position relative
                , marginRight (rem 0.5)
                , after
                    [ display block
                    , property "content" "''"
                    , position absolute
                    , top (pct 50)
                    , left (rem 0)
                    , transform (translateY (pct -50))
                    , width (rem 1.25)
                    , height (rem 1.25)
                    , backgroundColor (hex "#FFFFFF")
                    , borderRadius (pct 50)
                    , Css.boxShadow4 (rem 0) (rem 0.0625) (rem 0.0625) (Colors.withAlpha 0.5 Colors.black)
                    , Transitions.transition [ Transitions.left3 300 0 Transitions.ease ]
                    ]
                ]
            ]
            []
         ]
            ++ content
        )


withIsChecked : Bool -> Toggle msg -> Toggle msg
withIsChecked isChecked (Toggle config) =
    Toggle { config | isChecked = isChecked }


withHtmlTag : HtmlTag msg -> Toggle msg -> Toggle msg
withHtmlTag container (Toggle config) =
    Toggle { config | customHtmlTag = Just container }


withInputAttrs : List (Attribute msg) -> Toggle msg -> Toggle msg
withInputAttrs inputAttrs (Toggle config) =
    Toggle { config | inputAttrs = inputAttrs }


labelTag : List (Attribute msg) -> List (Html msg) -> Html msg
labelTag attrs =
    Html.label
        (css
            [ displayFlex
            , alignItems center
            , cursor pointer
            ]
            :: attrs
        )
