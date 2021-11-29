module Nordea.Html.Attributes exposing
    ( boolProperty
    , floatProperty
    , intProperty
    , stringProperty
    )

import Html.Styled exposing (Attribute)
import Html.Styled.Attributes as Attrs
import Json.Encode as Encode


stringProperty : String -> String -> Attribute msg
stringProperty key value =
    Attrs.property key (Encode.string value)


intProperty : String -> Int -> Attribute msg
intProperty key value =
    Attrs.property key (Encode.int value)


floatProperty : String -> Float -> Attribute msg
floatProperty key value =
    Attrs.property key (Encode.float value)


boolProperty : String -> Bool -> Attribute msg
boolProperty key value =
    Attrs.property key (Encode.bool value)
