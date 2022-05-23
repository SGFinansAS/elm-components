module Stories.Colors exposing (stories)

import Css
    exposing
        ( Color
        , backgroundColor
        , border3
        , borderRadius
        , color
        , column
        , displayFlex
        , flexDirection
        , height
        , marginBottom
        , padding4
        , rem
        , row
        , solid
        , width
        )
import Html.Styled as Html
import Html.Styled.Attributes exposing (css)
import Nordea.Components.Text as Text
import Nordea.Resources.Colors as Colors exposing (blueCloud)
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI a b {}
stories =
    let
        colorGroupHeader headerText =
            Text.bodyTextHeavy |> Text.view [ css [ marginBottom (rem 1) ] ] [ Html.text headerText ]

        colorElement { color, colorName, colorCode } =
            let
                colorBox =
                    Html.div [ css [ height (rem 10), backgroundColor color, borderRadius (rem 0.5) ] ] []

                colorInfo =
                    Html.div
                        [ css
                            [ flexDirection column
                            , padding4 (rem 1.0) (rem 1.0) (rem 1.0) (rem 1.0)
                            , border3 (rem 0.1) solid Colors.lightGray
                            , borderRadius (rem 0.5)
                            ]
                        ]
                        [ Text.bodyTextHeavy |> Text.view [] [ Html.text colorName ]
                        , Text.textTinyLight |> Text.view [] [ Html.text colorCode ]
                        ]
            in
            Html.div [ css [ displayFlex, flexDirection column, width (rem 10), height (rem 14) ] ]
                [ colorBox
                , colorInfo
                ]

        colorsRow colors =
            Html.div [ css [ displayFlex, flexDirection row, Css.property "gap" "2rem", marginBottom (rem 1.125) ] ]
                (colors |> List.map colorElement)
    in
    styledStoriesOf
        "Colors"
        [ ( "Colors"
          , \_ ->
                Html.div [ css [ displayFlex, flexDirection column ] ]
                    [ colorGroupHeader "Primary colors"
                    , colorsRow primaryBlueColors
                    , colorsRow primaryDarkColors
                    , colorsRow primaryLightColors
                    , colorGroupHeader "System colors (UI)"
                    , colorsRow systemDarkColors
                    , colorsRow systemMainColors
                    ]
          , {}
          )
        ]


primaryBlueColors : List { color : Color, colorName : String, colorCode : String }
primaryBlueColors =
    [ { color = Colors.deepBlue, colorName = "Deep blue", colorCode = "#00005E" }
    , { color = Colors.nordeaBlue, colorName = "Nordea blue", colorCode = "##0000A0" }
    , { color = Colors.mediumBlue, colorName = "Medium blue", colorCode = "#83B8ED" }
    , { color = Colors.haasBlue, colorName = "Haas blue", colorCode = "#83B8ED" }
    , { color = Colors.cloudBlue, colorName = "Cloud blue", colorCode = "#DCEDFF" }
    ]


primaryDarkColors : List { color : Color, colorName : String, colorCode : String }
primaryDarkColors =
    [ { color = Colors.black, colorName = "Black", colorCode = "#000000" }
    , { color = Colors.darkestGray, colorName = "Darkest gray", colorCode = "#151515" }
    , { color = Colors.eclipse, colorName = "Eclipse", colorCode = "#383838" }
    , { color = Colors.darkGray, colorName = "Dark gray", colorCode = "#5A575C" }
    , { color = Colors.nordeaGray, colorName = "Nordea gray", colorCode = "#8B8A8D" }
    ]


primaryLightColors : List { color : Color, colorName : String, colorCode : String }
primaryLightColors =
    [ { color = Colors.gray, colorName = "Gray", colorCode = "#E3E3E3" }
    , { color = Colors.mediumGray, colorName = "Medium gray", colorCode = "#C9C7C7" }
    , { color = Colors.lightGray, colorName = "Light gray", colorCode = "#E3E3E3" }
    , { color = Colors.coolGray, colorName = "Cool gray", colorCode = "#F1F2F4" }
    , { color = Colors.white, colorName = "White", colorCode = "#FFFFFF" }
    ]


systemDarkColors : List { color : Color, colorName : String, colorCode : String }
systemDarkColors =
    [ { color = Colors.darkRed, colorName = "Dark red", colorCode = "#E70404" }
    , { color = Colors.darkGreen, colorName = "Dark green", colorCode = "#0D8268" }
    , { color = Colors.darkYellow, colorName = "Dark yellow", colorCode = "#FFCF3D" }
    ]


systemMainColors : List { color : Color, colorName : String, colorCode : String }
systemMainColors =
    [ { color = Colors.red, colorName = "Red", colorCode = "#FC6161" }
    , { color = Colors.green, colorName = "Green", colorCode = "#40BFA3" }
    , { color = Colors.yellow, colorName = "Yellow", colorCode = "#FFE183" }
    ]
