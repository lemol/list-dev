module Data.Developer.Api exposing (fetchDeveloperList, fetchLanguageList)

import Data.Developer exposing (DeveloperListWebData, Language, LanguageListWebData, Sort)
import Data.Developer.RestApi as RestApi



-- API


fetchDeveloperList : Maybe Sort -> Maybe Language -> (DeveloperListWebData -> msg) -> Cmd msg
fetchDeveloperList =
    RestApi.fetchDeveloperList


fetchLanguageList : (LanguageListWebData -> msg) -> Cmd msg
fetchLanguageList =
    RestApi.fetchLanguageList
