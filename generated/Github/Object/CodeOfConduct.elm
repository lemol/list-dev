-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Github.Object.CodeOfConduct exposing (..)

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


{-| The body of the Code of Conduct
-}
body : SelectionSet (Maybe String) Github.Object.CodeOfConduct
body =
    Object.selectionForField "(Maybe String)" "body" [] (Decode.string |> Decode.nullable)


{-| -}
id : SelectionSet Github.ScalarCodecs.Id Github.Object.CodeOfConduct
id =
    Object.selectionForField "ScalarCodecs.Id" "id" [] (Github.ScalarCodecs.codecs |> Github.Scalar.unwrapCodecs |> .codecId |> .decoder)


{-| The key for the Code of Conduct
-}
key : SelectionSet String Github.Object.CodeOfConduct
key =
    Object.selectionForField "String" "key" [] Decode.string


{-| The formal name of the Code of Conduct
-}
name : SelectionSet String Github.Object.CodeOfConduct
name =
    Object.selectionForField "String" "name" [] Decode.string


{-| The HTTP path for this Code of Conduct
-}
resourcePath : SelectionSet (Maybe Github.ScalarCodecs.Uri) Github.Object.CodeOfConduct
resourcePath =
    Object.selectionForField "(Maybe ScalarCodecs.Uri)" "resourcePath" [] (Github.ScalarCodecs.codecs |> Github.Scalar.unwrapCodecs |> .codecUri |> .decoder |> Decode.nullable)


{-| The HTTP URL for this Code of Conduct
-}
url : SelectionSet (Maybe Github.ScalarCodecs.Uri) Github.Object.CodeOfConduct
url =
    Object.selectionForField "(Maybe ScalarCodecs.Uri)" "url" [] (Github.ScalarCodecs.codecs |> Github.Scalar.unwrapCodecs |> .codecUri |> .decoder |> Decode.nullable)
