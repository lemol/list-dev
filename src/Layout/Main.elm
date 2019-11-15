module Layout.Main exposing (LayoutConfig, Model, Msg, PageConfig, ViewData, config, init, map, update, view)

import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Html.Attributes exposing (target)
import RemoteData exposing (RemoteData(..))
import Routing exposing (Route(..))
import Utils.Base as Base exposing (Document, mapDocument)



-- DATA


type alias ViewData pageMsg =
    { titleSection : Maybe (Element pageMsg)
    , mainSection : Maybe (Element pageMsg)
    , title : Maybe String
    }


type alias LayoutConfig pageMsg pageModel msg model =
    Base.LayoutConfig (ViewData pageMsg) Msg Model pageModel msg model


type alias PageConfig pageMsg pageModel msg model =
    Base.PageConfig (ViewData pageMsg) Msg Model pageMsg pageModel msg model


type alias Convert pageMsg pageModel msg model =
    Base.Convert Msg Model pageMsg pageModel msg model


type alias Options pageMsg pageModel msg model =
    { convert : Convert pageMsg pageModel msg model
    , getModel : model -> Maybe Model
    , setModel : model -> Model -> model
    , toMsg : Msg -> msg
    }


config : Options pageMsg pageModel msg model -> LayoutConfig pageMsg pageModel msg model
config options =
    { view = view options.convert
    , update = update
    , init = init
    , getModel = options.getModel
    , setModel = options.setModel
    , toMsg = options.toMsg
    }



-- MODEL


type alias Model =
    {}


init : () -> ( Model, Cmd Msg )
init _ =
    ( {}, Cmd.none )



-- MESSAGE


type Msg
    = NoOp



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



-- VIEWS


unflatMaybe : Maybe (Maybe a) -> Maybe a
unflatMaybe =
    Maybe.withDefault Nothing


view : Convert pageMsg pageModel msg model -> Base.PageView (ViewData pageMsg) pageModel -> model -> Document msg
view convert pageView model =
    let
        content =
            convert.toPageModel model
                |> Maybe.map pageView

        title =
            content
                |> Maybe.map (\c -> Maybe.withDefault "GithubAO" c.title)
                |> Maybe.withDefault "GithubAO"

        body =
            column
                [ height fill
                , width fill
                ]
                [ headerView
                , content
                    |> Maybe.map .titleSection
                    |> unflatMaybe
                    |> Maybe.withDefault none
                    |> Element.map convert.fromPageMsg
                , content
                    |> Maybe.map .mainSection
                    |> unflatMaybe
                    |> Maybe.withDefault none
                    |> Element.map convert.fromPageMsg
                ]
    in
    { title = title
    , body = body
    }


map : (msg1 -> msg2) -> Document msg1 -> Document msg2
map f x =
    { title = x.title
    , body = Element.map f x.body
    }


headerView : Element msg
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
