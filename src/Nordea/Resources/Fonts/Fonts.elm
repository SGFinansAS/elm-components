module Nordea.Resources.Fonts.Fonts exposing (fromSize, globalStyle)

import Css exposing (FontStyle, Style)
import Css.Global as Css exposing (Snippet)
import Html.Styled exposing (Html)


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


type alias FontFace a =
    { name : String
    , path : String
    , weight : Int
    , style : FontStyle a
    }


fontFace : FontFace a -> Snippet
fontFace description =
    Css.selector "@font-face"
        [ Css.fontFamilies [ description.name ]
        , Css.property "src"
            (String.concat [ "url('", description.path, "') format('woff2')" ])
        , Css.fontWeight (Css.int description.weight)
        , Css.fontStyle description.style
        ]


globalStyle : String -> Html msg
globalStyle path =
    Css.global
        [ Css.body [ fromSize 1 ]
        , fontFace
            { name = "Nordea Sans Large"
            , path = String.concat [ path, "/", "NordeaSansLarge-Regular.woff2" ]
            , weight = 400
            , style = Css.normal
            }
        , fontFace
            { name = "Nordea Sans Large"
            , path = String.concat [ path, "/", "NordeaSansLarge-Medium.woff2" ]
            , weight = 500
            , style = Css.normal
            }
        , fontFace
            { name = "Nordea Sans Small"
            , path = String.concat [ path, "/", "NordeaSansSmall-Regular.woff2" ]
            , weight = 400
            , style = Css.normal
            }
        , fontFace
            { name = "Nordea Sans Small"
            , path = String.concat [ path, "/", "NordeaSansSmall-Italic.woff2" ]
            , weight = 400
            , style = Css.italic
            }
        , fontFace
            { name = "Nordea Sans Small"
            , path = String.concat [ path, "/", "NordeaSansSmall-Medium.woff2" ]
            , weight = 500
            , style = Css.normal
            }
        ]
