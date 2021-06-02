module Nordea.Resources.Fonts exposing (fromSize, globalStyle)

import Css exposing (FontStyle, Style)
import Css.Global as Css exposing (Snippet)
import Html.Styled exposing (Html)


fromSize : Float -> Style
fromSize size =
    let
        fontFamily =
            if size < 1.125 then
                "Nordea Sans Small"

            else
                "Nordea Sans Large"
    in
    Css.batch
        [ Css.fontFamilies [ fontFamily ]
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
            (String.concat [ "url('", description.path, "') format('woff')" ])
        , Css.fontWeight (Css.int description.weight)
        , Css.fontStyle description.style
        ]


globalStyle : String -> Html msg
globalStyle path =
    Css.global
        [ Css.body [ fromSize 1 ]
        , fontFace
            { name = "Nordea Sans Large"
            , path = String.concat [ path, "/", "NordeaSansLargeWeb-Light.woff" ]
            , weight = 300
            , style = Css.normal
            }
        , fontFace
            { name = "Nordea Sans Large"
            , path = String.concat [ path, "/", "NordeaSansLargeWeb-LightItalic.woff" ]
            , weight = 300
            , style = Css.italic
            }
        , fontFace
            { name = "Nordea Sans Large"
            , path = String.concat [ path, "/", "NordeaSansLargeWeb-Regular.woff" ]
            , weight = 400
            , style = Css.normal
            }
        , fontFace
            { name = "Nordea Sans Large"
            , path = String.concat [ path, "/", "NordeaSansLargeWeb-Italic.woff" ]
            , weight = 400
            , style = Css.italic
            }
        , fontFace
            { name = "Nordea Sans Large"
            , path = String.concat [ path, "/", "NordeaSansLargeWeb-Medium.woff" ]
            , weight = 500
            , style = Css.normal
            }
        , fontFace
            { name = "Nordea Sans Large"
            , path = String.concat [ path, "/", "NordeaSansLargeWeb-MediumItalic.woff" ]
            , weight = 500
            , style = Css.italic
            }
        , fontFace
            { name = "Nordea Sans Large"
            , path = String.concat [ path, "/", "NordeaSansLargeWeb-Bold.woff" ]
            , weight = 700
            , style = Css.normal
            }
        , fontFace
            { name = "Nordea Sans Large"
            , path = String.concat [ path, "/", "NordeaSansLargeWeb-BoldItalic.woff" ]
            , weight = 700
            , style = Css.italic
            }
        , fontFace
            { name = "Nordea Sans Large"
            , path = String.concat [ path, "/", "NordeaSansLargeWeb-Black.woff" ]
            , weight = 900
            , style = Css.normal
            }
        , fontFace
            { name = "Nordea Sans Small"
            , path = String.concat [ path, "/", "NordeaSansSmallWeb-Light.woff" ]
            , weight = 300
            , style = Css.normal
            }
        , fontFace
            { name = "Nordea Sans Small"
            , path = String.concat [ path, "/", "NordeaSansSmallWeb-LightItalic.woff" ]
            , weight = 300
            , style = Css.italic
            }
        , fontFace
            { name = "Nordea Sans Small"
            , path = String.concat [ path, "/", "NordeaSansSmallWeb-Regular.woff" ]
            , weight = 400
            , style = Css.normal
            }
        , fontFace
            { name = "Nordea Sans Small"
            , path = String.concat [ path, "/", "NordeaSansSmallWeb-Italic.woff" ]
            , weight = 400
            , style = Css.italic
            }
        , fontFace
            { name = "Nordea Sans Small"
            , path = String.concat [ path, "/", "NordeaSansSmallWeb-Medium.woff" ]
            , weight = 500
            , style = Css.normal
            }
        , fontFace
            { name = "Nordea Sans Small"
            , path = String.concat [ path, "/", "NordeaSansSmallWeb-MediumItalic.woff" ]
            , weight = 500
            , style = Css.italic
            }
        , fontFace
            { name = "Nordea Sans Small"
            , path = String.concat [ path, "/", "NordeaSansSmallWeb-Bold.woff" ]
            , weight = 700
            , style = Css.normal
            }
        , fontFace
            { name = "Nordea Sans Small"
            , path = String.concat [ path, "/", "NordeaSansSmallWeb-BoldItalic.woff" ]
            , weight = 700
            , style = Css.italic
            }
        , fontFace
            { name = "Nordea Sans Small"
            , path = String.concat [ path, "/", "NordeaSansSmallWeb-Black.woff" ]
            , weight = 900
            , style = Css.normal
            }
        ]
