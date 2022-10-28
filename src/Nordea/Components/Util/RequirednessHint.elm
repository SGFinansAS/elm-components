module Nordea.Components.Util.RequirednessHint exposing (RequirednessHint(..), view)

import Css exposing (color)
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes exposing (css)
import Nordea.Components.Text as Text
import Nordea.Resources.Colors as Colors
import Nordea.Resources.I18N exposing (Translation)


type RequirednessHint
    = Mandatory (Translation -> String)
    | Optional (Translation -> String)
    | Custom String


view : RequirednessHint -> Html msg
view requirednessHint =
    let
        toI18NString =
            case requirednessHint of
                Mandatory translate ->
                    translate strings.mandatory

                Optional translate ->
                    translate strings.optional

                Custom string ->
                    string
    in
    Text.textSmallLight
        |> Text.view
            [ css [ color Colors.grayDark ] ]
            [ Html.text toI18NString ]



-- TRANSLATIONS


strings : { mandatory : Translation, optional : Translation }
strings =
    { mandatory =
        { no = "Påkrevd"
        , se = "Krävs"
        , dk = "Påkrævet"
        , en = "Required"
        }
    , optional =
        { no = "Valgfritt"
        , se = "Valfritt"
        , dk = "Valgfrit"
        , en = "Optional"
        }
    }
