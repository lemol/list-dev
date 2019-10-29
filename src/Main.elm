module Main exposing (main)

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Html exposing (Html)
import Html.Attributes exposing (target)
import Page.DeveloperList as DevList
import RemoteData exposing (RemoteData(..))



-- MODEL


type Page
    = DeveloperListPage


type alias Model =
    { devListPage : DevList.Model
    , page : Page
    }


init : ( Model, Cmd Msg )
init =
    ( { devListPage = Tuple.first DevList.init
      , page = DeveloperListPage
      }
    , Cmd.batch
        [ Cmd.map DevListMsg <| Tuple.second DevList.init ]
    )



-- MESSAGE


type Msg
    = DevListMsg DevList.Msg



-- PROGRAM


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


main : Program () Model Msg
main =
    Browser.element
        { init = always init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



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
        DevListMsg subMsg ->
            DevList.update subMsg model.devListPage
                |> updateWith (\newPage -> { model | devListPage = newPage }) DevListMsg



-- VIEW


view : Model -> Html Msg
view model =
    let
        ( headerTitle, mainSection ) =
            case model.page of
                DeveloperListPage ->
                    ( Element.map DevListMsg <| DevList.headerTitleView
                    , Element.map DevListMsg <| DevList.mainSectionView model.devListPage
                    )
    in
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


headerBar : Element msg
headerBar =
    let
        logo =
            el
                [ Font.bold
                , Font.color <| rgb255 255 255 255
                ]
                (text "AoG")

        leftContent =
            row
                [ spacing 16 ]
                [ logo
                , menuView
                ]

        rightContent =
            row
                [ alignRight ]
                [ text "AVATAR" ]
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
        [ menuItem "https://github.com/lemol/angolans-on-github-elm" "Source code"
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
