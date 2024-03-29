-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Github.Interface.Actor exposing (..)

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
    { onEnterpriseUserAccount : SelectionSet decodesTo Github.Object.EnterpriseUserAccount
    , onOrganization : SelectionSet decodesTo Github.Object.Organization
    , onUser : SelectionSet decodesTo Github.Object.User
    , onMannequin : SelectionSet decodesTo Github.Object.Mannequin
    , onBot : SelectionSet decodesTo Github.Object.Bot
    }


{-| Build an exhaustive selection of type-specific fragments.
-}
fragments :
    Fragments decodesTo
    -> SelectionSet decodesTo Github.Interface.Actor
fragments selections =
    Object.exhuastiveFragmentSelection
        [ Object.buildFragment "EnterpriseUserAccount" selections.onEnterpriseUserAccount
        , Object.buildFragment "Organization" selections.onOrganization
        , Object.buildFragment "User" selections.onUser
        , Object.buildFragment "Mannequin" selections.onMannequin
        , Object.buildFragment "Bot" selections.onBot
        ]


{-| Can be used to create a non-exhuastive set of fragments by using the record
update syntax to add `SelectionSet`s for the types you want to handle.
-}
maybeFragments : Fragments (Maybe decodesTo)
maybeFragments =
    { onEnterpriseUserAccount = Graphql.SelectionSet.empty |> Graphql.SelectionSet.map (\_ -> Nothing)
    , onOrganization = Graphql.SelectionSet.empty |> Graphql.SelectionSet.map (\_ -> Nothing)
    , onUser = Graphql.SelectionSet.empty |> Graphql.SelectionSet.map (\_ -> Nothing)
    , onMannequin = Graphql.SelectionSet.empty |> Graphql.SelectionSet.map (\_ -> Nothing)
    , onBot = Graphql.SelectionSet.empty |> Graphql.SelectionSet.map (\_ -> Nothing)
    }


type alias AvatarUrlOptionalArguments =
    { size : OptionalArgument Int }


{-| A URL pointing to the actor's public avatar.

  - size - The size of the resulting square image.

-}
avatarUrl : (AvatarUrlOptionalArguments -> AvatarUrlOptionalArguments) -> SelectionSet Github.ScalarCodecs.Uri Github.Interface.Actor
avatarUrl fillInOptionals =
    let
        filledInOptionals =
            fillInOptionals { size = Absent }

        optionalArgs =
            [ Argument.optional "size" filledInOptionals.size Encode.int ]
                |> List.filterMap identity
    in
    Object.selectionForField "ScalarCodecs.Uri" "avatarUrl" optionalArgs (Github.ScalarCodecs.codecs |> Github.Scalar.unwrapCodecs |> .codecUri |> .decoder)


{-| The username of the actor.
-}
login : SelectionSet String Github.Interface.Actor
login =
    Object.selectionForField "String" "login" [] Decode.string


{-| The HTTP path for this actor.
-}
resourcePath : SelectionSet Github.ScalarCodecs.Uri Github.Interface.Actor
resourcePath =
    Object.selectionForField "ScalarCodecs.Uri" "resourcePath" [] (Github.ScalarCodecs.codecs |> Github.Scalar.unwrapCodecs |> .codecUri |> .decoder)


{-| The HTTP URL for this actor.
-}
url : SelectionSet Github.ScalarCodecs.Uri Github.Interface.Actor
url =
    Object.selectionForField "ScalarCodecs.Uri" "url" [] (Github.ScalarCodecs.codecs |> Github.Scalar.unwrapCodecs |> .codecUri |> .decoder)
