-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Github.Object.ReviewDismissedEvent exposing (..)

import Github.Enum.PullRequestReviewState
import Github.InputObject
import Github.Interface
import Github.Object
import Github.Scalar
import Github.ScalarCodecs
import Github.Union
import Graphql.Internal.Builder.Argument as Argument exposing (Argument)
import Graphql.Internal.Builder.Object as Object
import Graphql.Internal.Encode as Encode exposing (Value)
import Graphql.Operation exposing (RootMutation, RootQuery, RootSubscription)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet exposing (SelectionSet)
import Json.Decode as Decode


{-| Identifies the actor who performed the event.
-}
actor : SelectionSet decodesTo Github.Interface.Actor -> SelectionSet (Maybe decodesTo) Github.Object.ReviewDismissedEvent
actor object_ =
    Object.selectionForCompositeField "actor" [] object_ (identity >> Decode.nullable)


{-| Identifies the date and time when the object was created.
-}
createdAt : SelectionSet Github.ScalarCodecs.DateTime Github.Object.ReviewDismissedEvent
createdAt =
    Object.selectionForField "ScalarCodecs.DateTime" "createdAt" [] (Github.ScalarCodecs.codecs |> Github.Scalar.unwrapCodecs |> .codecDateTime |> .decoder)


{-| Identifies the primary key from the database.
-}
databaseId : SelectionSet (Maybe Int) Github.Object.ReviewDismissedEvent
databaseId =
    Object.selectionForField "(Maybe Int)" "databaseId" [] (Decode.int |> Decode.nullable)


{-| Identifies the optional message associated with the 'review\_dismissed' event.
-}
dismissalMessage : SelectionSet (Maybe String) Github.Object.ReviewDismissedEvent
dismissalMessage =
    Object.selectionForField "(Maybe String)" "dismissalMessage" [] (Decode.string |> Decode.nullable)


{-| Identifies the optional message associated with the event, rendered to HTML.
-}
dismissalMessageHTML : SelectionSet (Maybe String) Github.Object.ReviewDismissedEvent
dismissalMessageHTML =
    Object.selectionForField "(Maybe String)" "dismissalMessageHTML" [] (Decode.string |> Decode.nullable)


{-| -}
id : SelectionSet Github.ScalarCodecs.Id Github.Object.ReviewDismissedEvent
id =
    Object.selectionForField "ScalarCodecs.Id" "id" [] (Github.ScalarCodecs.codecs |> Github.Scalar.unwrapCodecs |> .codecId |> .decoder)


{-| Identifies the previous state of the review with the 'review\_dismissed' event.
-}
previousReviewState : SelectionSet Github.Enum.PullRequestReviewState.PullRequestReviewState Github.Object.ReviewDismissedEvent
previousReviewState =
    Object.selectionForField "Enum.PullRequestReviewState.PullRequestReviewState" "previousReviewState" [] Github.Enum.PullRequestReviewState.decoder


{-| PullRequest referenced by event.
-}
pullRequest : SelectionSet decodesTo Github.Object.PullRequest -> SelectionSet decodesTo Github.Object.ReviewDismissedEvent
pullRequest object_ =
    Object.selectionForCompositeField "pullRequest" [] object_ identity


{-| Identifies the commit which caused the review to become stale.
-}
pullRequestCommit : SelectionSet decodesTo Github.Object.PullRequestCommit -> SelectionSet (Maybe decodesTo) Github.Object.ReviewDismissedEvent
pullRequestCommit object_ =
    Object.selectionForCompositeField "pullRequestCommit" [] object_ (identity >> Decode.nullable)


{-| The HTTP path for this review dismissed event.
-}
resourcePath : SelectionSet Github.ScalarCodecs.Uri Github.Object.ReviewDismissedEvent
resourcePath =
    Object.selectionForField "ScalarCodecs.Uri" "resourcePath" [] (Github.ScalarCodecs.codecs |> Github.Scalar.unwrapCodecs |> .codecUri |> .decoder)


{-| Identifies the review associated with the 'review\_dismissed' event.
-}
review : SelectionSet decodesTo Github.Object.PullRequestReview -> SelectionSet (Maybe decodesTo) Github.Object.ReviewDismissedEvent
review object_ =
    Object.selectionForCompositeField "review" [] object_ (identity >> Decode.nullable)


{-| The HTTP URL for this review dismissed event.
-}
url : SelectionSet Github.ScalarCodecs.Uri Github.Object.ReviewDismissedEvent
url =
    Object.selectionForField "ScalarCodecs.Uri" "url" [] (Github.ScalarCodecs.codecs |> Github.Scalar.unwrapCodecs |> .codecUri |> .decoder)
