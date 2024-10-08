module Nordea.Components.AccordionTableHeader exposing (init, view, withSmallSize)

import Css exposing (backgroundColor, borderRadius, padding2, rem)
import Html.Styled as Html exposing (Html, h3)
import Nordea.Components.Text as Text
import Nordea.Css exposing (gridColumn)
import Nordea.Resources.Colors as Colors
import Nordea.Themes exposing (color)
import Svg.Styled.Attributes exposing (css)


type alias Config =
    { small : Bool
    }


init : Config
init =
    { small = False
    }


view : List Css.Style -> List (Html.Attribute msg) -> List (Html msg) -> Config -> Html msg
view styles attrs content config =
    let
        ( horizontalPadding, verticalPadding ) =
            if config.small then
                ( 0.75, 0.5 )

            else
                ( 1, 0.75 )

        combinedStyles =
            css
                ([ gridColumn "1 / -1"
                 , color Colors.black
                 , padding2 (rem verticalPadding) (rem horizontalPadding)
                 , backgroundColor Colors.cloudBlue
                 , borderRadius (rem 0.5)
                 ]
                    ++ styles
                )
    in
    Text.textTinyHeavy
        |> Text.withHtmlTag h3
        |> Text.view (combinedStyles :: attrs) content


withSmallSize : Config -> Config
withSmallSize config =
    { config | small = True }
