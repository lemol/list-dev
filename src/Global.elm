port module Global exposing (..)

import Browser.Events
import Element exposing (Device, classifyDevice)
import Json.Decode as D exposing (string)
import Json.Encode as E
import UI.Modal as Modal



-- PORTS


port requestLogin : () -> Cmd msg


port requestLogout : () -> Cmd msg


port setAuthState : (E.Value -> msg) -> Sub msg



-- DATA


type alias User =
    { name : String
    , nickname : String
    , picture : String
    }

type alias AccessToken =
    String

type AuthState
    = IDLE
    | NotAuthenticated
    | Authenticated User AccessToken



-- MODEL


type alias Model =
    { modal : Modal.Model
    , device : Device
    , auth : AuthState
    }


type alias Flags =
    { width : Int
    , height : Int
    }



-- MESSAGES


type Msg
    = NoOp
    | SetAuth AuthState
    | WindowResized Int Int
    | ModalMsg Modal.Msg



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        SetAuth auth ->
            ( { model | auth = auth }
            , Cmd.none
            )

        WindowResized width height ->
            ( { model | device = mkDevice width height }
            , Cmd.none
            )

        ModalMsg subMsg ->
            let
                ( newModal, newCmd ) =
                    Modal.update subMsg model.modal
            in
            ( { model
                | modal = newModal
              }
            , Cmd.map ModalMsg newCmd
            )


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        ( modalModel, modalCmd ) =
            Modal.init

        device =
            mkDevice flags.width flags.height
    in
    ( { modal = modalModel
      , device = device
      , auth = IDLE
      }
    , Cmd.batch
        [ Cmd.map ModalMsg modalCmd ]
    )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ setAuthState (D.decodeValue authStateDecoder >> Result.map SetAuth >> Result.withDefault NoOp)
        , Browser.Events.onResize WindowResized
        ]



-- UTILS


withNoGlobal : (msg -> model -> ( model, Cmd msg, Maybe Msg )) -> (msg -> model -> ( model, Cmd msg ))
withNoGlobal updateOriginal =
    \msg model ->
        let
            ( model1, cmd1, _ ) =
                updateOriginal msg model
        in
        ( model1, cmd1 )


withNoOp : ( model, Cmd msg ) -> ( model, Cmd msg, Maybe Msg )
withNoOp ( model, cmd ) =
    ( model, cmd, Nothing )


withMsg : Msg -> ( model, Cmd msg ) -> ( model, Cmd msg, Maybe Msg )
withMsg msg ( model, cmd ) =
    ( model, cmd, Just msg )


mkDevice : Int -> Int -> Device
mkDevice width height =
    classifyDevice
        { width = width
        , height = height
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
            D.map2 Authenticated userDecoder (D.field "accessToken" string)
    in
    D.oneOf [ notAuthenticated, authenticated ]
