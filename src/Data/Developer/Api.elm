module Data.Developer.Api exposing (fetchDeveloperList, fetchLanguageList)

import Data.Developer exposing (DeveloperListWebData, Language, LanguageListWebData, Sort)
import Data.Developer.Graphql as Graphql
import Data.Developer.RestApi as RestApi
import Global exposing (AuthState(..))



-- API


fetchDeveloperList : AuthState -> Maybe Sort -> Maybe Language -> (DeveloperListWebData -> msg) -> Cmd msg
fetchDeveloperList auth =
    case auth of
        Authenticated _ token ->
            Graphql.fetchDeveloperList token

        _ ->
            RestApi.fetchDeveloperList


fetchLanguageList : (LanguageListWebData -> msg) -> Cmd msg
fetchLanguageList =
    RestApi.fetchLanguageList
