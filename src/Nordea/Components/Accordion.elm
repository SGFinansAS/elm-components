module Nordea.Components.Accordion exposing
    ( Accordion
    , Item
    , Msg
    , init
    , update
    , view
    , withItem
    , withItems
    , withTitle
    )

import Css
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attrs
import Html.Styled.Events as Events
import List.Extra as List
import Nordea.Html as Html
import Nordea.Resources.Colors as Colors
import Nordea.Resources.Fonts as Fonts
import Nordea.Resources.Icons as Icons



-- CONFIG


type Accordion
    = Accordion Config


type alias Config =
    { title : Maybe String
    , items : List Item
    }


type alias Item =
    { title : String
    , body : List (Html Msg)
    , open : Bool
    }


type Msg
    = Toggle Item


init : Accordion
init =
    Accordion
        { title = Nothing
        , items = []
        }


withTitle : String -> Accordion -> Accordion
withTitle title (Accordion config) =
    Accordion { config | title = Just title }


withItem : Item -> Accordion -> Accordion
withItem item (Accordion config) =
    Accordion { config | items = config.items ++ [ item ] }


withItems : List Item -> Accordion -> Accordion
withItems items (Accordion config) =
    Accordion { config | items = items }



-- UPDATE


update : Msg -> Accordion -> Accordion
update msg (Accordion config) =
    Accordion { config | items = updateItems msg config.items }


updateItems : Msg -> List Item -> List Item
updateItems msg items =
    case msg of
        Toggle item ->
            items |> List.updateIf ((==) item) toggleItem


toggleItem : Item -> Item
toggleItem item =
    { item | open = not item.open }



-- VIEW


view : Accordion -> Html Msg
view (Accordion config) =
    Html.styled Html.div
        [ Css.padding2 (Css.rem 1) (Css.rem 1.5)
        , Css.borderRadius (Css.rem 0.5)
        , Css.backgroundColor Colors.blueCloud
        ]
        []
        [ Html.viewMaybe config.title viewTitle
        , Html.viewIfNotEmpty config.items viewItems
        ]


viewTitle : String -> Html Msg
viewTitle title =
    Html.styled Html.div
        [ Css.padding2 (Css.rem 1) Css.zero
        , Fonts.fromSize 1.125
        , Css.fontWeight (Css.int 500)
        , Css.color Colors.blueDeep
        ]
        []
        [ Html.text title ]


viewItems : List Item -> Html Msg
viewItems items =
    Html.styled Html.div
        [ Css.listStyle Css.none
        , Css.paddingLeft Css.zero
        , Css.padding2 (Css.rem 0.5) Css.zero
        ]
        []
        (List.map viewItem items)


viewItem : Item -> Html Msg
viewItem item =
    Html.styled Html.div
        [ Css.borderBottom3 (Css.rem 0.0625) Css.solid Colors.blueHaas
        , Css.firstChild
            [ Css.borderTop3 (Css.rem 0.0625) Css.solid Colors.blueHaas
            ]
        ]
        []
        [ viewItemTitle item
        , viewItemBody item
        ]


viewItemTitle : Item -> Html Msg
viewItemTitle item =
    Html.styled Html.div
        [ Css.displayFlex
        , Css.alignItems Css.center
        , Css.padding2 (Css.rem 1) Css.zero
        , Fonts.fromSize 1
        , Css.color Colors.blueDeep
        , Css.cursor Css.pointer
        ]
        [ Events.onClick (Toggle item) ]
        [ viewItemTitleText item.title
        , viewItemTitleArrow item.open
        ]


viewItemTitleText : String -> Html Msg
viewItemTitleText title =
    Html.styled Html.span
        [ Css.flexGrow (Css.num 1) ]
        []
        [ Html.text title ]


viewItemTitleArrow : Bool -> Html Msg
viewItemTitleArrow open =
    let
        icon =
            if open then
                Icons.chevronUp

            else
                Icons.chevronDown
    in
    Html.styled Html.span
        [ Css.flexShrink Css.zero ]
        []
        [ icon ]


viewItemBody : Item -> Html Msg
viewItemBody item =
    Html.styled Html.div
        [ Fonts.fromSize 0.875
        , Css.paddingBottom (Css.rem 1)
        ]
        [ Attrs.hidden (not item.open) ]
        item.body
