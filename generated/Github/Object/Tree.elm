-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Github.Object.Tree exposing (..)

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


{-| An abbreviated version of the Git object ID
-}
abbreviatedOid : SelectionSet String Github.Object.Tree
abbreviatedOid =
    Object.selectionForField "String" "abbreviatedOid" [] Decode.string


{-| The HTTP path for this Git object
-}
commitResourcePath : SelectionSet Github.ScalarCodecs.Uri Github.Object.Tree
commitResourcePath =
    Object.selectionForField "ScalarCodecs.Uri" "commitResourcePath" [] (Github.ScalarCodecs.codecs |> Github.Scalar.unwrapCodecs |> .codecUri |> .decoder)


{-| The HTTP URL for this Git object
-}
commitUrl : SelectionSet Github.ScalarCodecs.Uri Github.Object.Tree
commitUrl =
    Object.selectionForField "ScalarCodecs.Uri" "commitUrl" [] (Github.ScalarCodecs.codecs |> Github.Scalar.unwrapCodecs |> .codecUri |> .decoder)


{-| A list of tree entries.
-}
entries : SelectionSet decodesTo Github.Object.TreeEntry -> SelectionSet (Maybe (List decodesTo)) Github.Object.Tree
entries object_ =
    Object.selectionForCompositeField "entries" [] object_ (identity >> Decode.list >> Decode.nullable)


{-| -}
id : SelectionSet Github.ScalarCodecs.Id Github.Object.Tree
id =
    Object.selectionForField "ScalarCodecs.Id" "id" [] (Github.ScalarCodecs.codecs |> Github.Scalar.unwrapCodecs |> .codecId |> .decoder)


{-| The Git object ID
-}
oid : SelectionSet Github.ScalarCodecs.GitObjectID Github.Object.Tree
oid =
    Object.selectionForField "ScalarCodecs.GitObjectID" "oid" [] (Github.ScalarCodecs.codecs |> Github.Scalar.unwrapCodecs |> .codecGitObjectID |> .decoder)


{-| The Repository the Git object belongs to
-}
repository : SelectionSet decodesTo Github.Object.Repository -> SelectionSet decodesTo Github.Object.Tree
repository object_ =
    Object.selectionForCompositeField "repository" [] object_ identity
