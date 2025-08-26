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

        iconsRowWithDescription iconsWithDescription =
            Html.div [ css [ displayFlex, flexDirection row, columnGap (rem 1), flexWrap wrap ] ]
                (iconsWithDescription
                    |> List.map
                        (\( icon, description ) ->
                            Html.div [ css [ displayFlex, flexDirection column, flexWrap wrap, justifyContent spaceBetween, alignItems center, height (rem 4) ] ]
                                [ icon [ css [ width (rem 1.5), height (rem 2) ] ]
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
                    , iconsRowWithDescription
                        [ ( Icons.arrowBack, "arrowBack" )
                        , ( Icons.chevronLeft, "chevronLeft" )
                        , ( Icons.chevronUp, "chevronUp" )
                        , ( Icons.chevronDown, "chevronDown" )
                        , ( Icons.chevronRight, "chevronRight" )
                        , ( Icons.triangleDown, "triangleDown" )
                        , ( Icons.triangleUp, "triangleUp" )
                        ]
                    , iconCategoryHeader "Functions & features"
                    , iconsRowWithDescription
                        [ ( Icons.delete, "delete" )
                        , ( Icons.user, "user" )
                        , ( Icons.userSmall, "userSmall" )
                        , ( Icons.contacts, "contacts" )
                        , ( Icons.cog, "cog" )
                        , ( Icons.exit, "exit" )
                        , ( Icons.document, "document" )
                        , ( Icons.download, "download" )
                        , ( Icons.orders, "orders" )
                        , ( Icons.agreements, "agreements" )
                        , ( Icons.completedOrder, "completedOrder" )
                        , ( Icons.insights, "insights" )
                        , ( Icons.applications, "applications" )
                        , ( Icons.portfolio, "portfolio" )
                        , ( Icons.search, "search" )
                        , ( Icons.search2, "search2" )
                        , ( Icons.edit, "edit" )
                        , ( Icons.settings, "settings" )
                        , ( Icons.bell, "bell" )
                        , ( Icons.bellSmall, "bellSmall" )
                        , ( Icons.bellOff, "bellOff" )
                        , ( Icons.star, "star" )
                        , ( Icons.filledStar, "filledStar" )
                        , ( Icons.calendar, "calendar" )
                        , ( Icons.visible, "visible" )
                        , ( Icons.invisible, "invisible" )
                        , ( Icons.pdf, "pdf" )
                        , ( Icons.envelope, "envelope" )
                        , ( Icons.openEnvelope, "openEnvelope" )
                        , ( Icons.logout, "logout" )
                        , ( Icons.copy, "copy" )
                        , ( Icons.filter, "filter" )
                        , ( Icons.refresh, "refresh" )
                        ]
                    , iconCategoryHeader "Add, remove, accept and cancel"
                    , iconsRowWithDescription
                        [ ( Icons.warning, "warning" )
                        , ( Icons.filledWarning, "filledWarning" )
                        , ( Icons.info, "info" )
                        , ( Icons.filledInfo, "filledInfo" )
                        , ( Icons.questionMark, "questionMark" )
                        , ( Icons.close, "close" )
                        , ( Icons.checkmark, "checkmark" )
                        , ( Icons.filledCheckmark, "filledCheckmark" )
                        , ( Icons.unfilledCheckmark, "unfilledCheckmark" )
                        , ( Icons.unfilledMark, "unfilledMark" )
                        , ( Icons.dismiss, "dismiss" )
                        , ( Icons.unfilledDismiss, "unfilledDismiss" )
                        , ( Icons.mediumPlus, "mediumPlus" )
                        , ( Icons.add, "add" )
                        ]
                    , iconCategoryHeader "Contact"
                    , iconsRowWithDescription
                        [ ( Icons.contact, "contact" )
                        , ( Icons.largeEnvelope, "largeEnvelope" )
                        , ( Icons.largePhone, "largePhone" )
                        , ( Icons.salary, "salary" )
                        ]
                    , iconCategoryHeader "Misc."
                    , iconsRowWithDescription
                        [ ( Icons.downloaded, "downloaded" )
                        , ( Icons.abacus, "abacus" )
                        , ( Icons.object, "object" )
                        , ( Icons.lightBulb, "lightBulb" )
                        , ( Icons.eye, "eye" )
                        , ( Icons.externalLink, "external link" )
                        ]
                    , iconCategoryHeader "Country flags"
                    , iconsRowWithDescription
                        [ ( Icons.flagNorway, "flagNorway" )
                        , ( Icons.flagSweden, "flagSweden" )
                        , ( Icons.denmark, "flagDenmark" )
                        ]
                    , iconCategoryHeader "Identification methods"
                    , iconsRowWithDescription
                        [ ( Icons.norwegianBankId, "norwegianBankId" )
                        , ( Icons.swedishBankId, "swedishBankId" )
                        , ( Icons.danishMitId, "danishMitId" )
                        ]
                    ]
          , {}
          )
        ]
