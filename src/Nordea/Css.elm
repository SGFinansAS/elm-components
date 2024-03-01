module Nordea.Css exposing
    ( alignContent
    , colorToString
    , colorVariable
    , columnGap
    , displayContents
    , displayGrid
    , gap
    , gap2
    , grid
    , gridArea
    , gridAutoColumns
    , gridAutoFlow
    , gridAutoRows
    , gridColumn
    , gridColumnEnd
    , gridColumnStart
    , gridRow
    , gridRowEnd
    , gridRowStart
    , gridTemplateAreas
    , gridTemplateColumns
    , gridTemplateRows
    , justifyItems
    , justifySelf
    , propertyWithColorVariable
    , propertyWithVariable
    , rowGap
    , smallInputHeight
    , standardInputHeight
    , variable
    )

import Css exposing (LengthOrNoneOrMinMaxDimension)


{-| Sets `display` to [`grid`](https://developer.mozilla.org/en-US/docs/Web/CSS/grid).
-}
displayGrid : Css.Style
displayGrid =
    Css.property "display" "grid"


{-| Sets [`display`](https://developer.mozilla.org/en-US/docs/Web/CSS/display) to `contents`.

Causes an element's children to appear as if they were direct children of the element's parent, ignoring the element itself. This can be useful when a wrapper element should be ignored when using CSS grid or similar layout techniques.

-}
displayContents : Css.Style
displayContents =
    Css.property "display" "contents"


{-| Sets the [`grid`](https://developer.mozilla.org/en-US/docs/Web/CSS/grid) shorthand.
-}
grid : String -> Css.Style
grid shorthand =
    Css.property "grid" shorthand


{-| Sets [`grid-area`](https://developer.mozilla.org/en-US/docs/Web/CSS/grid-area).
-}
gridArea : String -> Css.Style
gridArea customIdent =
    Css.property "grid-area" customIdent


{-| Sets [`grid-auto-flow`](https://developer.mozilla.org/en-US/docs/Web/CSS/grid-auto-flow).
-}
gridAutoFlow : String -> Css.Style
gridAutoFlow flow =
    Css.property "grid-auto-flow" flow


{-| Sets [`grid-auto-columns`](https://developer.mozilla.org/en-US/docs/Web/CSS/grid-auto-columns).
-}
gridAutoColumns : String -> Css.Style
gridAutoColumns columnSizes =
    Css.property "grid-auto-columns" columnSizes


{-| Sets [`grid-auto-rows`](https://developer.mozilla.org/en-US/docs/Web/CSS/grid-auto-rows).
-}
gridAutoRows : String -> Css.Style
gridAutoRows rowSizes =
    Css.property "grid-auto-rows" rowSizes


{-| Sets [`grid-column`](https://developer.mozilla.org/en-US/docs/Web/CSS/grid-column).
-}
gridColumn : String -> Css.Style
gridColumn gridColumnLines =
    Css.property "grid-column" gridColumnLines


{-| Sets [`grid-column-start`](https://developer.mozilla.org/en-US/docs/Web/CSS/grid-column-start).
-}
gridColumnStart : String -> Css.Style
gridColumnStart gridColumnLine =
    Css.property "grid-column-start" gridColumnLine


{-| Sets [`grid-column-end`](https://developer.mozilla.org/en-US/docs/Web/CSS/grid-column-end).
-}
gridColumnEnd : String -> Css.Style
gridColumnEnd gridColumnLine =
    Css.property "grid-column-end" gridColumnLine


{-| Sets [`grid-row`](https://developer.mozilla.org/en-US/docs/Web/CSS/grid-row).
-}
gridRow : String -> Css.Style
gridRow gridRowLines =
    Css.property "grid-row" gridRowLines


{-| Sets [`grid-row-start`](https://developer.mozilla.org/en-US/docs/Web/CSS/grid-row-start).
-}
gridRowStart : String -> Css.Style
gridRowStart gridRowLine =
    Css.property "grid-row-start" gridRowLine


{-| Sets [`grid-row-end`](https://developer.mozilla.org/en-US/docs/Web/CSS/grid-row-end).
-}
gridRowEnd : String -> Css.Style
gridRowEnd gridRowLine =
    Css.property "grid-row-end" gridRowLine


{-| Sets [`grid-template-areas`](https://developer.mozilla.org/en-US/docs/Web/CSS/grid-template-areas).

For instance,

    gridTemplateAreas ["header header", "nav main"]`

Becomes

    grid-template-areas:
        "header header"
        "nav    main";

-}
gridTemplateAreas : List String -> Css.Style
gridTemplateAreas areas =
    Css.property "grid-template-areas" (List.map (\row -> "\"" ++ row ++ "\"") areas |> String.join " ")


{-| Sets [`grid-template-columns`](https://developer.mozilla.org/en-US/docs/Web/CSS/grid-template-columns).
-}
gridTemplateColumns : String -> Css.Style
gridTemplateColumns columns =
    Css.property "grid-template-columns" columns


{-| Sets [`grid-template-rows`](https://developer.mozilla.org/en-US/docs/Web/CSS/grid-template-rows).
-}
gridTemplateRows : String -> Css.Style
gridTemplateRows rows =
    Css.property "grid-template-rows" rows


{-| Sets [`gap`](https://developer.mozilla.org/en-US/docs/Web/CSS/gap).
-}
gap : LengthOrNoneOrMinMaxDimension compatible -> Css.Style
gap argA =
    Css.property "gap" argA.value


{-| Sets [`gap`](https://developer.mozilla.org/en-US/docs/Web/CSS/gap).
-}
gap2 : LengthOrNoneOrMinMaxDimension compatible -> LengthOrNoneOrMinMaxDimension compatible2 -> Css.Style
gap2 argA argB =
    Css.property "gap" (argA.value ++ " " ++ argB.value)


{-| Sets [`column-gap`](https://developer.mozilla.org/en-US/docs/Web/CSS/column-gap).
-}
columnGap : LengthOrNoneOrMinMaxDimension compatible -> Css.Style
columnGap argA =
    Css.property "column-gap" argA.value


{-| Sets [`row-gap`](https://developer.mozilla.org/en-US/docs/Web/CSS/row-gap).
-}
rowGap : LengthOrNoneOrMinMaxDimension compatible -> Css.Style
rowGap argA =
    Css.property "row-gap" argA.value


{-| Sets [`align-content`](https://developer.mozilla.org/en-US/docs/Web/CSS/align-content).
-}
alignContent : String -> Css.Style
alignContent alignment =
    Css.property "align-content" alignment


{-| Sets [`justify-self`](https://developer.mozilla.org/en-US/docs/Web/CSS/justify-self).
-}
justifySelf : String -> Css.Style
justifySelf alignment =
    Css.property "justifySelf" alignment


{-| Sets [`justify-items`](https://developer.mozilla.org/en-US/docs/Web/CSS/justify-items).
-}
justifyItems : String -> Css.Style
justifyItems alignment =
    Css.property "justifyItems" alignment


variable : String -> String -> String
variable variableName fallback =
    "var(" ++ variableName ++ "," ++ fallback ++ ")"


colorVariable : String -> Css.Color -> String
colorVariable variableName fallbackColor =
    "var(" ++ variableName ++ "," ++ colorToString fallbackColor ++ ")"


propertyWithVariable : String -> String -> String -> Css.Style
propertyWithVariable property variableName fallback =
    Css.property property (variable variableName fallback)


propertyWithColorVariable : String -> String -> Css.Color -> Css.Style
propertyWithColorVariable property variableName fallbackColor =
    Css.property property (colorVariable variableName fallbackColor)


colorToString : Css.Color -> String
colorToString color =
    [ String.fromInt color.red
    , String.fromInt color.green
    , String.fromInt color.blue
    , String.fromFloat color.alpha
    ]
        |> String.join ","
        |> (\s -> "rgba(" ++ s ++ ")")


standardInputHeight =
    Css.rem 3


smallInputHeight =
    Css.rem 2.5
