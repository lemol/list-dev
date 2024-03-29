-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Github.Enum.PullRequestReviewEvent exposing (..)

import Json.Decode as Decode exposing (Decoder)


{-| The possible events to perform on a pull request review.

  - Approve - Submit feedback and approve merging these changes.
  - Comment - Submit general feedback without explicit approval.
  - Dismiss - Dismiss review so it now longer effects merging.
  - RequestChanges - Submit feedback that must be addressed before merging.

-}
type PullRequestReviewEvent
    = Approve
    | Comment
    | Dismiss
    | RequestChanges


list : List PullRequestReviewEvent
list =
    [ Approve, Comment, Dismiss, RequestChanges ]


decoder : Decoder PullRequestReviewEvent
decoder =
    Decode.string
        |> Decode.andThen
            (\string ->
                case string of
                    "APPROVE" ->
                        Decode.succeed Approve

                    "COMMENT" ->
                        Decode.succeed Comment

                    "DISMISS" ->
                        Decode.succeed Dismiss

                    "REQUEST_CHANGES" ->
                        Decode.succeed RequestChanges

                    _ ->
                        Decode.fail ("Invalid PullRequestReviewEvent type, " ++ string ++ " try re-running the @dillonkearns/elm-graphql CLI ")
            )


{-| Convert from the union type representating the Enum to a string that the GraphQL server will recognize.
-}
toString : PullRequestReviewEvent -> String
toString enum =
    case enum of
        Approve ->
            "APPROVE"

        Comment ->
            "COMMENT"

        Dismiss ->
            "DISMISS"

        RequestChanges ->
            "REQUEST_CHANGES"


{-| Convert from a String representation to an elm representation enum.
This is the inverse of the Enum `toString` function. So you can call `toString` and then convert back `fromString` safely.

    Swapi.Enum.Episode.NewHope
        |> Swapi.Enum.Episode.toString
        |> Swapi.Enum.Episode.fromString
        == Just NewHope

This can be useful for generating Strings to use for <select> menus to check which item was selected.

-}
fromString : String -> Maybe PullRequestReviewEvent
fromString enumString =
    case enumString of
        "APPROVE" ->
            Just Approve

        "COMMENT" ->
            Just Comment

        "DISMISS" ->
            Just Dismiss

        "REQUEST_CHANGES" ->
            Just RequestChanges

        _ ->
            Nothing
