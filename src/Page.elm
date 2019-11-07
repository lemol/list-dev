module Page exposing (Model, Msg, enterRoute, init, update, view)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Html.Attributes exposing (target)
import Page.DeveloperList as DevList
import Page.RepositoryList as RepoList
import Routing exposing (Route(..))



-- MODEL


type alias Model =
    { devList : Maybe DevList.Model
    , repoList : Maybe RepoList.Model
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
    = NoOp
    | DevListMsg DevList.Msg
    | RepoListMsg RepoList.Msg



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
        NoOp ->
            ( model, Cmd.none )

        DevListMsg subMsg ->
            updatePage
                DevList.update
                subMsg
                (\newPage -> { model | devList = Just newPage })
                DevListMsg
                model.devList

        RepoListMsg subMsg ->
            updatePage
                RepoList.update
                subMsg
                (\newPage -> { model | repoList = Just newPage })
                RepoListMsg
                model.repoList



-- VIEW


type alias Document msg =
    { title : String
    , body : Element msg
    }


view : Route -> Model -> Document Msg
view route model =
    let
        ( headerTitle, mainSection ) =
            case route of
                DevListRoute ->
                    ( Element.map DevListMsg <| DevList.headerTitleView
                    , Element.map DevListMsg <| Maybe.withDefault none <| Maybe.map DevList.mainSectionView model.devList
                    )

                RepoListRoute ->
                    ( Element.map RepoListMsg <| RepoList.headerTitleView
                    , Element.map RepoListMsg <| Maybe.withDefault none <| Maybe.map RepoList.mainSectionView model.repoList
                    )

                NotFoundRoute ->
                    ( text "404", text "NotFound" )

        body =
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
    , body = body
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
