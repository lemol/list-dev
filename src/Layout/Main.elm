module Layout.Main exposing (LayoutConfig, Model, Msg, ViewData, config, loadingView, notFoundView, update, view)

import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Element.Input as Input
import Html.Attributes exposing (target)
import RemoteData exposing (RemoteData(..))
import Routing exposing (Route(..))
import Utils.Layout as Layout exposing (Document)



-- DATA


type alias ViewData msg =
    { titleSection : Maybe (Element msg)
    , mainSection : Maybe (Element msg)
    , title : Maybe String
    }


type alias LayoutConfig pageMsg pageModel =
    Layout.LayoutConfig (Msg pageMsg) (Model pageModel) pageMsg pageModel (ViewData pageMsg)


config : LayoutConfig pageMsg pageModel
config =
    { notFound = notFoundView
    , loading = loadingView
    , update = update
    }



-- MODEL


type alias GlobalModel =
    {}


type alias Model pageModel =
    Layout.Model GlobalModel pageModel



-- MESSAGE


type GlobalMsg
    = Login


type alias Msg pageMsg =
    Layout.Msg GlobalMsg pageMsg



-- UPDATE


update : (pageMsg -> pageModel -> ( pageModel, Cmd pageMsg )) -> Msg pageMsg -> Model pageModel -> ( Model pageModel, Cmd (Msg pageMsg) )
update pageUpdate =
    Layout.update globalUpdate pageUpdate


globalUpdate : GlobalMsg -> GlobalModel -> ( GlobalModel, Cmd GlobalMsg )
globalUpdate msg model =
    case msg of
        Login ->
            ( model, Cmd.none )



-- VIEW


view : (pageModel -> ViewData pageMsg) -> Model pageModel -> Document (Msg pageMsg)
view =
    Layout.view globalView


globalView : ViewData pageMsg -> Model pageModel -> Document (Msg pageMsg)
globalView content _ =
    let
        title =
            Maybe.withDefault "GithubAO" content.title

        body =
            column
                [ height fill
                , width fill
                ]
                [ headerView
                , Element.map Layout.PageMsg <| Maybe.withDefault none content.titleSection
                , Element.map Layout.PageMsg <| Maybe.withDefault none content.mainSection
                ]
    in
    { title = title
    , body = body
    }


notFoundView : ViewData msg
notFoundView =
    { title = Just "404"
    , titleSection = Nothing
    , mainSection = Just (text "Not Found")
    }


loadingView : ViewData msg
loadingView =
    { title = Nothing
    , titleSection = Nothing
    , mainSection = Just (text "Loading...")
    }


headerView : Element (Msg pageMsg)
headerView =
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
                [ loginButton ]
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


loginButton : Element (Msg pageMsg)
loginButton =
    Input.button
        []
        { onPress = Just <| Layout.GlobalMsg Login
        , label = text "Sign in"
        }
