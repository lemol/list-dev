module Data.Developer.Api exposing (fetchDeveloperList, fetchLanguageList, fetchLocationList)

import Data.Developer exposing (DeveloperListWebData, Location, Language, LanguageListWebData, LocationListWebData, Sort)
import Data.Developer.Graphql as Graphql
import Data.Developer.RestApi as RestApi
import Global exposing (AuthState(..))



-- API


fetchDeveloperList : AuthState -> Maybe Location -> Maybe Sort -> Maybe Language -> (DeveloperListWebData -> msg) -> Cmd msg
fetchDeveloperList auth =
    case auth of
        Authenticated _ token ->
            Graphql.fetchDeveloperList token

        _ ->
            RestApi.fetchDeveloperList


fetchLanguageList : (LanguageListWebData -> msg) -> Cmd msg
fetchLanguageList =
    RestApi.fetchLanguageList


fetchLocationList : (LocationListWebData -> msg) -> Cmd msg
fetchLocationList =
    RestApi.fetchLocationList
