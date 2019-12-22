module Layout.Trending exposing (Model, Msg, PageConfig, TrendingPage(..), ViewData, init, update, view)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Global
import Layout.Main as MainLayout
import Routing exposing (Route(..), toUrl)
import UI exposing (Document)
import UI.Areas as Areas



-- DATA


type TrendingPage
    = Repositories
    | Developers


type alias ViewData msg =
    { title : String
    , subTitle : String
    , page : TrendingPage
    , filter : Maybe (Element msg)
    , body : Element msg
    }


type alias PageConfig msg =
    { toMsg : Msg -> msg
    , mainLayoutToMsg : MainLayout.Msg -> msg
    , page : ViewData msg
    }



-- MODEL


type alias Model =
    {}



-- MESSAGE


type alias Msg =
    {}



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update _ model =
    ( model, Cmd.none )


init : ( Model, Cmd Msg )
init =
    ( {}, Cmd.none )



-- VIEWS


view : PageConfig msg -> MainLayout.Model -> Global.Model -> Model -> Document msg
view config layoutModel global model =
    MainLayout.view
        { toMsg = config.mainLayoutToMsg
        , content = viewContent config global model
        }
        global
        layoutModel


viewContent : PageConfig msg -> Global.Model -> Model -> MainLayout.ViewData msg
viewContent config { device, location } _ =
    { title =
        Just <|
            "Trending "
                ++ config.page.title
                ++ (location
                        |> Maybe.map ((++) " based in ")
                        |> Maybe.withDefault ""
                   )
    , top = Just <| headerView config
    , main = Just <| mainSectionView config device
    }


headerView : PageConfig msg -> Element msg
headerView config =
    Areas.headerView
        { title = config.page.title
        , subTitle = Just config.page.subTitle
        }


mainSectionView : PageConfig msg -> Device -> Element msg
mainSectionView config device =
    let
        header =
            wrappedRow
                [ centerY, width fill, spacingXY 0 12 ]
                [ navigationButtons config
                , Maybe.withDefault none config.page.filter
                ]

        body =
            config.page.body
    in
    Areas.boxView
        { header = header
        , body = body
        , device = device
        }


navigationButtons : PageConfig msg -> Element msg
navigationButtons config =
    let
        repoAttrs =
            case config.page.page of
                Repositories ->
                    [ Font.color <| rgb255 255 255 255
                    , Border.color <| rgb255 225 228 232
                    , Background.color <| rgb255 3 102 214
                    ]

                _ ->
                    [ Font.color <| rgb255 88 96 105
                    , Border.color <| rgb255 225 228 232
                    ]

        devAttrs =
            case config.page.page of
                Developers ->
                    [ Font.color <| rgb255 255 255 255
                    , Border.color <| rgb255 225 228 232
                    , Background.color <| rgb255 3 102 214
                    ]

                _ ->
                    [ Font.color <| rgb255 88 96 105
                    , Border.color <| rgb255 225 228 232
                    ]

        buttonAttrs =
            [ centerX
            , centerY
            , height fill
            , width fill
            , paddingXY 14 6
            ]
    in
    row
        [ height <| px 34
        , Font.size 14
        , Font.semiBold
        ]
        [ link
            ([ Border.widthEach { top = 1, bottom = 1, left = 1, right = 0 }
             , Border.roundEach { topLeft = 3, bottomLeft = 3, topRight = 0, bottomRight = 0 }
             ]
                ++ repoAttrs
                ++ buttonAttrs
            )
            { url = toUrl RepoListRoute, label = el [ centerY ] (text "Repositories") }
        , link
            ([ Border.widthEach { top = 1, bottom = 1, left = 0, right = 1 }
             , Border.roundEach { topLeft = 0, bottomLeft = 0, topRight = 3, bottomRight = 3 }
             ]
                ++ devAttrs
                ++ buttonAttrs
            )
            { url = toUrl DevListRoute, label = el [ centerY ] (text "Developers") }
        ]
