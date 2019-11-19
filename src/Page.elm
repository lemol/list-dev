module Page exposing (Model, Msg, enterRoute, init, update, view)

import Data.App exposing (AuthState, Document)
import Element exposing (..)
import Layout.Main as Layout
import Pages.DeveloperList as DevList
import Pages.RepositoryList as RepoList
import Routing exposing (Route(..))



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
                ( newModel, cmd ) =
                    model.mainLayout
                        |> Maybe.map (Layout.update subMsg)
                        |> Maybe.map (Tuple.mapFirst Just)
                        |> Maybe.withDefault ( Nothing, Cmd.none )
            in
            ( { model | mainLayout = newModel }
            , Cmd.map MainLayoutMsg cmd
            )

        DevListMsg subMsg ->
            let
                ( newModel, cmd ) =
                    model.devList
                        |> Maybe.map (DevList.update subMsg)
                        |> Maybe.map (Tuple.mapFirst Just)
                        |> Maybe.withDefault ( Nothing, Cmd.none )
            in
            ( { model | devList = newModel }
            , Cmd.map DevListMsg cmd
            )

        RepoListMsg subMsg ->
            let
                ( newModel, cmd ) =
                    model.repoList
                        |> Maybe.map (RepoList.update subMsg)
                        |> Maybe.map (Tuple.mapFirst Just)
                        |> Maybe.withDefault ( Nothing, Cmd.none )
            in
            ( { model | repoList = newModel }
            , Cmd.map RepoListMsg cmd
            )



-- VIEW


view : AuthState -> Model -> Document Msg
view authState model =
    let
        withMainLayout : Layout.Model -> Document Msg
        withMainLayout layoutModel =
            let
                mainLayout =
                    { toMsg = MainLayoutMsg
                    , model = layoutModel
                    , authState = authState
                    }
            in
            case model.route of
                DevListRoute ->
                    model.devList
                        |> Maybe.map
                            (DevList.view
                                { toMsg = DevListMsg }
                                mainLayout
                            )
                        |> Maybe.withDefault viewEmpty

                RepoListRoute ->
                    model.repoList
                        |> Maybe.map
                            (RepoList.view
                                { toMsg = RepoListMsg }
                                mainLayout
                            )
                        |> Maybe.withDefault viewEmpty

                NotFoundRoute ->
                    { title = "404", body = Element.text "Not Found" }
    in
    model.mainLayout
        |> Maybe.map withMainLayout
        |> Maybe.withDefault viewEmpty


viewEmpty : Document msg
viewEmpty =
    { title = "GithubAO"
    , body = Element.none
    }



-- ROUTING


enterRoute : Route -> Model -> ( Model, Cmd Msg )
enterRoute route model =
    let
        ( newModel, cmd ) =
            case route of
                DevListRoute ->
                    let
                        layout =
                            model.mainLayout
                                |> Maybe.map (\m -> ( m, Cmd.none ))
                                |> Maybe.withDefault (Layout.init ())

                        page =
                            model.devList
                                |> Maybe.map (\m -> ( m, Cmd.none ))
                                |> Maybe.withDefault DevList.init
                    in
                    ( { model
                        | mainLayout = Just <| Tuple.first layout
                        , devList = Just <| Tuple.first page
                      }
                    , Cmd.batch
                        [ Cmd.map MainLayoutMsg (Tuple.second layout)
                        , Cmd.map DevListMsg (Tuple.second page)
                        ]
                    )

                RepoListRoute ->
                    let
                        layout =
                            model.mainLayout
                                |> Maybe.map (\m -> ( m, Cmd.none ))
                                |> Maybe.withDefault (Layout.init ())

                        page =
                            model.repoList
                                |> Maybe.map (\m -> ( m, Cmd.none ))
                                |> Maybe.withDefault RepoList.init
                    in
                    ( { model
                        | mainLayout = Just <| Tuple.first layout
                        , repoList = Just <| Tuple.first page
                      }
                    , Cmd.batch
                        [ Cmd.map MainLayoutMsg (Tuple.second layout)
                        , Cmd.map RepoListMsg (Tuple.second page)
                        ]
                    )

                NotFoundRoute ->
                    ( model, Cmd.none )
    in
    ( { newModel
        | route = route
      }
    , cmd
    )
