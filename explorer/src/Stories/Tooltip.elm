module Stories.Tooltip exposing (stories)

import Css
    exposing
        ( alignItems
        , center
        , displayFlex
        , height
        , marginBottom
        , marginLeft
        , marginTop
        , overflowY
        , position
        , relative
        , rem
        , scroll
        , width
        )
import Html.Styled exposing (div, li, text, ul)
import Html.Styled.Attributes exposing (css)
import Nordea.Components.Card as Card
import Nordea.Components.Tooltip as Tooltip exposing (ArrowPlacement(..), Placement(..), Visibility(..))
import Nordea.Resources.Icons as Icons
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI a b {}
stories =
    styledStoriesOf
        "Tooltip"
        [ ( "Top"
          , \_ ->
                div []
                    [ text "There is a tooltip "
                    , Tooltip.init
                        |> Tooltip.withPlacement Top
                        |> Tooltip.withContent (Tooltip.infoTooltip [] [ text "This is a tooltip" ])
                        |> Tooltip.view [] [ text "here" ]
                    ]
          , {}
          )
        , ( "Top with arrow placed near corner"
          , \_ ->
                div []
                    [ text "There is a tooltip "
                    , Tooltip.init
                        |> Tooltip.withPlacement Top
                        |> Tooltip.withArrowPlacement NearCorner
                        |> Tooltip.withContent (Tooltip.infoTooltip [] [ text "This is a tooltip" ])
                        |> Tooltip.view [] [ text "here" ]
                    ]
          , {}
          )
        , ( "Top with arrow placed near other corner"
          , \_ ->
                div []
                    [ text "There is a tooltip "
                    , Tooltip.init
                        |> Tooltip.withPlacement Top
                        |> Tooltip.withArrowPlacement NearOtherCorner
                        |> Tooltip.withContent (Tooltip.infoTooltip [] [ text "This is a tooltip" ])
                        |> Tooltip.view [] [ text "here" ]
                    ]
          , {}
          )
        , ( "Bottom"
          , \_ ->
                div []
                    [ text "There is a tooltip "
                    , Tooltip.init
                        |> Tooltip.withPlacement Bottom
                        |> Tooltip.withContent (Tooltip.infoTooltip [] [ text "This is a tooltip" ])
                        |> Tooltip.view [] [ text "here" ]
                    ]
          , {}
          )
        , ( "Left"
          , \_ ->
                div []
                    [ text "There is a tooltip "
                    , Tooltip.init
                        |> Tooltip.withPlacement Left
                        |> Tooltip.withContent (Tooltip.infoTooltip [] [ text "This is a tooltip" ])
                        |> Tooltip.view [] [ text "here" ]
                    ]
          , {}
          )
        , ( "Right"
          , \_ ->
                div []
                    [ text "There is a tooltip "
                    , Tooltip.init
                        |> Tooltip.withPlacement Right
                        |> Tooltip.withContent (Tooltip.infoTooltip [] [ text "This is a tooltip" ])
                        |> Tooltip.view [] [ text "here" ]
                    ]
          , {}
          )
        , ( "Right with arrow placed near corner"
          , \_ ->
                div []
                    [ text "There is a tooltip "
                    , Tooltip.init
                        |> Tooltip.withPlacement Right
                        |> Tooltip.withArrowPlacement NearCorner
                        |> Tooltip.withContent
                            (Tooltip.infoTooltip []
                                [ ul []
                                    [ li [] [ text "First" ], li [] [ text "Second" ], li [] [ text "Third" ], li [] [ text "Fourth" ] ]
                                ]
                            )
                        |> Tooltip.view [] [ text "here" ]
                    ]
          , {}
          )
        , ( "With icon"
          , \_ ->
                div [ css [ displayFlex, alignItems center ] ]
                    [ text "There is a tooltip "
                    , Tooltip.init
                        |> Tooltip.withPlacement Right
                        |> Tooltip.withContent (Tooltip.infoTooltip [] [ text "This is a tooltip" ])
                        |> Tooltip.view [] [ Icons.questionMark [ css [ marginLeft (rem 0.25) ] ] ]
                    ]
          , {}
          )
        , ( "With icon disappear 3s"
          , \_ ->
                div [ css [ displayFlex, alignItems center ] ]
                    [ text "There is a tooltip "
                    , Tooltip.init
                        |> Tooltip.withVisibility (FadeOutMs 3000)
                        |> Tooltip.withPlacement Right
                        |> Tooltip.withContent (Tooltip.infoTooltip [] [ text "This is a tooltip" ])
                        |> Tooltip.view [] [ Icons.questionMark [ css [ marginLeft (rem 0.25) ] ] ]
                    ]
          , {}
          )
        , ( "With icon disappear 5s"
          , \_ ->
                div [ css [ displayFlex, alignItems center ] ]
                    [ text "There is a tooltip "
                    , Tooltip.init
                        |> Tooltip.withVisibility (FadeOutMs 5000)
                        |> Tooltip.withPlacement Right
                        |> Tooltip.withContent (Tooltip.infoTooltip [] [ text "This is a tooltip" ])
                        |> Tooltip.view [] [ Icons.questionMark [ css [ marginLeft (rem 0.25) ] ] ]
                    ]
          , {}
          )
        , ( "Card"
          , \_ ->
                div []
                    [ div [ css [ marginBottom (rem 10) ] ]
                        [ text "There is a bottom tooltip "
                        , Tooltip.init
                            |> Tooltip.withPlacement Bottom
                            |> Tooltip.withContent
                                (\arrow ->
                                    Card.init
                                        |> Card.withShadow
                                        |> Card.view
                                            [ css
                                                [ height (rem 18)
                                                , width (rem 18)
                                                , marginTop (rem 1)
                                                , position relative
                                                ]
                                            ]
                                            [ arrow []
                                            , div [ css [ overflowY scroll ] ] [ text lorem ]
                                            ]
                                )
                            |> Tooltip.view [] [ Icons.questionMark [ css [ marginLeft (rem 0.25) ] ] ]
                        ]
                    , div []
                        [ text "There is a right tooltip "
                        , Tooltip.init
                            |> Tooltip.withPlacement Right
                            |> Tooltip.withContent
                                (\arrow ->
                                    Card.init
                                        |> Card.withShadow
                                        |> Card.view
                                            [ css
                                                [ height (rem 18)
                                                , width (rem 18)
                                                , marginLeft (rem 1)
                                                , position relative
                                                ]
                                            ]
                                            [ arrow []
                                            , div [ css [ overflowY scroll ] ] [ text lorem ]
                                            ]
                                )
                            |> Tooltip.view [] [ Icons.questionMark [ css [ marginLeft (rem 0.25) ] ] ]
                        ]
                    ]
          , {}
          )
        ]


lorem =
    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
