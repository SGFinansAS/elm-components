module Stories.Hamburger exposing (stories)

import Config exposing (Config, Msg(..))
import Css exposing (backgroundColor, padding, rem)
import Html.Styled exposing (div)
import Html.Styled.Attributes exposing (css)
import Nordea.Components.Hamburger as Hamburger
import Nordea.Resources.Colors as Colors
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI Config Msg {}
stories =
    styledStoriesOf
        "Hamburger"
        [ ( "Simple"
          , \model ->
                div [ css [ backgroundColor Colors.blueDeep, padding (rem 2) ] ]
                    [ Hamburger.init .no model.customModel.hamburgerIsActive ToggleHamburger
                        |> Hamburger.view
                    ]
          , {}
          )
        , ( "With Text"
          , \model ->
                div [ css [ backgroundColor Colors.blueDeep, padding (rem 2) ] ]
                    [ Hamburger.init .no model.customModel.hamburgerIsActive ToggleHamburger
                        |> Hamburger.withText
                        |> Hamburger.view
                    ]
          , {}
          )
        , ( "With custom color"
          , \model ->
                div [ css [ backgroundColor Colors.blueDeep, padding (rem 2) ] ]
                    [ Hamburger.init .no model.customModel.hamburgerIsActive ToggleHamburger
                        |> Hamburger.withText
                        |> Hamburger.withCustomColor Colors.greenDark
                        |> Hamburger.view
                    ]
          , {}
          )
        ]
