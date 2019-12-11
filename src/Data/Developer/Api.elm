module Data.Developer exposing (fetchDeveloperList, fetchLanguageList)

import Data.Developer.RestApi as RestApi
import Data.Developer exposing (Sort, Language, DeveloperListWebData, LanguageListWebData)



-- API


fetchDeveloperList : Maybe Sort -> Maybe Language -> (DeveloperListWebData -> msg) -> Cmd msg
fetchDeveloperList =
    RestApi.fetchDeveloperList


fetchLanguageList : (LanguageListWebData -> msg) -> Cmd msg
fetchLanguageList =
    RestApi.fetchLanguageList
