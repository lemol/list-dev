-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Github.Enum.RepositoryLockReason exposing (..)

import Json.Decode as Decode exposing (Decoder)


{-| The possible reasons a given repository could be in a locked state.

  - Billing - The repository is locked due to a billing related reason.
  - Migrating - The repository is locked due to a migration.
  - Moving - The repository is locked due to a move.
  - Rename - The repository is locked due to a rename.

-}
type RepositoryLockReason
    = Billing
    | Migrating
    | Moving
    | Rename


list : List RepositoryLockReason
list =
    [ Billing, Migrating, Moving, Rename ]


decoder : Decoder RepositoryLockReason
decoder =
    Decode.string
        |> Decode.andThen
            (\string ->
                case string of
                    "BILLING" ->
                        Decode.succeed Billing

                    "MIGRATING" ->
                        Decode.succeed Migrating

                    "MOVING" ->
                        Decode.succeed Moving

                    "RENAME" ->
                        Decode.succeed Rename

                    _ ->
                        Decode.fail ("Invalid RepositoryLockReason type, " ++ string ++ " try re-running the @dillonkearns/elm-graphql CLI ")
            )


{-| Convert from the union type representating the Enum to a string that the GraphQL server will recognize.
-}
toString : RepositoryLockReason -> String
toString enum =
    case enum of
        Billing ->
            "BILLING"

        Migrating ->
            "MIGRATING"

        Moving ->
            "MOVING"

        Rename ->
            "RENAME"


{-| Convert from a String representation to an elm representation enum.
This is the inverse of the Enum `toString` function. So you can call `toString` and then convert back `fromString` safely.

    Swapi.Enum.Episode.NewHope
        |> Swapi.Enum.Episode.toString
        |> Swapi.Enum.Episode.fromString
        == Just NewHope

This can be useful for generating Strings to use for <select> menus to check which item was selected.

-}
fromString : String -> Maybe RepositoryLockReason
fromString enumString =
    case enumString of
        "BILLING" ->
            Just Billing

        "MIGRATING" ->
            Just Migrating

        "MOVING" ->
            Just Moving

        "RENAME" ->
            Just Rename

        _ ->
            Nothing