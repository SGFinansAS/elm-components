module Stories.InfoBanner exposing (stories)

import Html.Styled as Html
import Nordea.Components.InfoBanner as InfoBanner exposing (Appearance(..), Config(..))
import Nordea.Html
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI a b {}
stories =
    styledStoriesOf
        "InfoBanner"
        [ ( "Regular InfoBanner"
          , \_ ->
                InfoBanner.view [] [] [ InfoBanner.bodyText [] [ Html.text "This is important info." ] ]
          , {}
          )
        , ( "InfoBanner that is a warning"
          , \_ ->
                InfoBanner.view [ Appearance Warning ] [] [ InfoBanner.bodyText [] [ Html.text "This is an important warning." ] ]
          , {}
          )
        , ( "InfoBanner with cross"
          , \_ ->
                InfoBanner.view [] [] [ InfoBanner.bodyText [] [ Html.text "This is a closeable banner." ], InfoBanner.cross [] ]
          , {}
          )
        , ( "InfoBanner multiline with cross"
          , \_ ->
                InfoBanner.view []
                    []
                    [ InfoBanner.bodyText [] [ Html.text "This is a closeable banner.This is a closeable banner.This is a closeable banner.This is a closeable banner.This is a closeable banner.This is a closeable banner.This is a closeable banner.This is a closeable banner.This is a closeable banner.This is a closeable banner.This is a closeable banner.This is a closeable banner.This is a closeable banner.This is a closeable banner.This is a closeable banner.This is a closeable banner.This is a closeable banner.This is a closeable banner.This is a closeable banner.This is a closeable banner.This is a closeable banner.This is a closeable banner.This is a closeable banner.This is a closeable banner.This is a closeable banner.This is a closeable banner.This is a closeable banner." ]
                    , InfoBanner.cross []
                    ]
          , {}
          )
        ]
