-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Github.Object.PublicKey exposing (..)

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


{-| The last time this authorization was used to perform an action. Values will be null for keys not owned by the user.
-}
accessedAt : SelectionSet (Maybe Github.ScalarCodecs.DateTime) Github.Object.PublicKey
accessedAt =
    Object.selectionForField "(Maybe ScalarCodecs.DateTime)" "accessedAt" [] (Github.ScalarCodecs.codecs |> Github.Scalar.unwrapCodecs |> .codecDateTime |> .decoder |> Decode.nullable)


{-| Identifies the date and time when the key was created. Keys created before
March 5th, 2014 have inaccurate values. Values will be null for keys not owned by the user.
-}
createdAt : SelectionSet (Maybe Github.ScalarCodecs.DateTime) Github.Object.PublicKey
createdAt =
    Object.selectionForField "(Maybe ScalarCodecs.DateTime)" "createdAt" [] (Github.ScalarCodecs.codecs |> Github.Scalar.unwrapCodecs |> .codecDateTime |> .decoder |> Decode.nullable)


{-| The fingerprint for this PublicKey.
-}
fingerprint : SelectionSet String Github.Object.PublicKey
fingerprint =
    Object.selectionForField "String" "fingerprint" [] Decode.string


{-| -}
id : SelectionSet Github.ScalarCodecs.Id Github.Object.PublicKey
id =
    Object.selectionForField "ScalarCodecs.Id" "id" [] (Github.ScalarCodecs.codecs |> Github.Scalar.unwrapCodecs |> .codecId |> .decoder)


{-| Whether this PublicKey is read-only or not. Values will be null for keys not owned by the user.
-}
isReadOnly : SelectionSet (Maybe Bool) Github.Object.PublicKey
isReadOnly =
    Object.selectionForField "(Maybe Bool)" "isReadOnly" [] (Decode.bool |> Decode.nullable)


{-| The public key string.
-}
key : SelectionSet String Github.Object.PublicKey
key =
    Object.selectionForField "String" "key" [] Decode.string


{-| Identifies the date and time when the key was updated. Keys created before
March 5th, 2014 may have inaccurate values. Values will be null for keys not
owned by the user.
-}
updatedAt : SelectionSet (Maybe Github.ScalarCodecs.DateTime) Github.Object.PublicKey
updatedAt =
    Object.selectionForField "(Maybe ScalarCodecs.DateTime)" "updatedAt" [] (Github.ScalarCodecs.codecs |> Github.Scalar.unwrapCodecs |> .codecDateTime |> .decoder |> Decode.nullable)
