module Page exposing (Model, Msg, enterRoute, init, update, view)

import Element exposing (..)
import Layout.Main as Layout
import Pages.DeveloperList as DevList
import Pages.RepositoryList as RepoList
import Routing exposing (Route(..))
import Utils.Layout exposing (Document, PageConfig, mapDocument)



-- MODEL


devListPage : PageConfig DevList.Msg DevList.Model (Layout.ViewData DevList.Msg) (Layout.LayoutConfig DevList.Msg DevList.Model)
devListPage =
    { layout = Layout.config
    , update = DevList.update
    , view = DevList.view
    }


type alias Model =
    { devList : Maybe (Layout.Model DevList.Model)
    , repoList : Maybe (Layout.Model RepoList.Model)
    }


init : () -> Route -> ( Model, Cmd Msg )
init _ route =
    let
        model =
            { devList = Nothing
            , repoList = Nothing
            }
    in
    enterRoute route model



-- MESSAGE


type Msg
    = DevListMsg (Layout.Msg DevList.Msg)
    | RepoListMsg (Layout.Msg RepoList.Msg)



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        updateWith : (model -> Model) -> (msg -> Msg) -> ( model, Cmd msg ) -> ( Model, Cmd Msg )
        updateWith toModel toMsg ( subModel, subCmd ) =
            ( toModel subModel
            , Cmd.map toMsg subCmd
            )

        updatePage : (msg -> model -> ( model, Cmd msg )) -> msg -> (model -> Model) -> (msg -> Msg) -> Maybe model -> ( Model, Cmd Msg )
        updatePage updater subMsg toModel toMsg =
            Maybe.map (updater subMsg >> updateWith toModel toMsg)
                >> Maybe.withDefault ( model, Cmd.none )
    in
    case msg of
        DevListMsg subMsg ->
            updatePage
                (Layout.update DevList.update)
                subMsg
                (\newPage -> { model | devList = Just newPage })
                DevListMsg
                model.devList

        RepoListMsg subMsg ->
            updatePage
                (Layout.update RepoList.update)
                subMsg
                (\newPage -> { model | repoList = Just newPage })
                RepoListMsg
                model.repoList



-- VIEW


view : Route -> Model -> Document Msg
view route model =
    case route of
        DevListRoute ->
            viewPageOrLoading
                (Layout.view DevList.view)
                DevListMsg
                model
                .devList

        RepoListRoute ->
            viewPageOrLoading
                (Layout.view RepoList.view)
                RepoListMsg
                model
                .repoList

        NotFoundRoute ->
            Layout.notFoundView


viewPageOrLoading : (page -> Document msg) -> (msg -> Msg) -> Model -> (Model -> Maybe page) -> Document Msg
viewPageOrLoading subView toMsg model getPage =
    getPage model
        |> Maybe.map subView
        |> Maybe.map (mapDocument toMsg)
        |> Maybe.withDefault (Layout.view (always Layout.loadingView))



-- ROUTING


enterRoute : Route -> Model -> ( Model, Cmd Msg )
enterRoute route model =
    foldInit
        [ enterDevList route model
        , enterRepoList route model
        ]
        ( model, Cmd.none )


enterDevList : Route -> Model -> ( Maybe (Model -> Model), Cmd Msg )
enterDevList =
    initPage DevListRoute DevList.init DevListMsg .devList (\model page -> { model | devList = Just page })


enterRepoList : Route -> Model -> ( Maybe (Model -> Model), Cmd Msg )
enterRepoList =
    initPage RepoListRoute RepoList.init RepoListMsg .repoList (\model page -> { model | repoList = Just page })



-- UTILS


foldInit : List ( Maybe (Model -> Model), Cmd Msg ) -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
foldInit xs seed =
    let
        f ( setModel_, cmd ) acc =
            case setModel_ of
                Nothing ->
                    Tuple.mapSecond (\cmdAcc -> Cmd.batch [ cmdAcc, cmd ]) acc

                Just setModel ->
                    Tuple.mapBoth setModel (\cmdAcc -> Cmd.batch [ cmdAcc, cmd ]) acc
    in
    List.foldl f seed xs


initPage : Route -> ( model, Cmd msg ) -> (msg -> Msg) -> (Model -> Maybe model) -> (Model -> model -> Model) -> Route -> Model -> ( Maybe (Model -> Model), Cmd Msg )
initPage pageRoute pageInit toMsg getPage setModel currentRoute model =
    if pageRoute == currentRoute then
        case getPage model of
            Just _ ->
                ( Nothing, Cmd.none )

            Nothing ->
                let
                    ( initModel, initCmd ) =
                        pageInit
                in
                ( Just (\m -> setModel m initModel), Cmd.map toMsg initCmd )

    else
        ( Nothing, Cmd.none )
