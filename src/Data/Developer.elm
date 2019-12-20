module Data.Developer exposing (Location, LocationListWebData, Developer, DeveloperListWebData, Language, LanguageListWebData, RemoteError(..), Repository, Sort(..), languageToString, languageValues, sortToString, sortValues, locationValues, locationToString)

import Graphql.Http
import Http
import RemoteData exposing (RemoteData, WebData)


type alias Repository =
    { name : String
    , description : String
    }


type alias Developer =
    { login : String
    , name : String
    , avatar : String
    , url : String
    , htmlUrl : String
    , popularRepo : Maybe Repository
    }


type RemoteError a
    = RestError Http.Error
    | GraphqlError (Graphql.Http.Error a)


type alias DeveloperListWebData =
    RemoteData (RemoteError (List Developer)) (List Developer)


type Sort
    = BestMatch
    | MostFollowers
    | FewestFollowers
    | MostRecentlyJoined
    | LeastRecentlyJoined
    | MostRepositories
    | FewestRepositories


type alias Language =
    String


type alias LanguageListWebData =
    WebData (List Language)


type alias Location =
    String


type alias LocationListWebData =
    WebData (List Location)



-- SERIALIZATION


languageValues : LanguageListWebData -> Maybe (List Language)
languageValues =
    RemoteData.toMaybe


languageToString : Language -> String
languageToString =
    identity


sortValues : Maybe (List Sort)
sortValues =
    Just
        [ BestMatch
        , MostFollowers
        , FewestFollowers
        , MostRecentlyJoined
        , LeastRecentlyJoined
        , MostRepositories
        , FewestRepositories
        ]


sortToString : Sort -> String
sortToString sort =
    case sort of
        BestMatch ->
            "Best match"

        MostFollowers ->
            "Most followers"

        FewestFollowers ->
            "Fewest followers"

        MostRecentlyJoined ->
            "Most recently joined"

        LeastRecentlyJoined ->
            "Least recently joined"

        MostRepositories ->
            "Most repositories"

        FewestRepositories ->
            "Fewest repositories"


locationValues : LocationListWebData -> Maybe (List Location)
locationValues =
    RemoteData.toMaybe


locationToString : Location -> String
locationToString =
    identity