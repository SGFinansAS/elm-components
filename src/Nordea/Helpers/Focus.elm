module Nordea.Helpers.Focus exposing (groupIdAttributeToItemAttrs, onFocusAttrs)

import Html.Styled exposing (Attribute)
import Html.Styled.Attributes as Attr
import Html.Styled.Events as Events
import Json.Decode as Decode


onFocusAttrs : Maybe ( String, Bool -> msg ) -> List (Attribute msg)
onFocusAttrs hasFocusAndId =
    let
        hasFocus =
            Maybe.map Tuple.second hasFocusAndId

        groupAttr =
            Maybe.map Tuple.first hasFocusAndId
                |> Maybe.map groupIdAttribute
                |> Maybe.map List.singleton
                |> Maybe.withDefault []

        onFocusAttribute =
            hasFocus
                |> Maybe.map (\f -> f True)
                |> Maybe.map Events.onFocus
                |> Maybe.map List.singleton
                |> Maybe.withDefault []

        onBlurAttribute =
            hasFocus
                |> Maybe.map (\f -> f False)
                |> Maybe.map onGroupBlur
                |> Maybe.map List.singleton
                |> Maybe.withDefault []
    in
    onFocusAttribute ++ onBlurAttribute ++ groupAttr


groupIdAttributeToItemAttrs : Maybe ( String, Bool -> msg ) -> List (Attribute msg)
groupIdAttributeToItemAttrs groupId =
    Maybe.map Tuple.first groupId
        |> Maybe.map groupIdAttribute
        |> Maybe.map List.singleton
        |> Maybe.withDefault []


onGroupBlur : msg -> Attribute msg
onGroupBlur msg =
    Events.on "blur" (decodeGroupIdChanged msg)


groupIdAttribute : String -> Attribute msg
groupIdAttribute groupId =
    Attr.attribute "data-group-id" groupId


{-| Concept taken from:
<https://stackoverflow.com/questions/52375939/in-elm-how-can-i-detect-if-focus-will-be-lost-from-a-group-of-elements>
-}
decodeGroupIdChanged : msg -> Decode.Decoder msg
decodeGroupIdChanged msg =
    Decode.oneOf
        [ Decode.map2
            (\a b ->
                if a /= b then
                    Just a

                else
                    Nothing
            )
            (Decode.at [ "target", "dataset", "groupId" ] Decode.string)
            (Decode.at [ "relatedTarget", "dataset", "groupId" ] Decode.string)
        , Decode.at [ "target", "dataset", "groupId" ] Decode.string
            |> Decode.andThen (\a -> Decode.succeed (Just a))
        ]
        |> Decode.andThen
            (\maybeChanged ->
                case maybeChanged of
                    Just _ ->
                        Decode.succeed msg

                    Nothing ->
                        Decode.fail "no change"
            )
