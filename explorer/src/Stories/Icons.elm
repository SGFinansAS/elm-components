module Stories.Icons exposing (stories)

import Css
    exposing
        ( column
        , displayFlex
        , flexDirection
        , rem
        , row
        , width
        )
import Html.Styled as Html
import Html.Styled.Attributes exposing (css)
import Nordea.Components.Text as Text
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
                        , Icons.insights [ css [ width (rem 1.5) ] ]
                        , Icons.applications [ css [ width (rem 1.5) ] ]
                        , Icons.portfolio [ css [ width (rem 1.5) ] ]
                        , Icons.search [ css [ width (rem 1.5) ] ]
                        , Icons.search2 [ css [ width (rem 1.5) ] ]
                        , Icons.edit [ css [ width (rem 1.5) ] ]
                        , Icons.settings [ css [ width (rem 1.5) ] ]
                        , Icons.bell [ css [ width (rem 1.5) ] ]
                        , Icons.star [ css [ width (rem 1.5) ] ]
                        , Icons.calendar [ css [ width (rem 1.5) ] ]
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
                        , Icons.unfilledMark [ css [ width (rem 1.5) ] ]
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
                        , Icons.abacus [ css [ width (rem 1.5) ] ]
                        , Icons.object [ css [ width (rem 1.5) ] ]
                        , Icons.lightBulb [ css [ width (rem 1.5) ] ]
                        ]
                    ]
          , {}
          )
        ]
