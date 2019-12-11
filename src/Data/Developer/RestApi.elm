module Data.Developer.RestApi exposing (DeveloperListWebData, fetchDeveloperList, fetchLanguageList)

import Http
import Json.Decode as Decode
import RemoteData exposing (RemoteData(..), WebData)
import Url exposing (percentEncode)
import Data.Developer exposing (Developer, Sort(..), Language)

-- TYPES



type alias DeveloperListWebData =
    WebData (List Developer)



-- SERIALIZATION


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
            "+language:" ++ percentEncode str


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
