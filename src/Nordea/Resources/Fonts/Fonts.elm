module Nordea.Resources.Fonts.Fonts exposing (fromSize)

import Css exposing (Style)


fromSize : Float -> Style
fromSize size =
    let
        fontFamily =
            if size <= 1.375 then
                "Nordea Sans Small"

            else
                "Nordea Sans Large"
    in
    Css.batch
        [ Css.fontFamilies [ fontFamily, "sans-serif" ]
        , Css.fontSize (Css.rem size)
        ]
