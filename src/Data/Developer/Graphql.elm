module Data.Developer.Graphql exposing (fetchDeveloperList)

import Data.Developer exposing (Developer, DeveloperListWebData, Language, Location, RemoteError(..), Repository, Sort(..))
import Github.Enum.SearchType as SearchType
import Github.Object
import Github.Object.PinnableItemConnection as PinnableItemConnection
import Github.Object.ProfileItemShowcase as ProfileItemShowcase
import Github.Object.Repository as Repository
import Github.Object.SearchResultItemConnection
import Github.Object.User as User
import Github.Query
import Github.Scalar exposing (Uri(..))
import Github.Union
import Github.Union.PinnableItem as PinnableItem
import Github.Union.SearchResultItem
import Global exposing (AccessToken)
import Graphql.Http
import Graphql.Operation exposing (RootQuery)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
import RemoteData exposing (RemoteData(..))



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
        (SelectionSet.map List.head (User.itemShowcase decodeProfileShowcase))


decodeProfileShowcase : SelectionSet (List Repository) Github.Object.ProfileItemShowcase
decodeProfileShowcase =
    ProfileItemShowcase.items (\optional -> { optional | first = Present 20 })
        (PinnableItemConnection.nodes decodePinnableItem)
        |> SelectionSet.map (Maybe.withDefault [])
        |> SelectionSet.map (List.filterMap identity)
        |> SelectionSet.map (List.filterMap identity)


decodePinnableItem : SelectionSet (Maybe Repository) Github.Union.PinnableItem
decodePinnableItem =
    let
        maybeFragments =
            PinnableItem.maybeFragments
    in
    PinnableItem.fragments
        { maybeFragments
            | onRepository = SelectionSet.map Just repositorySelection
        }


repositorySelection : SelectionSet Repository Github.Object.Repository
repositorySelection =
    SelectionSet.map2 Repository
        Repository.name
        (SelectionSet.map (Maybe.withDefault "") Repository.description)



-- API


sortToQueryString : Maybe Sort -> String
sortToQueryString sortBy =
    let
        toString sort =
            case sort of
                BestMatch ->
                    ""

                MostFollowers ->
                    "sort:followers-desc"

                FewestFollowers ->
                    "sort:followers-asc"

                MostRecentlyJoined ->
                    "sort:joined-desc"

                LeastRecentlyJoined ->
                    "sort:joined-asc"

                MostRepositories ->
                    "sort:repositories-desc"

                FewestRepositories ->
                    "sort:repositories-asc"
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
            "language:" ++ str


locationFilterToQueryString : Maybe Location -> String
locationFilterToQueryString filter =
    case filter of
        Nothing ->
            "followers:>=0"

        Just str ->
            "location:" ++ str


fetchDeveloperList : AccessToken -> Maybe Location -> Maybe Sort -> Maybe Language -> (DeveloperListWebData -> msg) -> Cmd msg
fetchDeveloperList token location sortBy languageFilter toMsg =
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
            [ locationFilterToQueryString location
            , languageFilterToQueryString languageFilter
            , sortToQueryString sortBy
            ]
                |> List.filter ((/=) "")
                |> String.join " "
    in
    query
        |> Graphql.Http.queryRequest "http://localhost:3000/api/github-graphql.ts"
        |> Graphql.Http.withHeader "authorization" ("Bearer " ++ token)
        |> Graphql.Http.send (RemoteData.fromResult >> RemoteData.mapError GraphqlError >> toMsg)
