module DeveloperTrending.Data exposing (..)

import Http
import Json.Decode as Decode
import RemoteData exposing (RemoteData(..), WebData)
import Utils.ListDropdown exposing (DropdownModel, DropdownMsg, initListDropdown)



-- MODEL


type alias Model =
    { users : WebData (List User)
    , usersSort : UsersSort
    , sortDropdown : DropdownModel
    }


type alias User =
    { login : String
    , name : String
    , avatar : String
    , url : String
    , htmlUrl : String
    }


type UsersSort
    = BestMatch
    | MostFollowers
    | FewestFollowers
    | MostRecentlyJoined
    | LeastRecentlyJoined
    | MostRepositories
    | FewestRepositories


init : ( Model, Cmd Msg )
init =
    ( { users = Loading
      , usersSort = BestMatch
      , sortDropdown = initListDropdown
      }
    , fetchUsers BestMatch
    )



-- MESSAGE


type Msg
    = FetchUsersResponse (WebData (List User))
    | FetchUsers
    | ChangeUsersSort UsersSort
    | SortDropdownMsg DropdownMsg



-- SERIALIZATION


userDecoder : Decode.Decoder User
userDecoder =
    Decode.map5 User
        (Decode.field "login" Decode.string)
        (Decode.field "login" Decode.string)
        (Decode.field "avatar_url" Decode.string)
        (Decode.field "url" Decode.string)
        (Decode.field "html_url" Decode.string)


usersDecoder : Decode.Decoder (List User)
usersDecoder =
    Decode.field "items" (Decode.list userDecoder)



-- API


sortToQueryString : UsersSort -> String
sortToQueryString sort =
    case sort of
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


fetchUsers : UsersSort -> Cmd Msg
fetchUsers sort =
    let
        usersUrl =
            "https://api.github.com/search/users?q=location:Angola+location:luanda&per_page=20&" ++ sortToQueryString sort
    in
    Http.get
        { url = usersUrl
        , expect = Http.expectJson (RemoteData.fromResult >> FetchUsersResponse) usersDecoder
        }
