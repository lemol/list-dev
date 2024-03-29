-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Github.Object.EnterpriseServerUserAccountsUpload exposing (..)

import Github.Enum.EnterpriseServerUserAccountsUploadSyncState
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


{-| Identifies the date and time when the object was created.
-}
createdAt : SelectionSet Github.ScalarCodecs.DateTime Github.Object.EnterpriseServerUserAccountsUpload
createdAt =
    Object.selectionForField "ScalarCodecs.DateTime" "createdAt" [] (Github.ScalarCodecs.codecs |> Github.Scalar.unwrapCodecs |> .codecDateTime |> .decoder)


{-| The enterprise to which this upload belongs.
-}
enterprise : SelectionSet decodesTo Github.Object.Enterprise -> SelectionSet decodesTo Github.Object.EnterpriseServerUserAccountsUpload
enterprise object_ =
    Object.selectionForCompositeField "enterprise" [] object_ identity


{-| The Enterprise Server installation for which this upload was generated.
-}
enterpriseServerInstallation : SelectionSet decodesTo Github.Object.EnterpriseServerInstallation -> SelectionSet decodesTo Github.Object.EnterpriseServerUserAccountsUpload
enterpriseServerInstallation object_ =
    Object.selectionForCompositeField "enterpriseServerInstallation" [] object_ identity


{-| -}
id : SelectionSet Github.ScalarCodecs.Id Github.Object.EnterpriseServerUserAccountsUpload
id =
    Object.selectionForField "ScalarCodecs.Id" "id" [] (Github.ScalarCodecs.codecs |> Github.Scalar.unwrapCodecs |> .codecId |> .decoder)


{-| The name of the file uploaded.
-}
name : SelectionSet String Github.Object.EnterpriseServerUserAccountsUpload
name =
    Object.selectionForField "String" "name" [] Decode.string


{-| The synchronization state of the upload
-}
syncState : SelectionSet Github.Enum.EnterpriseServerUserAccountsUploadSyncState.EnterpriseServerUserAccountsUploadSyncState Github.Object.EnterpriseServerUserAccountsUpload
syncState =
    Object.selectionForField "Enum.EnterpriseServerUserAccountsUploadSyncState.EnterpriseServerUserAccountsUploadSyncState" "syncState" [] Github.Enum.EnterpriseServerUserAccountsUploadSyncState.decoder


{-| Identifies the date and time when the object was last updated.
-}
updatedAt : SelectionSet Github.ScalarCodecs.DateTime Github.Object.EnterpriseServerUserAccountsUpload
updatedAt =
    Object.selectionForField "ScalarCodecs.DateTime" "updatedAt" [] (Github.ScalarCodecs.codecs |> Github.Scalar.unwrapCodecs |> .codecDateTime |> .decoder)
