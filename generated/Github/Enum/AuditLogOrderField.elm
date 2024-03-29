-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Github.Enum.AuditLogOrderField exposing (..)

import Json.Decode as Decode exposing (Decoder)


{-| Properties by which Audit Log connections can be ordered.

  - CreatedAt - Order audit log entries by timestamp

-}
type AuditLogOrderField
    = CreatedAt


list : List AuditLogOrderField
list =
    [ CreatedAt ]


decoder : Decoder AuditLogOrderField
decoder =
    Decode.string
        |> Decode.andThen
            (\string ->
                case string of
                    "CREATED_AT" ->
                        Decode.succeed CreatedAt

                    _ ->
                        Decode.fail ("Invalid AuditLogOrderField type, " ++ string ++ " try re-running the @dillonkearns/elm-graphql CLI ")
            )


{-| Convert from the union type representating the Enum to a string that the GraphQL server will recognize.
-}
toString : AuditLogOrderField -> String
toString enum =
    case enum of
        CreatedAt ->
            "CREATED_AT"


{-| Convert from a String representation to an elm representation enum.
This is the inverse of the Enum `toString` function. So you can call `toString` and then convert back `fromString` safely.

    Swapi.Enum.Episode.NewHope
        |> Swapi.Enum.Episode.toString
        |> Swapi.Enum.Episode.fromString
        == Just NewHope

This can be useful for generating Strings to use for <select> menus to check which item was selected.

-}
fromString : String -> Maybe AuditLogOrderField
fromString enumString =
    case enumString of
        "CREATED_AT" ->
            Just CreatedAt

        _ ->
            Nothing
