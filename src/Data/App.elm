port module Data.App exposing (AuthState(..), Document, User, authStateDecoder, requestLogin, requestLogout, userDecoder)

import Element exposing (Element)
import Json.Decode as D exposing (string)



-- PORTS


port requestLogin : () -> Cmd msg


port requestLogout : () -> Cmd msg



-- DATA


type alias User =
    { name : String
    , nickname : String
    , picture : String
    }


type AuthState
    = IDLE
    | NotAuthenticated
    | Authenticated User


userDecoder : D.Decoder User
userDecoder =
    D.map3 User
        (D.field "name" string)
        (D.field "nickname" string)
        (D.field "picture" string)


authStateDecoder : D.Decoder AuthState
authStateDecoder =
    let
        notAuthenticated =
            D.null NotAuthenticated

        authenticated =
            D.map Authenticated userDecoder
    in
    D.oneOf [ notAuthenticated, authenticated ]



-- VIEW DATA


type alias Document msg =
    { title : String
    , body : Element msg
    }
