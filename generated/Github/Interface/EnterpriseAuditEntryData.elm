-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Github.Interface.EnterpriseAuditEntryData exposing (..)

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
import Graphql.SelectionSet exposing (FragmentSelectionSet(..), SelectionSet(..))
import Json.Decode as Decode


type alias Fragments decodesTo =
    { onMembersCanDeleteReposClearAuditEntry : SelectionSet decodesTo Github.Object.MembersCanDeleteReposClearAuditEntry
    , onMembersCanDeleteReposDisableAuditEntry : SelectionSet decodesTo Github.Object.MembersCanDeleteReposDisableAuditEntry
    , onMembersCanDeleteReposEnableAuditEntry : SelectionSet decodesTo Github.Object.MembersCanDeleteReposEnableAuditEntry
    , onOrgInviteToBusinessAuditEntry : SelectionSet decodesTo Github.Object.OrgInviteToBusinessAuditEntry
    , onPrivateRepositoryForkingDisableAuditEntry : SelectionSet decodesTo Github.Object.PrivateRepositoryForkingDisableAuditEntry
    , onPrivateRepositoryForkingEnableAuditEntry : SelectionSet decodesTo Github.Object.PrivateRepositoryForkingEnableAuditEntry
    , onRepositoryVisibilityChangeDisableAuditEntry : SelectionSet decodesTo Github.Object.RepositoryVisibilityChangeDisableAuditEntry
    , onRepositoryVisibilityChangeEnableAuditEntry : SelectionSet decodesTo Github.Object.RepositoryVisibilityChangeEnableAuditEntry
    }


{-| Build an exhaustive selection of type-specific fragments.
-}
fragments :
    Fragments decodesTo
    -> SelectionSet decodesTo Github.Interface.EnterpriseAuditEntryData
fragments selections =
    Object.exhuastiveFragmentSelection
        [ Object.buildFragment "MembersCanDeleteReposClearAuditEntry" selections.onMembersCanDeleteReposClearAuditEntry
        , Object.buildFragment "MembersCanDeleteReposDisableAuditEntry" selections.onMembersCanDeleteReposDisableAuditEntry
        , Object.buildFragment "MembersCanDeleteReposEnableAuditEntry" selections.onMembersCanDeleteReposEnableAuditEntry
        , Object.buildFragment "OrgInviteToBusinessAuditEntry" selections.onOrgInviteToBusinessAuditEntry
        , Object.buildFragment "PrivateRepositoryForkingDisableAuditEntry" selections.onPrivateRepositoryForkingDisableAuditEntry
        , Object.buildFragment "PrivateRepositoryForkingEnableAuditEntry" selections.onPrivateRepositoryForkingEnableAuditEntry
        , Object.buildFragment "RepositoryVisibilityChangeDisableAuditEntry" selections.onRepositoryVisibilityChangeDisableAuditEntry
        , Object.buildFragment "RepositoryVisibilityChangeEnableAuditEntry" selections.onRepositoryVisibilityChangeEnableAuditEntry
        ]


{-| Can be used to create a non-exhuastive set of fragments by using the record
update syntax to add `SelectionSet`s for the types you want to handle.
-}
maybeFragments : Fragments (Maybe decodesTo)
maybeFragments =
    { onMembersCanDeleteReposClearAuditEntry = Graphql.SelectionSet.empty |> Graphql.SelectionSet.map (\_ -> Nothing)
    , onMembersCanDeleteReposDisableAuditEntry = Graphql.SelectionSet.empty |> Graphql.SelectionSet.map (\_ -> Nothing)
    , onMembersCanDeleteReposEnableAuditEntry = Graphql.SelectionSet.empty |> Graphql.SelectionSet.map (\_ -> Nothing)
    , onOrgInviteToBusinessAuditEntry = Graphql.SelectionSet.empty |> Graphql.SelectionSet.map (\_ -> Nothing)
    , onPrivateRepositoryForkingDisableAuditEntry = Graphql.SelectionSet.empty |> Graphql.SelectionSet.map (\_ -> Nothing)
    , onPrivateRepositoryForkingEnableAuditEntry = Graphql.SelectionSet.empty |> Graphql.SelectionSet.map (\_ -> Nothing)
    , onRepositoryVisibilityChangeDisableAuditEntry = Graphql.SelectionSet.empty |> Graphql.SelectionSet.map (\_ -> Nothing)
    , onRepositoryVisibilityChangeEnableAuditEntry = Graphql.SelectionSet.empty |> Graphql.SelectionSet.map (\_ -> Nothing)
    }


{-| The HTTP path for this enterprise.
-}
enterpriseResourcePath : SelectionSet (Maybe Github.ScalarCodecs.Uri) Github.Interface.EnterpriseAuditEntryData
enterpriseResourcePath =
    Object.selectionForField "(Maybe ScalarCodecs.Uri)" "enterpriseResourcePath" [] (Github.ScalarCodecs.codecs |> Github.Scalar.unwrapCodecs |> .codecUri |> .decoder |> Decode.nullable)


{-| The slug of the enterprise.
-}
enterpriseSlug : SelectionSet (Maybe String) Github.Interface.EnterpriseAuditEntryData
enterpriseSlug =
    Object.selectionForField "(Maybe String)" "enterpriseSlug" [] (Decode.string |> Decode.nullable)


{-| The HTTP URL for this enterprise.
-}
enterpriseUrl : SelectionSet (Maybe Github.ScalarCodecs.Uri) Github.Interface.EnterpriseAuditEntryData
enterpriseUrl =
    Object.selectionForField "(Maybe ScalarCodecs.Uri)" "enterpriseUrl" [] (Github.ScalarCodecs.codecs |> Github.Scalar.unwrapCodecs |> .codecUri |> .decoder |> Decode.nullable)
