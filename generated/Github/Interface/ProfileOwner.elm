-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Github.Interface.ProfileOwner exposing (..)

import Github.Enum.PinnableItemType
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
    { onOrganization : SelectionSet decodesTo Github.Object.Organization
    , onUser : SelectionSet decodesTo Github.Object.User
    }


{-| Build an exhaustive selection of type-specific fragments.
-}
fragments :
    Fragments decodesTo
    -> SelectionSet decodesTo Github.Interface.ProfileOwner
fragments selections =
    Object.exhuastiveFragmentSelection
        [ Object.buildFragment "Organization" selections.onOrganization
        , Object.buildFragment "User" selections.onUser
        ]


{-| Can be used to create a non-exhuastive set of fragments by using the record
update syntax to add `SelectionSet`s for the types you want to handle.
-}
maybeFragments : Fragments (Maybe decodesTo)
maybeFragments =
    { onOrganization = Graphql.SelectionSet.empty |> Graphql.SelectionSet.map (\_ -> Nothing)
    , onUser = Graphql.SelectionSet.empty |> Graphql.SelectionSet.map (\_ -> Nothing)
    }


type alias AnyPinnableItemsOptionalArguments =
    { type_ : OptionalArgument Github.Enum.PinnableItemType.PinnableItemType }


{-| Determine if this repository owner has any items that can be pinned to their profile.

  - type\_ - Filter to only a particular kind of pinnable item.

-}
anyPinnableItems : (AnyPinnableItemsOptionalArguments -> AnyPinnableItemsOptionalArguments) -> SelectionSet Bool Github.Interface.ProfileOwner
anyPinnableItems fillInOptionals =
    let
        filledInOptionals =
            fillInOptionals { type_ = Absent }

        optionalArgs =
            [ Argument.optional "type" filledInOptionals.type_ (Encode.enum Github.Enum.PinnableItemType.toString) ]
                |> List.filterMap identity
    in
    Object.selectionForField "Bool" "anyPinnableItems" optionalArgs Decode.bool


{-| The public profile email.
-}
email : SelectionSet (Maybe String) Github.Interface.ProfileOwner
email =
    Object.selectionForField "(Maybe String)" "email" [] (Decode.string |> Decode.nullable)


{-| -}
id : SelectionSet Github.ScalarCodecs.Id Github.Interface.ProfileOwner
id =
    Object.selectionForField "ScalarCodecs.Id" "id" [] (Github.ScalarCodecs.codecs |> Github.Scalar.unwrapCodecs |> .codecId |> .decoder)


{-| Showcases a selection of repositories and gists that the profile owner has
either curated or that have been selected automatically based on popularity.
-}
itemShowcase : SelectionSet decodesTo Github.Object.ProfileItemShowcase -> SelectionSet decodesTo Github.Interface.ProfileOwner
itemShowcase object_ =
    Object.selectionForCompositeField "itemShowcase" [] object_ identity


{-| The public profile location.
-}
location : SelectionSet (Maybe String) Github.Interface.ProfileOwner
location =
    Object.selectionForField "(Maybe String)" "location" [] (Decode.string |> Decode.nullable)


{-| The username used to login.
-}
login : SelectionSet String Github.Interface.ProfileOwner
login =
    Object.selectionForField "String" "login" [] Decode.string


{-| The public profile name.
-}
name : SelectionSet (Maybe String) Github.Interface.ProfileOwner
name =
    Object.selectionForField "(Maybe String)" "name" [] (Decode.string |> Decode.nullable)


type alias PinnableItemsOptionalArguments =
    { after : OptionalArgument String
    , before : OptionalArgument String
    , first : OptionalArgument Int
    , last : OptionalArgument Int
    , types : OptionalArgument (List Github.Enum.PinnableItemType.PinnableItemType)
    }


{-| A list of repositories and gists this profile owner can pin to their profile.

  - after - Returns the elements in the list that come after the specified cursor.
  - before - Returns the elements in the list that come before the specified cursor.
  - first - Returns the first _n_ elements from the list.
  - last - Returns the last _n_ elements from the list.
  - types - Filter the types of pinnable items that are returned.

-}
pinnableItems : (PinnableItemsOptionalArguments -> PinnableItemsOptionalArguments) -> SelectionSet decodesTo Github.Object.PinnableItemConnection -> SelectionSet decodesTo Github.Interface.ProfileOwner
pinnableItems fillInOptionals object_ =
    let
        filledInOptionals =
            fillInOptionals { after = Absent, before = Absent, first = Absent, last = Absent, types = Absent }

        optionalArgs =
            [ Argument.optional "after" filledInOptionals.after Encode.string, Argument.optional "before" filledInOptionals.before Encode.string, Argument.optional "first" filledInOptionals.first Encode.int, Argument.optional "last" filledInOptionals.last Encode.int, Argument.optional "types" filledInOptionals.types (Encode.enum Github.Enum.PinnableItemType.toString |> Encode.list) ]
                |> List.filterMap identity
    in
    Object.selectionForCompositeField "pinnableItems" optionalArgs object_ identity


type alias PinnedItemsOptionalArguments =
    { after : OptionalArgument String
    , before : OptionalArgument String
    , first : OptionalArgument Int
    , last : OptionalArgument Int
    , types : OptionalArgument (List Github.Enum.PinnableItemType.PinnableItemType)
    }


{-| A list of repositories and gists this profile owner has pinned to their profile

  - after - Returns the elements in the list that come after the specified cursor.
  - before - Returns the elements in the list that come before the specified cursor.
  - first - Returns the first _n_ elements from the list.
  - last - Returns the last _n_ elements from the list.
  - types - Filter the types of pinned items that are returned.

-}
pinnedItems : (PinnedItemsOptionalArguments -> PinnedItemsOptionalArguments) -> SelectionSet decodesTo Github.Object.PinnableItemConnection -> SelectionSet decodesTo Github.Interface.ProfileOwner
pinnedItems fillInOptionals object_ =
    let
        filledInOptionals =
            fillInOptionals { after = Absent, before = Absent, first = Absent, last = Absent, types = Absent }

        optionalArgs =
            [ Argument.optional "after" filledInOptionals.after Encode.string, Argument.optional "before" filledInOptionals.before Encode.string, Argument.optional "first" filledInOptionals.first Encode.int, Argument.optional "last" filledInOptionals.last Encode.int, Argument.optional "types" filledInOptionals.types (Encode.enum Github.Enum.PinnableItemType.toString |> Encode.list) ]
                |> List.filterMap identity
    in
    Object.selectionForCompositeField "pinnedItems" optionalArgs object_ identity


{-| Returns how many more items this profile owner can pin to their profile.
-}
pinnedItemsRemaining : SelectionSet Int Github.Interface.ProfileOwner
pinnedItemsRemaining =
    Object.selectionForField "Int" "pinnedItemsRemaining" [] Decode.int


{-| Can the viewer pin repositories and gists to the profile?
-}
viewerCanChangePinnedItems : SelectionSet Bool Github.Interface.ProfileOwner
viewerCanChangePinnedItems =
    Object.selectionForField "Bool" "viewerCanChangePinnedItems" [] Decode.bool


{-| The public profile website URL.
-}
websiteUrl : SelectionSet (Maybe Github.ScalarCodecs.Uri) Github.Interface.ProfileOwner
websiteUrl =
    Object.selectionForField "(Maybe ScalarCodecs.Uri)" "websiteUrl" [] (Github.ScalarCodecs.codecs |> Github.Scalar.unwrapCodecs |> .codecUri |> .decoder |> Decode.nullable)
