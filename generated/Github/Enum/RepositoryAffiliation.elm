-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Github.Enum.RepositoryAffiliation exposing (..)

import Json.Decode as Decode exposing (Decoder)


{-| The affiliation of a user to a repository

  - Collaborator - Repositories that the user has been added to as a collaborator.
  - OrganizationMember - Repositories that the user has access to through being a member of an
    organization. This includes every repository on every team that the user is on.
  - Owner - Repositories that are owned by the authenticated user.

-}
type RepositoryAffiliation
    = Collaborator
    | OrganizationMember
    | Owner


list : List RepositoryAffiliation
list =
    [ Collaborator, OrganizationMember, Owner ]


decoder : Decoder RepositoryAffiliation
decoder =
    Decode.string
        |> Decode.andThen
            (\string ->
                case string of
                    "COLLABORATOR" ->
                        Decode.succeed Collaborator

                    "ORGANIZATION_MEMBER" ->
                        Decode.succeed OrganizationMember

                    "OWNER" ->
                        Decode.succeed Owner

                    _ ->
                        Decode.fail ("Invalid RepositoryAffiliation type, " ++ string ++ " try re-running the @dillonkearns/elm-graphql CLI ")
            )


{-| Convert from the union type representating the Enum to a string that the GraphQL server will recognize.
-}
toString : RepositoryAffiliation -> String
toString enum =
    case enum of
        Collaborator ->
            "COLLABORATOR"

        OrganizationMember ->
            "ORGANIZATION_MEMBER"

        Owner ->
            "OWNER"


{-| Convert from a String representation to an elm representation enum.
This is the inverse of the Enum `toString` function. So you can call `toString` and then convert back `fromString` safely.

    Swapi.Enum.Episode.NewHope
        |> Swapi.Enum.Episode.toString
        |> Swapi.Enum.Episode.fromString
        == Just NewHope

This can be useful for generating Strings to use for <select> menus to check which item was selected.

-}
fromString : String -> Maybe RepositoryAffiliation
fromString enumString =
    case enumString of
        "COLLABORATOR" ->
            Just Collaborator

        "ORGANIZATION_MEMBER" ->
            Just OrganizationMember

        "OWNER" ->
            Just Owner

        _ ->
            Nothing