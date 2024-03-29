-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Github.Object.MergedEvent exposing (..)

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
actor : SelectionSet decodesTo Github.Interface.Actor -> SelectionSet (Maybe decodesTo) Github.Object.MergedEvent
actor object_ =
    Object.selectionForCompositeField "actor" [] object_ (identity >> Decode.nullable)


{-| Identifies the commit associated with the `merge` event.
-}
commit : SelectionSet decodesTo Github.Object.Commit -> SelectionSet (Maybe decodesTo) Github.Object.MergedEvent
commit object_ =
    Object.selectionForCompositeField "commit" [] object_ (identity >> Decode.nullable)


{-| Identifies the date and time when the object was created.
-}
createdAt : SelectionSet Github.ScalarCodecs.DateTime Github.Object.MergedEvent
createdAt =
    Object.selectionForField "ScalarCodecs.DateTime" "createdAt" [] (Github.ScalarCodecs.codecs |> Github.Scalar.unwrapCodecs |> .codecDateTime |> .decoder)


{-| -}
id : SelectionSet Github.ScalarCodecs.Id Github.Object.MergedEvent
id =
    Object.selectionForField "ScalarCodecs.Id" "id" [] (Github.ScalarCodecs.codecs |> Github.Scalar.unwrapCodecs |> .codecId |> .decoder)


{-| Identifies the Ref associated with the `merge` event.
-}
mergeRef : SelectionSet decodesTo Github.Object.Ref -> SelectionSet (Maybe decodesTo) Github.Object.MergedEvent
mergeRef object_ =
    Object.selectionForCompositeField "mergeRef" [] object_ (identity >> Decode.nullable)


{-| Identifies the name of the Ref associated with the `merge` event.
-}
mergeRefName : SelectionSet String Github.Object.MergedEvent
mergeRefName =
    Object.selectionForField "String" "mergeRefName" [] Decode.string


{-| PullRequest referenced by event.
-}
pullRequest : SelectionSet decodesTo Github.Object.PullRequest -> SelectionSet decodesTo Github.Object.MergedEvent
pullRequest object_ =
    Object.selectionForCompositeField "pullRequest" [] object_ identity


{-| The HTTP path for this merged event.
-}
resourcePath : SelectionSet Github.ScalarCodecs.Uri Github.Object.MergedEvent
resourcePath =
    Object.selectionForField "ScalarCodecs.Uri" "resourcePath" [] (Github.ScalarCodecs.codecs |> Github.Scalar.unwrapCodecs |> .codecUri |> .decoder)


{-| The HTTP URL for this merged event.
-}
url : SelectionSet Github.ScalarCodecs.Uri Github.Object.MergedEvent
url =
    Object.selectionForField "ScalarCodecs.Uri" "url" [] (Github.ScalarCodecs.codecs |> Github.Scalar.unwrapCodecs |> .codecUri |> .decoder)
