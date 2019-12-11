module Data.Developer exposing (Developer, DeveloperListWebData, Language, LanguageListWebData, Sort(..), languageToString, languageValues, sortToString, sortValues)

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


type alias DeveloperListWebData =
    WebData (List Developer)


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
