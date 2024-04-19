module Nordea.Components.MultiSelectDropdown exposing
    ( MultiSelectDropdown
    , init
    , view
    , withHasFocus
    , withHintText
    , withLabel
    , withOptions
    , withPlaceholder
    , withRequirednessHint
    )

import Css
    exposing
        ( absolute
        , alignItems
        , backgroundColor
        , border3
        , borderBottomLeftRadius
        , borderBottomRightRadius
        , borderBox
        , borderRadius4
        , boxSizing
        , center
        , column
        , display
        , displayFlex
        , flexDirection
        , hover
        , int
        , justifyContent
        , left
        , listStyle
        , margin
        , maxHeight
        , none
        , overflowY
        , padding
        , padding4
        , pct
        , position
        , relative
        , rem
        , right
        , scroll
        , solid
        , spaceBetween
        , top
        , width
        , zIndex
        )
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes exposing (css, tabindex)
import Html.Styled.Events as Events
import Json.Decode as Decode
import Nordea.Components.Checkbox as Checkbox
import Nordea.Components.Label as Label exposing (RequirednessHint(..))
import Nordea.Components.OnClickOutsideSupport as OnClickOutsideSupport
import Nordea.Html as Html
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Icons as Icon
import Nordea.Themes as Themes


type alias MultiSelectDropdown msg =
    { label : String
    , placeholder : String
    , hint : Maybe String
    , options : List (Option msg)
    , onFocus : Bool -> msg
    , hasFocus : Bool
    , requirednessHint : Maybe RequirednessHint
    }


type alias Option msg =
    { name : String
    , label : String
    , isChecked : Bool
    , onCheck : Bool -> msg
    }


init : { onFocus : Bool -> msg } -> MultiSelectDropdown msg
init { onFocus } =
    { label = ""
    , placeholder = ""
    , hint = Nothing
    , options = []
    , onFocus = onFocus
    , hasFocus = True
    , requirednessHint = Nothing
    }


view : List (Attribute msg) -> MultiSelectDropdown msg -> Html msg
view attrs dropdown =
    let
        viewSelectItems =
            let
                viewOption option =
                    Html.li
                        []
                        [ Checkbox.init option.name (Html.text option.label) option.onCheck
                            |> Checkbox.withIsChecked option.isChecked
                            |> Checkbox.withAppearance Checkbox.Simple
                            |> Checkbox.view
                                [ css
                                    [ width (pct 100)
                                    , hover [ backgroundColor Colors.coolGray ]
                                    , padding (rem 0.5)
                                    ]
                                ]
                        ]
            in
            Html.ul
                [ css
                    [ position absolute
                    , top (pct 100)
                    , left (rem -0.0625)
                    , right (rem -0.0625)
                    , zIndex (int 1)
                    , overflowY scroll
                    , maxHeight (rem 16.75)
                    , listStyle none
                    , margin (rem 0)
                    , padding (rem 0)
                    , if dropdown.hasFocus then
                        displayFlex

                      else
                        display none
                    , flexDirection column
                    , backgroundColor Colors.white
                    , border3 (rem 0.0625) solid Colors.mediumGray
                    , Themes.borderColor Colors.nordeaBlue
                    , borderBottomLeftRadius (rem 0.25)
                    , borderBottomRightRadius (rem 0.25)
                    , boxSizing borderBox
                    ]
                ]
                (dropdown.options |> List.map viewOption)
    in
    Label.init
        dropdown.label
        Label.GroupLabel
        |> Label.withRequirednessHint dropdown.requirednessHint
        |> Label.withHintText dropdown.hint
        |> Label.view
            ([ Events.on "build" (Decode.succeed (dropdown.onFocus False))
             , Events.onClick (dropdown.onFocus (not dropdown.hasFocus))
             , tabindex 0
             ]
                ++ attrs
            )
            [ OnClickOutsideSupport.view { isActive = dropdown.hasFocus }
            , Html.div
                [ css
                    [ width (pct 100)
                    , displayFlex
                    , alignItems center
                    , justifyContent spaceBetween
                    , position relative
                    , backgroundColor Colors.white
                    , padding4 (rem 0.25) (rem 0.25) (rem 0.25) (rem 0.75)
                    , border3 (rem 0.0625) solid Colors.mediumGray
                    , if dropdown.hasFocus then
                        Css.batch
                            [ borderRadius4 (rem 0.25) (rem 0.25) (rem 0.0) (rem 0.0)
                            , Themes.borderColor Colors.nordeaBlue
                            ]

                      else
                        borderRadius4 (rem 0.25) (rem 0.25) (rem 0.25) (rem 0.25)
                    ]
                ]
                [ Html.text dropdown.placeholder
                , Icon.chevronDownFilled []
                , viewSelectItems
                ]
            ]


withLabel : String -> MultiSelectDropdown msg -> MultiSelectDropdown msg
withLabel label dropdown =
    { dropdown | label = label }


withPlaceholder : String -> MultiSelectDropdown msg -> MultiSelectDropdown msg
withPlaceholder placeholder dropdown =
    { dropdown | placeholder = placeholder }


withOptions : List (Option msg) -> MultiSelectDropdown msg -> MultiSelectDropdown msg
withOptions options dropdown =
    { dropdown | options = options }


withHintText : Maybe String -> MultiSelectDropdown msg -> MultiSelectDropdown msg
withHintText hint dropdown =
    { dropdown | hint = hint }


withRequirednessHint : Maybe RequirednessHint -> MultiSelectDropdown msg -> MultiSelectDropdown msg
withRequirednessHint requirednessHint dropdown =
    { dropdown | requirednessHint = requirednessHint }


withHasFocus : Bool -> MultiSelectDropdown msg -> MultiSelectDropdown msg
withHasFocus hasFocus dropdown =
    { dropdown | hasFocus = hasFocus }
