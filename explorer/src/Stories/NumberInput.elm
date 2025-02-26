module Stories.NumberInput exposing (stories)

import Html.Styled.Attributes exposing (disabled)
import Nordea.Components.NumberInput as NumberInput
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI a b {}
stories =
    styledStoriesOf
        "NumberInput"
        [ ( "Default"
          , \_ ->
                NumberInput.init "0"
                    |> NumberInput.view []
          , {}
          )
        , ( "Placeholder"
          , \_ ->
                NumberInput.init ""
                    |> NumberInput.withPlaceholder "Text"
                    |> NumberInput.view []
          , {}
          )
        , ( "Step"
          , \_ ->
                NumberInput.init ""
                    |> NumberInput.withPlaceholder "%"
                    |> NumberInput.withMin 0
                    |> NumberInput.withMax 100
                    |> NumberInput.withStep 0.1
                    |> NumberInput.view []
          , {}
          )
        , ( "Error"
          , \_ ->
                NumberInput.init "0"
                    |> NumberInput.withError True
                    |> NumberInput.view []
          , {}
          )
        , ( "Disabled"
          , \_ ->
                NumberInput.init "0"
                    |> NumberInput.view [ disabled True ]
          , {}
          )
        , ( "With small size"
          , \_ ->
                NumberInput.init "Text"
                    |> NumberInput.withSmallSize
                    |> NumberInput.view []
          , {}
          )
        , ( "With left align"
          , \_ ->
                NumberInput.init "123456"
                    |> NumberInput.withLeftAlignment
                    |> NumberInput.view []
          , {}
          )
        , ( "With left align and suffix"
          , \_ ->
                NumberInput.init "123456"
                    |> NumberInput.withLeftAlignment
                    |> NumberInput.withKrSuffix
                    |> NumberInput.view []
          , {}
          )
        , ( "With left align and small and suffix"
          , \_ ->
                NumberInput.init "123456"
                    |> NumberInput.withLeftAlignment
                    |> NumberInput.withSmallSize
                    |> NumberInput.withPctSuffix
                    |> NumberInput.view []
          , {}
          )
        ]
