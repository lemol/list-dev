module Data.Developer exposing (Developer, DeveloperListWebData, Language, LanguageListWebData, Sort(..), fetchDeveloperList, fetchLanguageList, languageToString, languageValues, sortToString, sortValues)

import Http
import Json.Decode as Decode
import RemoteData exposing (RemoteData(..), WebData)



-- TYPES


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


developerDecoder : Decode.Decoder Developer
developerDecoder =
    Decode.map6 Developer
        (Decode.field "login" Decode.string)
        (Decode.field "login" Decode.string)
        (Decode.field "avatar_url" Decode.string)
        (Decode.field "url" Decode.string)
        (Decode.field "html_url" Decode.string)
        (Decode.succeed Nothing)


developerListDecoder : Decode.Decoder (List Developer)
developerListDecoder =
    Decode.field "items" (Decode.list developerDecoder)


languageDecoder : Decode.Decoder Language
languageDecoder =
    Decode.field "name" Decode.string


languageListDecoder : Decode.Decoder (List Language)
languageListDecoder =
    Decode.list languageDecoder



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
            "+language:" ++ str


fetchDeveloperList : Maybe Sort -> Maybe Language -> (DeveloperListWebData -> msg) -> Cmd msg
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


fetchLanguageList : (LanguageListWebData -> msg) -> Cmd msg
fetchLanguageList toMsg =
    Http.get
        { url = "languages.json"
        , expect = Http.expectJson (RemoteData.fromResult >> toMsg) languageListDecoder
        }
