module Stories.Icons exposing (stories)

import Css exposing (column, displayFlex, flexDirection, rem, row, width)
import Html.Styled as Html
import Html.Styled.Attributes exposing (css)
import Nordea.Components.Text as Text
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Icons as Icons
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI a b {}
stories =
    let
        iconCategoryHeader headerText =
            Text.bodyTextHeavy |> Text.view [] [ Html.text headerText ]

        iconsRow icons =
            Html.div [ css [ displayFlex, flexDirection row, Css.property "gap" "2rem" ] ]
                icons
    in
    styledStoriesOf
        "Icons"
        [ ( "Icons"
          , \_ ->
                Html.div [ css [ displayFlex, flexDirection column, Css.property "gap" "1rem" ] ]
                    [ iconCategoryHeader "Arrows and directions"
                    , iconsRow
                        [ Icons.arrowBack [ css [ width (rem 1.5) ] ]
                        , Icons.chevronLeft [ css [ width (rem 1.5) ] ]
                        , Icons.chevronUp [ css [ width (rem 1.5) ] ]
                        , Icons.chevronDown [ css [ width (rem 1.5) ] ]
                        , Icons.chevronRight [ css [ width (rem 1.5) ] ]
                        , Icons.triangleDown "Black" [ css [ width (rem 1.5) ] ]
                        , Icons.triangleUp "Black" [ css [ width (rem 1.5) ] ]
                        ]
                    , iconCategoryHeader "Functions & features"
                    , iconsRow
                        [ Icons.delete [ css [ width (rem 1.5) ] ]
                        , Icons.user [ css [ width (rem 1.5) ] ]
                        , Icons.contacts [ css [ width (rem 1.5) ] ]
                        , Icons.settings [ css [ width (rem 1.5) ] ]
                        , Icons.logout [ css [ width (rem 1.5) ] ]
                        , Icons.document [ css [ width (rem 1.5) ] ]
                        , Icons.download [ css [ width (rem 1.5) ] ]
                        , Icons.newApplication [ css [ width (rem 1.5) ] ]
                        , Icons.financingProposals [ css [ width (rem 1.5) ] ]
                        , Icons.creditLimits [ css [ width (rem 1.5) ] ]
                        , Icons.applications [ css [ width (rem 1.5) ] ]
                        , Icons.portfolio [ css [ width (rem 1.5) ] ]
                        ]
                    , iconCategoryHeader "Add, remove, accept and cancel"
                    , iconsRow
                        [ Icons.warning [ css [ width (rem 1.5) ] ]
                        , Icons.close [ css [ width (rem 1.5) ] ]
                        , Icons.info [ css [ width (rem 1.5) ] ]
                        , Icons.questionMark [ css [ width (rem 1.5) ] ]
                        , Icons.filledCheckmark [ css [ width (rem 1.5) ] ]
                        , Icons.unfilledMark [ css [ width (rem 1.5) ] ]
                        , Icons.largeAdditionalInfo [ css [ width (rem 1.5) ] ]
                        , Icons.dismiss [ css [ width (rem 1.5) ] ]
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
                    , iconsRow
                        [ Icons.downloaded [ css [ width (rem 1.5) ] ]
                        , Icons.factorTables [ css [ width (rem 1.5) ] ]
                        , Icons.object [ css [ width (rem 1.5) ] ]
                        ]

                    --, Icons.nordeaLogo (Just "Nordea Logo") [ css [ width (rem 1.5) ] ]
                    --, Icons.poweredByNordea (Just "Powered by Nordea") [ css [ width (rem 1.5) ] ]
                    --, Icons.feedbackEnvelope [ css [ width (rem 1.5) ] ]
                    --, Icons.balloon [ css [ width (rem 1.5) ] ]
                    --, Icons.rejection [ css [ width (rem 1.5) ] ]
                    --, Icons.instructionalStar [ css [ width (rem 1.5) ] ]
                    --, Icons.instructionalBlocks [ css [ width (rem 1.5) ] ]
                    ]
          , {}
          )
        ]
