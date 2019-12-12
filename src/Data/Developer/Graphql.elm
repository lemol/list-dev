module Data.Developer.Graphql exposing (fetchDeveloperList)

import Data.Developer exposing (Developer, DeveloperListWebData, Language, RemoteError(..), Sort(..))
import Github.Enum.SearchType as SearchType
import Github.Object
import Github.Object.SearchResultItemConnection
import Github.Object.User as User
import Github.Query
import Github.Scalar exposing (Uri(..))
import Github.Union
import Github.Union.SearchResultItem
import Global exposing (AccessToken)
import Graphql.Http
import Graphql.Operation exposing (RootQuery)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
import RemoteData exposing (RemoteData(..))
import Url exposing (percentEncode)



-- SERIALIZATION


serachResultSelectionSet : SelectionSet (List Developer) Github.Object.SearchResultItemConnection
serachResultSelectionSet =
    Github.Object.SearchResultItemConnection.nodes developerSearchResultSelection
        |> SelectionSet.map (Maybe.withDefault [])
        |> SelectionSet.map (List.filterMap identity)
        |> SelectionSet.map (List.filterMap identity)


developerSearchResultSelection : SelectionSet (Maybe Developer) Github.Union.SearchResultItem
developerSearchResultSelection =
    let
        maybeFragments =
            Github.Union.SearchResultItem.maybeFragments
    in
    Github.Union.SearchResultItem.fragments
        { maybeFragments
            | onUser = SelectionSet.map Just developerSelection
        }


developerSelection : SelectionSet Developer Github.Object.User
developerSelection =
    SelectionSet.map6 Developer
        User.login
        User.login
        (SelectionSet.map (\(Uri url) -> url) (User.avatarUrl identity))
        (SelectionSet.map (\(Uri url) -> url) User.url)
        (SelectionSet.map (\(Uri url) -> url) User.url)
        (SelectionSet.succeed Nothing)



-- API


sortToQueryString : Maybe Sort -> String
sortToQueryString sortBy =
    let
        toString sort =
            case sort of
                BestMatch ->
                    "&order=desc"

                MostFollowers ->
                    "&order=desc&sort=followers"

                FewestFollowers ->
                    "&order=asc&sort=followers"

                MostRecentlyJoined ->
                    "&order=desc&sort=joined"

                LeastRecentlyJoined ->
                    "&order=asc&sort=joined"

                MostRepositories ->
                    "&order=desc&sort=repositories"

                FewestRepositories ->
                    "&order=asc&sort=repositories"
    in
    sortBy
        |> Maybe.withDefault BestMatch
        |> toString


languageFilterToQueryString : Maybe Language -> String
languageFilterToQueryString filter =
    case filter of
        Nothing ->
            ""

        Just str ->
            " language:" ++ percentEncode str


fetchDeveloperList : AccessToken -> Maybe Sort -> Maybe Language -> (DeveloperListWebData -> msg) -> Cmd msg
fetchDeveloperList token sortBy languageFilter toMsg =
    let
        query : SelectionSet (List Developer) RootQuery
        query =
            Github.Query.search
                (\optional -> { optional | first = Present 20 })
                { query = queryString
                , type_ = SearchType.User
                }
                serachResultSelectionSet

        queryString =
            "location:Angola"
                ++ languageFilterToQueryString languageFilter

        -- ++ sortToQueryString sortBy
        -- ++ "&per_page=20"
    in
    query
        |> Graphql.Http.queryRequest "http://localhost:3000/api/github-graphql.ts"
        |> Graphql.Http.withHeader "authorization" ("Bearer " ++ token)
        |> Graphql.Http.send (RemoteData.fromResult >> RemoteData.mapError GraphqlError >> toMsg)
