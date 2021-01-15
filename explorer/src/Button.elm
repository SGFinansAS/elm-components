module Button exposing (stories)

import Components.Button as Button exposing (Variant(..))
import Html.Styled as Html exposing (Html)
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI a b {}
stories =
    styledStoriesOf
        "Button"
        [ ( "Primary", \_ -> button Primary, {} )
        , ( "Secondary", \_ -> button Secondary, {} )
        , ( "Tertiary", \_ -> button Tertiary, {} )
        ]


button : Variant -> Html msg
button variant =
    Button.new
        |> Button.withVariant variant
        |> Button.withChildren [ Html.text "Click me" ]
        |> Button.asHtml
