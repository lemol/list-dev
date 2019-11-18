module Page exposing (Model, Msg, enterRoute, init, update, view)

import Data.App exposing (AuthState)
import Element exposing (..)
import Layout.Main as Layout
import Pages.DeveloperList as DevList
import Pages.RepositoryList as RepoList
import Routing exposing (Route(..))
import Utils.Layout as Base exposing (Document)



-- CONFIG


mainLayout : (pageMsg -> Msg) -> (Model -> Maybe pageModel) -> Layout.LayoutConfig pageMsg pageModel Msg Model
mainLayout fromPageMsg toPageModel =
    Layout.config
        { convert =
            { fromPageMsg = fromPageMsg
            , fromLayoutMsg = MainLayoutMsg
            , toPageModel = toPageModel
            , toLayoutModel = .mainLayout
            }
        , getModel = .mainLayout
        , setModel = \m p -> { m | mainLayout = Just p }
        , toMsg = MainLayoutMsg
        }


devListPage : Layout.PageConfig DevList.Msg DevList.Model Msg Model
devListPage =
    { layout = mainLayout DevListMsg .devList
    , update = DevList.update
    , view = always DevList.view
    , init = always DevList.init
    , getModel = .devList
    , setModel = \m p -> { m | devList = Just p }
    , toMsg = DevListMsg
    }


repoListPage : Layout.PageConfig RepoList.Msg RepoList.Model Msg Model
repoListPage =
    { layout = mainLayout RepoListMsg .repoList
    , update = RepoList.update
    , view = always RepoList.view
    , init = always RepoList.init
    , getModel = .repoList
    , setModel = \m p -> { m | repoList = Just p }
    , toMsg = RepoListMsg
    }



-- MODEL


type alias Model =
    { route : Route
    , mainLayout : Maybe Layout.Model
    , devList : Maybe DevList.Model
    , repoList : Maybe RepoList.Model
    }


init : () -> Route -> ( Model, Cmd Msg )
init _ route =
    let
        model =
            { route = route
            , mainLayout = Nothing
            , devList = Nothing
            , repoList = Nothing
            }
    in
    enterRoute route model



-- MESSAGE


type Msg
    = MainLayoutMsg Layout.Msg
    | DevListMsg DevList.Msg
    | RepoListMsg RepoList.Msg



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MainLayoutMsg subMsg ->
            let
                config =
                    mainLayout MainLayoutMsg (always Nothing)

                updated =
                    model.mainLayout
                        |> Maybe.map (config.update subMsg)
            in
            case updated of
                Nothing ->
                    ( model, Cmd.none )

                Just ( newLayoutModel, layoutCmd ) ->
                    ( { model | mainLayout = Just newLayoutModel }
                    , Cmd.map MainLayoutMsg layoutCmd
                    )

        DevListMsg subMsg ->
            Base.updatePage devListPage subMsg model

        RepoListMsg subMsg ->
            Base.updatePage repoListPage subMsg model



-- VIEW


view : AuthState -> Model -> Document Msg
view authState model =
    case model.route of
        DevListRoute ->
            devListPage.layout.view (always DevList.view) authState model

        RepoListRoute ->
            repoListPage.layout.view (always RepoList.view) authState model

        NotFoundRoute ->
            { title = "404", body = Element.text "Not Found" }



-- ROUTING


enterRoute : Route -> Model -> ( Model, Cmd Msg )
enterRoute route model =
    let
        ( newModel, cmd ) =
            case route of
                DevListRoute ->
                    Base.initPage devListPage model ()

                RepoListRoute ->
                    Base.initPage repoListPage model ()

                NotFoundRoute ->
                    ( model, Cmd.none )
    in
    ( { newModel
        | route = route
      }
    , cmd
    )
