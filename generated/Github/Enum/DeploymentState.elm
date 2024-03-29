-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Github.Enum.DeploymentState exposing (..)

import Json.Decode as Decode exposing (Decoder)


{-| The possible states in which a deployment can be.

  - Abandoned - The pending deployment was not updated after 30 minutes.
  - Active - The deployment is currently active.
  - Destroyed - An inactive transient deployment.
  - Error - The deployment experienced an error.
  - Failure - The deployment has failed.
  - Inactive - The deployment is inactive.
  - InProgress - The deployment is in progress.
  - Pending - The deployment is pending.
  - Queued - The deployment has queued

-}
type DeploymentState
    = Abandoned
    | Active
    | Destroyed
    | Error
    | Failure
    | Inactive
    | InProgress
    | Pending
    | Queued


list : List DeploymentState
list =
    [ Abandoned, Active, Destroyed, Error, Failure, Inactive, InProgress, Pending, Queued ]


decoder : Decoder DeploymentState
decoder =
    Decode.string
        |> Decode.andThen
            (\string ->
                case string of
                    "ABANDONED" ->
                        Decode.succeed Abandoned

                    "ACTIVE" ->
                        Decode.succeed Active

                    "DESTROYED" ->
                        Decode.succeed Destroyed

                    "ERROR" ->
                        Decode.succeed Error

                    "FAILURE" ->
                        Decode.succeed Failure

                    "INACTIVE" ->
                        Decode.succeed Inactive

                    "IN_PROGRESS" ->
                        Decode.succeed InProgress

                    "PENDING" ->
                        Decode.succeed Pending

                    "QUEUED" ->
                        Decode.succeed Queued

                    _ ->
                        Decode.fail ("Invalid DeploymentState type, " ++ string ++ " try re-running the @dillonkearns/elm-graphql CLI ")
            )


{-| Convert from the union type representating the Enum to a string that the GraphQL server will recognize.
-}
toString : DeploymentState -> String
toString enum =
    case enum of
        Abandoned ->
            "ABANDONED"

        Active ->
            "ACTIVE"

        Destroyed ->
            "DESTROYED"

        Error ->
            "ERROR"

        Failure ->
            "FAILURE"

        Inactive ->
            "INACTIVE"

        InProgress ->
            "IN_PROGRESS"

        Pending ->
            "PENDING"

        Queued ->
            "QUEUED"


{-| Convert from a String representation to an elm representation enum.
This is the inverse of the Enum `toString` function. So you can call `toString` and then convert back `fromString` safely.

    Swapi.Enum.Episode.NewHope
        |> Swapi.Enum.Episode.toString
        |> Swapi.Enum.Episode.fromString
        == Just NewHope

This can be useful for generating Strings to use for <select> menus to check which item was selected.

-}
fromString : String -> Maybe DeploymentState
fromString enumString =
    case enumString of
        "ABANDONED" ->
            Just Abandoned

        "ACTIVE" ->
            Just Active

        "DESTROYED" ->
            Just Destroyed

        "ERROR" ->
            Just Error

        "FAILURE" ->
            Just Failure

        "INACTIVE" ->
            Just Inactive

        "IN_PROGRESS" ->
            Just InProgress

        "PENDING" ->
            Just Pending

        "QUEUED" ->
            Just Queued

        _ ->
            Nothing
