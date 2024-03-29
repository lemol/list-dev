-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Github.Object.EnterpriseAdministratorEdge exposing (..)

import Github.Enum.EnterpriseAdministratorRole
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
cursor : SelectionSet String Github.Object.EnterpriseAdministratorEdge
cursor =
    Object.selectionForField "String" "cursor" [] Decode.string


{-| The item at the end of the edge.
-}
node : SelectionSet decodesTo Github.Object.User -> SelectionSet (Maybe decodesTo) Github.Object.EnterpriseAdministratorEdge
node object_ =
    Object.selectionForCompositeField "node" [] object_ (identity >> Decode.nullable)


{-| The role of the administrator.
-}
role : SelectionSet Github.Enum.EnterpriseAdministratorRole.EnterpriseAdministratorRole Github.Object.EnterpriseAdministratorEdge
role =
    Object.selectionForField "Enum.EnterpriseAdministratorRole.EnterpriseAdministratorRole" "role" [] Github.Enum.EnterpriseAdministratorRole.decoder
