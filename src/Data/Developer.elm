module Data.Developer exposing (Developer, DeveloperListWebData, Sort(..), fetchDeveloperList)

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



-- SERIALIZATION


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
            "order=desc"

        MostFollowers ->
            "order=desc&sort=followers"

        FewestFollowers ->
            "order=asc&sort=followers"

        MostRecentlyJoined ->
            "order=desc&sort=joined"

        LeastRecentlyJoined ->
            "order=asc&sort=joined"

        MostRepositories ->
            "order=desc&sort=repositories"

        FewestRepositories ->
            "order=asc&sort=repositories"


fetchDeveloperList : Sort -> (WebData (List Developer) -> msg) -> Cmd msg
fetchDeveloperList sortBy toMsg =
    let
        usersUrl =
            "https://api.github.com/search/users?q=location:Angola+type:user&per_page=20&" ++ sortToQueryString sortBy
    in
    Http.get
        { url = usersUrl
        , expect = Http.expectJson (RemoteData.fromResult >> toMsg) developerListDecoder
        }
