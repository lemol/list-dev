-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Github.Enum.RepositoryPermission exposing (..)

import Json.Decode as Decode exposing (Decoder)


{-| The access level to a repository

  - Admin - Can read, clone, and push to this repository. Can also manage issues, pull
    requests, and repository settings, including adding collaborators
  - Maintain - Can read, clone, and push to this repository. They can also manage issues, pull requests, and some repository settings
  - Read - Can read and clone this repository. Can also open and comment on issues and pull requests
  - Triage - Can read and clone this repository. Can also manage issues and pull requests
  - Write - Can read, clone, and push to this repository. Can also manage issues and pull requests

-}
type RepositoryPermission
    = Admin
    | Maintain
    | Read
    | Triage
    | Write


list : List RepositoryPermission
list =
    [ Admin, Maintain, Read, Triage, Write ]


decoder : Decoder RepositoryPermission
decoder =
    Decode.string
        |> Decode.andThen
            (\string ->
                case string of
                    "ADMIN" ->
                        Decode.succeed Admin

                    "MAINTAIN" ->
                        Decode.succeed Maintain

                    "READ" ->
                        Decode.succeed Read

                    "TRIAGE" ->
                        Decode.succeed Triage

                    "WRITE" ->
                        Decode.succeed Write

                    _ ->
                        Decode.fail ("Invalid RepositoryPermission type, " ++ string ++ " try re-running the @dillonkearns/elm-graphql CLI ")
            )


{-| Convert from the union type representating the Enum to a string that the GraphQL server will recognize.
-}
toString : RepositoryPermission -> String
toString enum =
    case enum of
        Admin ->
            "ADMIN"

        Maintain ->
            "MAINTAIN"

        Read ->
            "READ"

        Triage ->
            "TRIAGE"

        Write ->
            "WRITE"


{-| Convert from a String representation to an elm representation enum.
This is the inverse of the Enum `toString` function. So you can call `toString` and then convert back `fromString` safely.

    Swapi.Enum.Episode.NewHope
        |> Swapi.Enum.Episode.toString
        |> Swapi.Enum.Episode.fromString
        == Just NewHope

This can be useful for generating Strings to use for <select> menus to check which item was selected.

-}
fromString : String -> Maybe RepositoryPermission
fromString enumString =
    case enumString of
        "ADMIN" ->
            Just Admin

        "MAINTAIN" ->
            Just Maintain

        "READ" ->
            Just Read

        "TRIAGE" ->
            Just Triage

        "WRITE" ->
            Just Write

        _ ->
            Nothing
