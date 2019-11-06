module Main exposing (main)

import Browser
import Browser.Navigation as Navigation
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Html.Attributes exposing (target)
import Page.DeveloperList as DevList
import Url
import Url.Parser as Parser exposing (Parser, map, oneOf, s, top)



-- MODEL


type Page
    = NotFound
    | DeveloperListPage


type alias Model =
    { devListPage : DevList.Model
    , page : Page
    , key : Navigation.Key
    }



-- MESSAGE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | DevListMsg DevList.Msg



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
init _ url key =
    let
        ( page, cmd ) =
            updateUrl url NotFound

        model =
            { devListPage = Tuple.first DevList.init
            , page = page
            , key = key
            }
    in
    ( model
    , cmd
    )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        updateWith toModel toMsg ( subModel, subCmd ) =
            ( toModel subModel
            , Cmd.map toMsg subCmd
            )
    in
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
                ( newPage, cmd ) =
                    updateUrl url model.page
            in
            ( { model | page = newPage }
            , cmd
            )

        DevListMsg subMsg ->
            DevList.update subMsg model.devListPage
                |> updateWith (\newPage -> { model | devListPage = newPage }) DevListMsg



-- SUBSCRIPTION


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
    let
        ( headerTitle, mainSection ) =
            case model.page of
                DeveloperListPage ->
                    ( Element.map DevListMsg <| DevList.headerTitleView
                    , Element.map DevListMsg <| DevList.mainSectionView model.devListPage
                    )

                NotFound ->
                    ( text "404", text "NotFound" )

        body =
            layout
                [ Font.family mainFontFamily
                ]
            <|
                column
                    [ height fill
                    , width fill
                    ]
                    [ headerBar
                    , headerTitle
                    , mainSection
                    ]
    in
    { title = "GithubAO"
    , body = [ body ]
    }


headerBar : Element msg
headerBar =
    let
        logo =
            el
                [ Font.bold
                , Font.color <| rgb255 255 255 255
                ]
                (text "GithubAO")

        leftContent =
            row
                [ spacing 16 ]
                [ logo
                , menuView
                ]

        rightContent =
            row
                [ alignRight ]
                [ text "" ]
    in
    el
        [ width fill
        , height <| px 64
        , Background.color <| rgb255 36 41 46
        ]
    <|
        row
            [ centerY
            , padding 16
            , height fill
            , width fill
            ]
            [ leftContent
            , rightContent
            ]


menuView : Element msg
menuView =
    let
        menuItem url label =
            link
                [ Font.size 14
                , Font.color <| rgb255 0xFF 0xFF 0xFF
                , Font.bold
                , htmlAttribute <| target "_blank"
                , mouseOver
                    [ Font.color <| rgba255 0xFF 0xFF 0xFF 0.7 ]
                ]
                { url = url
                , label = text label
                }
    in
    row
        []
        [ menuItem "https://github.com/lemol/github-ao-elm" "Source code"
        ]


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



-- ROUTING


updateUrl : Url.Url -> Page -> ( Page, Cmd Msg )
updateUrl url page =
    let
        parser =
            oneOf
                [ route top
                    ( DeveloperListPage, Cmd.map DevListMsg <| Tuple.second DevList.init )
                , route (s "developers")
                    ( DeveloperListPage, Cmd.map DevListMsg <| Tuple.second DevList.init )
                , route (s "repositories")
                    ( NotFound, Cmd.none )
                ]

        result =
            Parser.parse parser url
                |> Maybe.withDefault ( NotFound, Cmd.none )
    in
    if Tuple.first result == page then
        Tuple.mapSecond (always Cmd.none) result

    else
        result


route : Parser a b -> a -> Parser (b -> c) c
route parser handler =
    Parser.map handler parser
