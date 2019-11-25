module Page exposing (Model, Msg, enterRoute, init, update, view)

import Element exposing (..)
import Global
import Layout.Main as MainLayout
import Layout.Trending as TrendingLayout
import Pages.DeveloperList as DevList
import Pages.RepositoryList as RepoList
import Routing exposing (Route(..))
import UI exposing (Document)



-- MODEL


type alias Model =
    { route : Route
    , mainLayout : Maybe MainLayout.Model
    , trendingLayout : Maybe TrendingLayout.Model
    , devList : Maybe DevList.Model
    , repoList : Maybe RepoList.Model
    }


init : () -> Route -> ( Model, Cmd Msg )
init _ route =
    let
        model =
            { route = route
            , mainLayout = Nothing
            , trendingLayout = Nothing
            , devList = Nothing
            , repoList = Nothing
            }
    in
    enterRoute route model



-- MESSAGE


type Msg
    = MainLayoutMsg MainLayout.Msg
    | TrendingLayoutMsg TrendingLayout.Msg
    | DevListMsg DevList.Msg
    | RepoListMsg RepoList.Msg



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg, Maybe Global.Msg )
update msg model =
    case msg of
        MainLayoutMsg subMsg ->
            let
                ( newModel, cmd ) =
                    model.mainLayout
                        |> Maybe.map (MainLayout.update subMsg)
                        |> Maybe.map (Tuple.mapFirst Just)
                        |> Maybe.withDefault ( Nothing, Cmd.none )
            in
            ( { model | mainLayout = newModel }
            , Cmd.map MainLayoutMsg cmd
            , Nothing
            )

        TrendingLayoutMsg subMsg ->
            let
                ( newModel, cmd ) =
                    model.trendingLayout
                        |> Maybe.map (TrendingLayout.update subMsg)
                        |> Maybe.map (Tuple.mapFirst Just)
                        |> Maybe.withDefault ( Nothing, Cmd.none )
            in
            ( { model | trendingLayout = newModel }
            , Cmd.map TrendingLayoutMsg cmd
            , Nothing
            )

        DevListMsg subMsg ->
            let
                ( newModel, cmd, globalMsg ) =
                    model.devList
                        |> Maybe.map (DevList.update subMsg)
                        |> Maybe.map (mapFirst Just)
                        |> Maybe.withDefault ( Nothing, Cmd.none, Nothing )
            in
            ( { model | devList = newModel }
            , Cmd.map DevListMsg cmd
            , globalMsg
            )

        RepoListMsg subMsg ->
            let
                ( newModel, cmd, globalMsg ) =
                    model.repoList
                        |> Maybe.map (RepoList.update subMsg)
                        |> Maybe.map (mapFirst Just)
                        |> Maybe.withDefault ( Nothing, Cmd.none, Nothing )
            in
            ( { model | repoList = newModel }
            , Cmd.map RepoListMsg cmd
            , globalMsg
            )



-- VIEW


view : Global.Model -> Model -> Document Msg
view global model =
    let
        withTrendingLayout : Maybe MainLayout.Model -> Maybe TrendingLayout.Model -> (MainLayout.Model -> TrendingLayout.Model -> Document Msg) -> Document Msg
        withTrendingLayout mainLayoutModel_ trendingLayoutModel_ build =
            case ( mainLayoutModel_, trendingLayoutModel_ ) of
                ( Nothing, _ ) ->
                    viewEmpty

                ( _, Nothing ) ->
                    viewEmpty

                ( Just mainLayoutModel, Just trendingLayoutModel ) ->
                    build
                        mainLayoutModel
                        trendingLayoutModel
    in
    case model.route of
        DevListRoute ->
            withTrendingLayout
                model.mainLayout
                model.trendingLayout
                (\mainLayout trendingLayout ->
                    model.devList
                        |> Maybe.map
                            (DevList.view
                                { toMsg = DevListMsg
                                , layoutToMsg = TrendingLayoutMsg
                                , mainLayoutToMsg = MainLayoutMsg
                                }
                                mainLayout
                                trendingLayout
                                global
                            )
                        |> Maybe.withDefault viewEmpty
                )

        RepoListRoute ->
            withTrendingLayout
                model.mainLayout
                model.trendingLayout
                (\mainLayout trendingLayout ->
                    model.repoList
                        |> Maybe.map
                            (RepoList.view
                                { toMsg = RepoListMsg
                                , layoutToMsg = TrendingLayoutMsg
                                , mainLayoutToMsg = MainLayoutMsg
                                }
                                mainLayout
                                trendingLayout
                                global
                            )
                        |> Maybe.withDefault viewEmpty
                )

        NotFoundRoute ->
            { title = "404", body = Element.text "Not Found" }


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
                        mainLayout =
                            model.mainLayout
                                |> Maybe.map (\m -> ( m, Cmd.none ))
                                |> Maybe.withDefault (MainLayout.init ())

                        trendingLayout =
                            model.trendingLayout
                                |> Maybe.map (\m -> ( m, Cmd.none ))
                                |> Maybe.withDefault TrendingLayout.init

                        page =
                            model.devList
                                |> Maybe.map (\m -> ( m, Cmd.none ))
                                |> Maybe.withDefault DevList.init
                    in
                    ( { model
                        | mainLayout = Just <| Tuple.first mainLayout
                        , trendingLayout = Just <| Tuple.first trendingLayout
                        , devList = Just <| Tuple.first page
                      }
                    , Cmd.batch
                        [ Cmd.map MainLayoutMsg (Tuple.second mainLayout)
                        , Cmd.map TrendingLayoutMsg (Tuple.second trendingLayout)
                        , Cmd.map DevListMsg (Tuple.second page)
                        ]
                    )

                RepoListRoute ->
                    let
                        mainLayout =
                            model.mainLayout
                                |> Maybe.map (\m -> ( m, Cmd.none ))
                                |> Maybe.withDefault (MainLayout.init ())

                        trendingLayout =
                            model.trendingLayout
                                |> Maybe.map (\m -> ( m, Cmd.none ))
                                |> Maybe.withDefault TrendingLayout.init

                        page =
                            model.repoList
                                |> Maybe.map (\m -> ( m, Cmd.none ))
                                |> Maybe.withDefault RepoList.init
                    in
                    ( { model
                        | mainLayout = Just <| Tuple.first mainLayout
                        , trendingLayout = Just <| Tuple.first trendingLayout
                        , repoList = Just <| Tuple.first page
                      }
                    , Cmd.batch
                        [ Cmd.map MainLayoutMsg (Tuple.second mainLayout)
                        , Cmd.map TrendingLayoutMsg (Tuple.second trendingLayout)
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



-- UTILS


mapFirst : (a -> d) -> ( a, b, c ) -> ( d, b, c )
mapFirst f ( a, b, c ) =
    ( f a, b, c )
