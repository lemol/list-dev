-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Github.Object.OrganizationMemberEdge exposing (..)

import Github.Enum.OrganizationMemberRole
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


{-| A cursor for use in pagination.
-}
cursor : SelectionSet String Github.Object.OrganizationMemberEdge
cursor =
    Object.selectionForField "String" "cursor" [] Decode.string


{-| Whether the organization member has two factor enabled or not. Returns null if information is not available to viewer.
-}
hasTwoFactorEnabled : SelectionSet (Maybe Bool) Github.Object.OrganizationMemberEdge
hasTwoFactorEnabled =
    Object.selectionForField "(Maybe Bool)" "hasTwoFactorEnabled" [] (Decode.bool |> Decode.nullable)


{-| The item at the end of the edge.
-}
node : SelectionSet decodesTo Github.Object.User -> SelectionSet (Maybe decodesTo) Github.Object.OrganizationMemberEdge
node object_ =
    Object.selectionForCompositeField "node" [] object_ (identity >> Decode.nullable)


{-| The role this user has in the organization.
-}
role : SelectionSet (Maybe Github.Enum.OrganizationMemberRole.OrganizationMemberRole) Github.Object.OrganizationMemberEdge
role =
    Object.selectionForField "(Maybe Enum.OrganizationMemberRole.OrganizationMemberRole)" "role" [] (Github.Enum.OrganizationMemberRole.decoder |> Decode.nullable)
