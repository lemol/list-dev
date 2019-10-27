module Data.Developer exposing (Developer, DeveloperListWebData, LanguageFilter, Sort(..), fetchDeveloperList, languageToString, languageValues, sortToString, sortValues)

import Http
import Json.Decode as Decode
import RemoteData exposing (RemoteData(..), WebData)



-- TYPES


type alias Developer =
    { login : String
    , name : String
    , avatar : String
    , url : String
    , htmlUrl : String
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


type alias LanguageFilter =
    Maybe String



-- SERIALIZATION


languageValues : List LanguageFilter
languageValues =
    List.map Just
        [ "C#"
        , "Elm"
        , "Haskell"
        , "Javascript"
        , "PHP"
        , "Python"
        , "Ruby"
        , "Typescript"
        ]


languageToString : LanguageFilter -> String
languageToString =
    Maybe.withDefault "Any"


sortValues : List Sort
sortValues =
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


developerDecoder : Decode.Decoder Developer
developerDecoder =
    Decode.map5 Developer
        (Decode.field "login" Decode.string)
        (Decode.field "login" Decode.string)
        (Decode.field "avatar_url" Decode.string)
        (Decode.field "url" Decode.string)
        (Decode.field "html_url" Decode.string)


developerListDecoder : Decode.Decoder (List Developer)
developerListDecoder =
    Decode.field "items" (Decode.list developerDecoder)



-- API


sortToQueryString : Sort -> String
sortToQueryString sortBy =
    case sortBy of
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


languageFilterToQueryString : LanguageFilter -> String
languageFilterToQueryString filter =
    case filter of
        Nothing ->
            ""

        Just str ->
            "+language:" ++ str


fetchDeveloperList : Sort -> LanguageFilter -> (WebData (List Developer) -> msg) -> Cmd msg
fetchDeveloperList sortBy languageFilter toMsg =
    let
        usersUrl =
            "https://api.github.com/search/users?q=location:Angola+type:user"
                ++ languageFilterToQueryString languageFilter
                ++ sortToQueryString sortBy
                ++ "&per_page=20"
    in
    Http.get
        { url = usersUrl
        , expect = Http.expectJson (RemoteData.fromResult >> toMsg) developerListDecoder
        }
