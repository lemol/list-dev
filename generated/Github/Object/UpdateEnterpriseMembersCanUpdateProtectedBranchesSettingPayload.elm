-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Github.Object.UpdateEnterpriseMembersCanUpdateProtectedBranchesSettingPayload exposing (..)

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


{-| A unique identifier for the client performing the mutation.
-}
clientMutationId : SelectionSet (Maybe String) Github.Object.UpdateEnterpriseMembersCanUpdateProtectedBranchesSettingPayload
clientMutationId =
    Object.selectionForField "(Maybe String)" "clientMutationId" [] (Decode.string |> Decode.nullable)


{-| The enterprise with the updated members can update protected branches setting.
-}
enterprise : SelectionSet decodesTo Github.Object.Enterprise -> SelectionSet (Maybe decodesTo) Github.Object.UpdateEnterpriseMembersCanUpdateProtectedBranchesSettingPayload
enterprise object_ =
    Object.selectionForCompositeField "enterprise" [] object_ (identity >> Decode.nullable)


{-| A message confirming the result of updating the members can update protected branches setting.
-}
message : SelectionSet (Maybe String) Github.Object.UpdateEnterpriseMembersCanUpdateProtectedBranchesSettingPayload
message =
    Object.selectionForField "(Maybe String)" "message" [] (Decode.string |> Decode.nullable)
