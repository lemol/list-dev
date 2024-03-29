-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Github.Enum.CommentAuthorAssociation exposing (..)

import Json.Decode as Decode exposing (Decoder)


{-| A comment author association with repository.

  - Collaborator - Author has been invited to collaborate on the repository.
  - Contributor - Author has previously committed to the repository.
  - FirstTimer - Author has not previously committed to GitHub.
  - FirstTimeContributor - Author has not previously committed to the repository.
  - Member - Author is a member of the organization that owns the repository.
  - None - Author has no association with the repository.
  - Owner - Author is the owner of the repository.

-}
type CommentAuthorAssociation
    = Collaborator
    | Contributor
    | FirstTimer
    | FirstTimeContributor
    | Member
    | None
    | Owner


list : List CommentAuthorAssociation
list =
    [ Collaborator, Contributor, FirstTimer, FirstTimeContributor, Member, None, Owner ]


decoder : Decoder CommentAuthorAssociation
decoder =
    Decode.string
        |> Decode.andThen
            (\string ->
                case string of
                    "COLLABORATOR" ->
                        Decode.succeed Collaborator

                    "CONTRIBUTOR" ->
                        Decode.succeed Contributor

                    "FIRST_TIMER" ->
                        Decode.succeed FirstTimer

                    "FIRST_TIME_CONTRIBUTOR" ->
                        Decode.succeed FirstTimeContributor

                    "MEMBER" ->
                        Decode.succeed Member

                    "NONE" ->
                        Decode.succeed None

                    "OWNER" ->
                        Decode.succeed Owner

                    _ ->
                        Decode.fail ("Invalid CommentAuthorAssociation type, " ++ string ++ " try re-running the @dillonkearns/elm-graphql CLI ")
            )


{-| Convert from the union type representating the Enum to a string that the GraphQL server will recognize.
-}
toString : CommentAuthorAssociation -> String
toString enum =
    case enum of
        Collaborator ->
            "COLLABORATOR"

        Contributor ->
            "CONTRIBUTOR"

        FirstTimer ->
            "FIRST_TIMER"

        FirstTimeContributor ->
            "FIRST_TIME_CONTRIBUTOR"

        Member ->
            "MEMBER"

        None ->
            "NONE"

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
fromString : String -> Maybe CommentAuthorAssociation
fromString enumString =
    case enumString of
        "COLLABORATOR" ->
            Just Collaborator

        "CONTRIBUTOR" ->
            Just Contributor

        "FIRST_TIMER" ->
            Just FirstTimer

        "FIRST_TIME_CONTRIBUTOR" ->
            Just FirstTimeContributor

        "MEMBER" ->
            Just Member

        "NONE" ->
            Just None

        "OWNER" ->
            Just Owner

        _ ->
            Nothing
