module Nordea.Components.InfoBanner exposing (Appearance(..), Config(..), bodyText, cross, view)

import Css
    exposing
        ( alignItems
        , auto
        , backgroundColor
        , border
        , borderRadius
        , displayFlex
        , flexDirection
        , flexShrink
        , flexStart
        , marginLeft
        , marginRight
        , num
        , padding
        , rem
        , row
        , width
        )
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes exposing (css)
import Nordea.Components.Checkbox exposing (Appearance)
import Nordea.Components.Text as Text
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Icons as Icons
import Nordea.Themes as Themes


type Appearance
    = Warning
    | Info


type Config
    = Appearance Appearance


view : List Config -> List (Attribute msg) -> List (Html msg) -> Html msg
view config attrs children =
    let
        appearance =
            config
                |> List.filterMap
                    (\attr ->
                        case attr of
                            Appearance app ->
                                Just app
                    )
                |> List.head
                |> Maybe.withDefault Info

        backgroundColor_ =
            case appearance of
                Info ->
                    Themes.backgroundColor Themes.SecondaryColor Colors.cloudBlue

                Warning ->
                    backgroundColor Colors.yellow
    in
    Html.div
        (css
            [ displayFlex
            , flexDirection row
            , padding (rem 0.75)
            , borderRadius (rem 0.5)
            , backgroundColor_
            , alignItems flexStart
            ]
            :: attrs
        )
        (Icons.info [ css [ width (rem 1.5), marginRight (rem 0.5), flexShrink (num 0) ] ] :: children)


bodyText : List (Attribute msg) -> List (Html msg) -> Html msg
bodyText attributes children =
    Text.bodyTextSmall
        |> Text.view attributes children


cross : List (Attribute msg) -> Html msg
cross attrs =
    Html.button (css [ Css.property "appearance" "none", marginLeft auto, border (rem 0), flexShrink (num 0), padding (rem 0.5) ] :: attrs)
        [ Icons.close [ css [ width (rem 1.5) ] ] ]
