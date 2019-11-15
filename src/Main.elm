module Main exposing (main)

import Browser
import Browser.Navigation as Navigation
import Element exposing (..)
import Element.Font as Font
import Page
import Routing exposing (Route, parseUrl)
import Url
import Url.Parser exposing (map)



-- MODEL


type alias Model =
    { page : Page.Model
    , key : Navigation.Key
    }



-- MESSAGE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | PageMsg Page.Msg



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
                ( newPageModel, newPageCmd ) =
                    Page.update subMsg model.page
            in
            ( { model | page = newPageModel }
            , Cmd.map PageMsg newPageCmd
            )



-- SUBSCRIPTION


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
    let
        page =
            Page.view model.page

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
