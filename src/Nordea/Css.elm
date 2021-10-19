module Nordea.Css exposing
    ( colorVariable
    , propertyWithColorVariable
    , propertyWithVariable
    , variable
    )

import Css


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