module Stories.InlineLink exposing (stories)

import Css exposing (hover, marginBottom, rem, visited)
import Css.Global exposing (children, everything)
import Html.Styled as Html exposing (div, text)
import Html.Styled.Attributes exposing (css, href)
import Nordea.Components.Button as ButtonVariant
import Nordea.Components.InlineLink as InlineLink
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Icons as Icons
import Nordea.Themes as Themes
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI a b {}
stories =
    styledStoriesOf
        "InlineLink"
        [ ( "Default"
          , \_ ->
                Html.div [ css [ children [ everything [ marginBottom (rem 1) ] ] ] ]
                    [ div []
                        [ text "This is an "
                        , InlineLink.default
                            |> InlineLink.withStyles
                                [ visited [ Themes.color Themes.PrimaryColorLight Colors.blueNordea ]
                                , hover [ Css.color Colors.blueDeep ]
                                ]
                            |> InlineLink.view [ href "/#Default/InlineLink/Default" ] "unvisited"
                        , text " inline link."
                        ]
                    , div []
                        [ text "This is a "
                        , InlineLink.default
                            |> InlineLink.withStyles [ visited [ Themes.color Themes.PrimaryColorLight Colors.purple ] ]
                            |> InlineLink.view [ href "/#Default/InlineLink/Default" ] "visited"
                        , text " inline link."
                        ]
                    , div []
                        [ text "This is a "
                        , InlineLink.default
                            |> InlineLink.withDisabled
                            |> InlineLink.view [ href "/#Default/InlineLink/Default" ] "disabled"
                        , text " inline link."
                        ]
                    ]
          , {}
          )
        ]
