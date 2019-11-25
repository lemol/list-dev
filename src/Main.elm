module Main exposing (main)

import Browser
import Browser.Navigation as Navigation
import Element exposing (..)
import Element.Font as Font
import Global
import Page
import Routing exposing (parseUrl)
import UI.Modal as Modal
import Url
import Url.Parser exposing (map)



-- MODEL


type alias Model =
    { page : Page.Model
    , global : Global.Model
    , key : Navigation.Key
    }


type alias Flags =
    Global.Flags



-- MESSAGE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | PageMsg Page.Msg
    | GlobalMsg Global.Msg



-- PROGRAM


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }


init : Flags -> Url.Url -> Navigation.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        route =
            parseUrl url

        ( pageModel, pageCmd ) =
            Page.init () route

        ( globalModel, globalCmd ) =
            Global.init flags

        model =
            { page = pageModel
            , global = globalModel
            , key = key
            }
    in
    ( model
    , Cmd.batch
        [ Cmd.map PageMsg pageCmd
        , Cmd.map GlobalMsg globalCmd
        ]
    )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
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

        PageMsg subMsg ->
            let
                ( newPageModel, newPageCmd, globalMsg_ ) =
                    Page.update subMsg model.page

                pageUpdated =
                    { model | page = newPageModel }

                ( newModel, newCmd ) =
                    case globalMsg_ of
                        Nothing ->
                            ( pageUpdated, Cmd.none )

                        Just globalMsg ->
                            update (GlobalMsg globalMsg) pageUpdated
            in
            ( newModel
            , Cmd.batch
                [ Cmd.map PageMsg newPageCmd
                , newCmd
                ]
            )

        GlobalMsg subMsg ->
            let
                ( newGlobalModel, newGlobalCmd ) =
                    Global.update subMsg model.global
            in
            ( { model | global = newGlobalModel }
            , Cmd.map GlobalMsg newGlobalCmd
            )



-- SUBSCRIPTION


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map GlobalMsg (Global.subscriptions model.global)
        ]



-- VIEW


view : Model -> Browser.Document Msg
view model =
    let
        page =
            Page.view model.global model.page

        body =
            layout
                [ Font.family mainFontFamily
                , width fill
                , height fill
                , inFront (Modal.view model.global.modal)
                    |> Element.mapAttribute (Global.ModalMsg >> GlobalMsg)
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
