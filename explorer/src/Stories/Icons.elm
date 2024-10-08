module Stories.Icons exposing (stories)

import Css exposing (alignItems, center, column, displayFlex, flexDirection, flexWrap, height, justifyContent, rem, row, spaceBetween, width, wrap)
import Html.Styled as Html
import Html.Styled.Attributes exposing (css)
import Nordea.Components.Text as Text
import Nordea.Css exposing (columnGap, gap)
import Nordea.Resources.Icons as Icons
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI a b {}
stories =
    let
        iconCategoryHeader headerText =
            Text.bodyTextHeavy |> Text.view [] [ Html.text headerText ]

        iconsRow icons =
            Html.div [ css [ displayFlex, flexDirection row, gap (rem 2) ] ]
                icons

        iconsRowWithDescription iconsWithDescription =
            Html.div [ css [ displayFlex, flexDirection row, columnGap (rem 1) ] ]
                (iconsWithDescription
                    |> List.map
                        (\( icon, description ) ->
                            Html.div [ css [ displayFlex, flexDirection column, flexWrap wrap, justifyContent spaceBetween, alignItems center, height (rem 4) ] ]
                                [ icon [ css [ width (rem 1.5) ] ]
                                , Text.textTinyLight |> Text.view [] [ Html.text description ]
                                ]
                        )
                )
    in
    styledStoriesOf
        "Icons"
        [ ( "Icons"
          , \_ ->
                Html.div [ css [ displayFlex, flexDirection column, gap (rem 1) ] ]
                    [ iconCategoryHeader "Arrows and directions"
                    , iconsRow
                        [ Icons.arrowBack [ css [ width (rem 1.5) ] ]
                        , Icons.chevronLeft [ css [ width (rem 1.5) ] ]
                        , Icons.chevronUp [ css [ width (rem 1.5) ] ]
                        , Icons.chevronDown [ css [ width (rem 1.5) ] ]
                        , Icons.chevronRight [ css [ width (rem 1.5) ] ]
                        , Icons.triangleDown [ css [ width (rem 1.5) ] ]
                        , Icons.triangleUp [ css [ width (rem 1.5) ] ]
                        ]
                    , iconCategoryHeader "Functions & features"
                    , iconsRow
                        [ Icons.delete [ css [ width (rem 1.5) ] ]
                        , Icons.user [ css [ width (rem 1.5) ] ]
                        , Icons.contacts [ css [ width (rem 1.5) ] ]
                        , Icons.cog [ css [ width (rem 1.5) ] ]
                        , Icons.exit [ css [ width (rem 1.5) ] ]
                        , Icons.document [ css [ width (rem 1.5) ] ]
                        , Icons.download [ css [ width (rem 1.5) ] ]
                        , Icons.orders [ css [ width (rem 1.5) ] ]
                        , Icons.agreements [ css [ width (rem 1.5) ] ]
                        , Icons.completedOrder [ css [ width (rem 1.5) ] ]
                        , Icons.insights [ css [ width (rem 1.5) ] ]
                        , Icons.applications [ css [ width (rem 1.5) ] ]
                        , Icons.portfolio [ css [ width (rem 1.5) ] ]
                        , Icons.search [ css [ width (rem 1.5) ] ]
                        , Icons.search2 [ css [ width (rem 1.5) ] ]
                        , Icons.edit [ css [ width (rem 1.5) ] ]
                        , Icons.settings [ css [ width (rem 1.5) ] ]
                        , Icons.bell [ css [ width (rem 1.5) ] ]
                        , Icons.star [ css [ width (rem 1.5) ] ]
                        , Icons.filledStar [ css [ width (rem 1.5) ] ]
                        , Icons.calendar [ css [ width (rem 1.5) ] ]
                        , Icons.visible [ css [ width (rem 1.5) ] ]
                        , Icons.invisible [ css [ width (rem 1.5) ] ]
                        , Icons.pdf [ css [ width (rem 1.5) ] ]
                        , Icons.openEnvelope [ css [ width (rem 1.5) ] ]
                        ]
                    , iconCategoryHeader "Add, remove, accept and cancel"
                    , iconsRow
                        [ Icons.warning [ css [ width (rem 1.5) ] ]
                        , Icons.filledWarning [ css [ width (rem 1.5) ] ]
                        , Icons.info [ css [ width (rem 1.5) ] ]
                        , Icons.filledInfo [ css [ width (rem 1.5) ] ]
                        , Icons.questionMark [ css [ width (rem 1.5) ] ]
                        , Icons.close [ css [ width (rem 1.5) ] ]
                        , Icons.filledCheckmark [ css [ width (rem 1.5) ] ]
                        , Icons.unfilledCheckmark [ css [ width (rem 1.5) ] ]
                        , Icons.unfilledMark [ css [ width (rem 1.5) ] ]
                        , Icons.dismiss [ css [ width (rem 1.5) ] ]
                        , Icons.unfilledDismiss [ css [ width (rem 1.5) ] ]
                        , Icons.mediumPlus [ css [ width (rem 1.5) ] ]
                        , Icons.add [ css [ width (rem 1.5) ] ]
                        ]
                    , iconCategoryHeader "Contact"
                    , iconsRow
                        [ Icons.contact [ css [ width (rem 1.5) ] ]
                        , Icons.largeEnvelope [ css [ width (rem 1.5) ] ]
                        , Icons.largePhone [ css [ width (rem 1.5) ] ]
                        ]
                    , iconCategoryHeader "Misc."
                    , iconsRowWithDescription
                        [ ( Icons.downloaded, "downloaded" )
                        , ( Icons.abacus, "abacus" )
                        , ( Icons.object, "object" )
                        , ( Icons.lightBulb, "lightBulb" )
                        , ( Icons.eye, "eye" )
                        ]
                    , iconCategoryHeader "Country flags"
                    , iconsRow
                        [ Icons.norway [ css [ width (rem 1.5) ] ]
                        , Icons.sweden [ css [ width (rem 1.5) ] ]
                        , Icons.denmark [ css [ width (rem 1.5) ] ]
                        ]
                    ]
          , {}
          )
        ]
