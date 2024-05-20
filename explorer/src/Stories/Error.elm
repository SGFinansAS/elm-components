module Stories.Error exposing (..)

import Css exposing (marginBottom, rem, width)
import Html.Styled as Html
import Html.Styled.Attributes as Attributes exposing (css, href)
import Nordea.Components.Error as Error
import Nordea.Components.FlatLink as FlatLink
import Nordea.Components.Text as Text
import Nordea.Resources.Illustrations as Illustrations
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI a b {}
stories =
    styledStoriesOf
        "Error"
        [ ( "Internal server error"
          , \_ ->
                Error.internalServerError .no "contact.us@nordea.com"
                    |> Error.view [] []
          , {}
          )
        , ( "Internal server error with custom illustration"
          , \_ ->
                Error.internalServerError .no "contact.us@nordea.com"
                    |> Error.withCustomIllustration (Illustrations.plug [ css [ width (rem 12), marginBottom (rem 0.75) ] ])
                    |> Error.view [] []
          , {}
          )
        , ( "Page not found"
          , \_ ->
                Error.pageNotFound .no
                    |> Error.view [] []
          , {}
          )
        , ( "Page not found with custom text"
          , \_ ->
                Error.pageNotFound .no
                    |> Error.view []
                        [ Html.div
                            [ Attributes.css [ Css.displayFlex, Css.flexDirection Css.column, Css.alignItems Css.center ] ]
                            [ Text.textLight
                                |> Text.view [ Attributes.css [ Css.paddingRight (rem 0.25), Css.textAlign Css.center ] ]
                                    [ Html.text "This is a custom text for the page not found. Should include link to a page that works, e.g. the home or start page, and maybe also a way to "
                                    , FlatLink.default |> FlatLink.view [ href "mailto: contact.us@nordea.com", Attributes.css [ Css.display Css.inlineBlock ] ] [ Html.text "contact us." ]
                                    ]
                            ]
                        ]
          , {}
          )
        , ( "Page not found with custom illustration"
          , \_ ->
                Error.pageNotFound .no
                    |> Error.withCustomIllustration (Illustrations.plug [ css [ width (rem 12), marginBottom (rem 0.75) ] ])
                    |> Error.view [] []
          , {}
          )
        ]
