-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Github.Enum.DefaultRepositoryPermissionField exposing (..)

import Json.Decode as Decode exposing (Decoder)


{-| The possible default permissions for repositories.

  - Admin - Can read, write, and administrate repos by default
  - None - No access
  - Read - Can read repos by default
  - Write - Can read and write repos by default

-}
type DefaultRepositoryPermissionField
    = Admin
    | None
    | Read
    | Write


list : List DefaultRepositoryPermissionField
list =
    [ Admin, None, Read, Write ]


decoder : Decoder DefaultRepositoryPermissionField
decoder =
    Decode.string
        |> Decode.andThen
            (\string ->
                case string of
                    "ADMIN" ->
                        Decode.succeed Admin

                    "NONE" ->
                        Decode.succeed None

                    "READ" ->
                        Decode.succeed Read

                    "WRITE" ->
                        Decode.succeed Write

                    _ ->
                        Decode.fail ("Invalid DefaultRepositoryPermissionField type, " ++ string ++ " try re-running the @dillonkearns/elm-graphql CLI ")
            )


{-| Convert from the union type representating the Enum to a string that the GraphQL server will recognize.
-}
toString : DefaultRepositoryPermissionField -> String
toString enum =
    case enum of
        Admin ->
            "ADMIN"

        None ->
            "NONE"

        Read ->
            "READ"

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
fromString : String -> Maybe DefaultRepositoryPermissionField
fromString enumString =
    case enumString of
        "ADMIN" ->
            Just Admin

        "NONE" ->
            Just None

        "READ" ->
            Just Read

        "WRITE" ->
            Just Write

        _ ->
            Nothing
