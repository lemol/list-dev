port module Main exposing (main)

import Browser
import Browser.Navigation as Navigation
import Data.App exposing (AuthState(..), authStateDecoder)
import Element exposing (..)
import Element.Font as Font
import Json.Decode as D
import Json.Encode as E
import Page
import Routing exposing (parseUrl)
import Url
import Url.Parser exposing (map)



-- PORTS


port setAuthState : (E.Value -> msg) -> Sub msg



-- MODEL


type alias Model =
    { page : Page.Model
    , authState : AuthState
    , key : Navigation.Key
    }



-- MESSAGE


type Msg
    = NoOp
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | PageMsg Page.Msg
    | SetAuthState AuthState



-- PROGRAM


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }


init : () -> Url.Url -> Navigation.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        route =
            parseUrl url

        ( pageModel, pageCmd ) =
            Page.init flags route

        model =
            { page = pageModel
            , authState = IDLE
            , key = key
            }
    in
    ( model
    , Cmd.batch
        [ Cmd.map PageMsg pageCmd ]
    )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Navigation.pushUrl model.key (Url.toString url)
                    )

                Browser.External href ->
                    ( model
                    , Navigation.load href
                    )

        UrlChanged url ->
            let
                route =
                    parseUrl url

                ( newPageModel, newPageCmd ) =
                    Page.enterRoute route model.page
            in
            ( { model | page = newPageModel }
            , Cmd.batch
                [ Cmd.map PageMsg newPageCmd ]
            )

        SetAuthState authState ->
            ( { model | authState = authState }
            , Cmd.none
            )

        PageMsg subMsg ->
            let
                ( newPageModel, newPageCmd ) =
                    Page.update subMsg model.page
            in
            ( { model | page = newPageModel }
            , Cmd.map PageMsg newPageCmd
            )



-- SUBSCRIPTION


subscriptions : Model -> Sub Msg
subscriptions _ =
    setAuthState (D.decodeValue authStateDecoder >> Result.map SetAuthState >> Result.withDefault NoOp)



-- VIEW


view : Model -> Browser.Document Msg
view model =
    let
        page =
            Page.view model.authState model.page

        body =
            layout
                [ Font.family mainFontFamily
                ]
                (Element.map PageMsg page.body)
    in
    { title = page.title
    , body = [ body ]
    }


mainFontFamily : List Font.Font
mainFontFamily =
    List.map Font.typeface
        [ "-apple-system"
        , "BlinkMacSystemFont"
        , "Segoe UI"
        , "Helvetica"
        , "Arial"
        , "sans-serif"
        , "Apple Color Emoji"
        , "Segoe UI Emoji"
        ]
