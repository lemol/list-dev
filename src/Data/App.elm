port module Data.App exposing (AppData, AuthState(..), Document, User, authStateDecoder, requestLogin, requestLogout, responsive, userDecoder)

import Element exposing (Device, DeviceClass(..), Element)
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


type alias AppData =
    { auth : AuthState
    , device : Device
    }


type alias Document msg =
    { title : String
    , body : Element msg
    }



-- DECODER


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



-- UTILS


responsive : Device -> { x | phone : a, desktop : a } -> a
responsive device { phone, desktop } =
    case device.class of
        Phone ->
            phone

        _ ->
            desktop
