module Stories.RadioButton exposing (stories)

import Css
import Html.Styled as Html exposing (text)
import Html.Styled.Attributes as Attrs
import Nordea.Components.RadioButton as RadioButton
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI a b {}
stories =
    styledStoriesOf
        "RadioButton"
        [ ( "Default"
          , \_ ->
                Html.div []
                    [ Html.styled Html.div
                        [ Css.margin2 (Css.rem 0.5) Css.zero ]
                        []
                        [ RadioButton.init False
                            |> RadioButton.view [ Attrs.name "radio" ] [ text "Answer 1" ]
                        ]
                    , Html.styled Html.div
                        [ Css.margin2 (Css.rem 0.5) Css.zero ]
                        []
                        [ RadioButton.init False
                            |> RadioButton.view [ Attrs.name "radio" ] [ text "Answer 2" ]
                        ]
                    ]
          , {}
          )
        , ( "Error"
          , \_ ->
                Html.div []
                    [ Html.styled Html.div
                        [ Css.margin2 (Css.rem 0.5) Css.zero ]
                        []
                        [ RadioButton.init False
                            |> RadioButton.withError True
                            |> RadioButton.view [ Attrs.name "radio" ] [ text "Answer 1" ]
                        ]
                    , Html.styled Html.div
                        [ Css.margin2 (Css.rem 0.5) Css.zero ]
                        []
                        [ RadioButton.init False
                            |> RadioButton.withError True
                            |> RadioButton.view [ Attrs.name "radio" ] [ text "Answer 2" ]
                        ]
                    ]
          , {}
          )
        ]
