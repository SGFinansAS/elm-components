module Stories.TextArea exposing (stories)

import Html.Styled.Attributes exposing (disabled)
import Nordea.Components.TextArea as TextArea
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI a b {}
stories =
    styledStoriesOf
        "TextArea"
        [ ( "Default"
          , \_ ->
                TextArea.init "Text"
                    |> TextArea.view []
          , {}
          )
        , ( "Placeholder"
          , \_ ->
                TextArea.init ""
                    |> TextArea.withPlaceholder "Text"
                    |> TextArea.view [ ]
          , {}
          )
        , ( "Filled"
          , \_ ->
                TextArea.init loremIpsumText
                    |> TextArea.view []
          , {}
          )
        , ( "Error"
          , \_ ->
                TextArea.init "Text"
                    |> TextArea.withError True
                    |> TextArea.view []
          , {}
          )
        , ( "Disabled"
          , \_ ->
                TextArea.init "Text"
                    |> TextArea.view [ disabled True ]
          , {}
          )
        ]

loremIpsumText =
  """Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur scelerisque augue sed sem interdum accumsan. Aenean tristique fermentum est ac varius. Sed eget fringilla lectus. Aliquam molestie in nisi in blandit. Mauris elementum vestibulum aliquam. Quisque sit amet est consectetur justo venenatis euismod quis vitae nisl. Nam malesuada mauris in maximus finibus. Curabitur vitae ultricies nulla. Proin leo turpis, pulvinar vel ultrices et, viverra vitae risus. Mauris facilisis nibh erat, at luctus ipsum blandit non. Maecenas semper purus quis libero consequat, vel dictum lectus aliquet. Quisque lobortis urna ac justo finibus, eu efficitur est posuere. Praesent finibus non libero a imperdiet. Sed scelerisque, est pellentesque placerat rutrum, nisi augue tristique justo, et ultricies sem tellus in metus. Mauris eleifend bibendum odio eu fermentum.

Cras et ante at enim efficitur egestas. In hac habitasse platea dictumst. Nulla sagittis ac quam et varius. Etiam eu nibh augue. Quisque elementum velit erat. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec vestibulum turpis scelerisque dictum imperdiet. Maecenas accumsan consectetur diam sed tristique. Sed vitae maximus urna. Cras sapien elit, hendrerit et felis sed, gravida faucibus dolor. Sed sagittis, ipsum in interdum molestie, leo ipsum convallis nunc, ac efficitur odio ante at lorem. Aliquam maximus, magna id scelerisque maximus, ligula orci imperdiet mi, non aliquet lectus elit at arcu.
"""
