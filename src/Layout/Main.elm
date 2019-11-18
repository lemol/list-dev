module Layout.Main exposing (LayoutConfig, Model, Msg, PageConfig, ViewData, config, init, update, view)

import Data.App as App exposing (AuthState(..), User)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Element.Input as Input
import Html
import Html.Attributes exposing (src, style, target)
import RemoteData exposing (RemoteData(..))
import Routing exposing (Route(..))
import Utils.Base as Base exposing (Document)



-- DATA


type alias ViewData pageMsg =
    { titleSection : Maybe (Element pageMsg)
    , mainSection : Maybe (Element pageMsg)
    , title : Maybe String
    }


type alias PageView pageMsg pageModel =
    Base.PageView (ViewData pageMsg) AuthState pageModel


type alias LayoutConfig pageMsg pageModel msg model =
    Base.LayoutConfig (ViewData pageMsg) AuthState Msg Model pageModel msg model


type alias PageConfig pageMsg pageModel msg model =
    Base.PageConfig (ViewData pageMsg) AuthState Msg Model pageMsg pageModel msg model


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
    { userMenuOpen : Bool }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { userMenuOpen = False }, Cmd.none )



-- MESSAGE


type Msg
    = Login
    | Logout
    | ToggleUserMenu Bool



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Login ->
            ( model, App.requestLogin () )

        Logout ->
            ( model, App.requestLogout () )

        ToggleUserMenu open ->
            ( { model | userMenuOpen = open }, Cmd.none )



-- VIEWS


unflatMaybe : Maybe (Maybe a) -> Maybe a
unflatMaybe =
    Maybe.withDefault Nothing


view : Convert pageMsg pageModel msg model -> PageView pageMsg pageModel -> AuthState -> model -> Document msg
view convert pageView authState model =
    let
        content =
            convert.toPageModel model
                |> Maybe.map (pageView authState)

        title =
            content
                |> Maybe.map (\c -> Maybe.withDefault "GithubAO" c.title)
                |> Maybe.withDefault "GithubAO"

        body =
            column
                [ height fill
                , width fill
                ]
                [ convert.toLayoutModel model
                    |> Maybe.map
                        (\m ->
                            headerView m.userMenuOpen authState
                        )
                    |> Maybe.withDefault none
                    |> Element.map convert.fromLayoutMsg
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


headerView : Bool -> AuthState -> Element Msg
headerView open authState =
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

        right =
            el
                [ alignRight ]
                (rightContent open authState)
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
            , right
            ]


rightContent : Bool -> AuthState -> Element Msg
rightContent open authState =
    case authState of
        IDLE ->
            Element.none

        NotAuthenticated ->
            signInButton

        Authenticated user ->
            userAvatar open user


userAvatar : Bool -> User -> Element Msg
userAvatar open user =
    Input.button
        [ if open then
            below (userMenu user)

          else
            below Element.none
        , Events.onLoseFocus (ToggleUserMenu False)
        , focused [ Border.color <| rgba255 0 0 0 1 ]
        ]
        { onPress = Just <| ToggleUserMenu (not open)
        , label =
            row
                [ pointer
                , Font.color <| rgb255 0xFF 0xFF 0xFF
                ]
                [ el [] <|
                    html <|
                        Html.img
                            [ style "width" "20px"
                            , style "height" "20px"
                            , style "border-radius" "3px"
                            , style "border-width" "1px"
                            , src user.picture
                            ]
                            []
                , text "▾"
                ]
        }


userMenu : User -> Element Msg
userMenu user =
    let
        itemAttr1 =
            [ width fill
            , height <| px 30
            , mouseOver
                [ Font.color <| rgb255 0xFF 0xFF 0xFF
                , Background.color <| rgb255 0x03 0x66 0xCA
                ]
            ]

        itemAttr2 =
            [ centerY
            , paddingXY 16 4
            ]
    in
    el
        [ alignRight
        , paddingEach { top = 14, bottom = 8, left = 12, right = 0 }
        ]
    <|
        column
            [ width <| px 180
            , paddingXY 0 4
            , Font.size 14
            , Border.color <| rgba255 27 31 35 0.15
            , Border.width 1
            , Border.rounded 3
            , Border.shadow
                { offset = ( 0, 3 )
                , size = 0
                , blur = 12
                , color = rgba255 27 31 35 0.15
                }
            , Background.color <| rgb255 0xFF 0xFF 0xFF
            , inFront <|
                el
                    [ alignRight
                    , moveUp 10
                    , paddingEach { right = 18, left = 0, top = 0, bottom = 0 }
                    , Font.color <| rgb255 0xFF 0xFF 0xFF
                    ]
                    (text "▲")
            ]
            [ el
                [ width fill
                , height <| px 30
                , paddingXY 16 4
                ]
              <|
                link
                    []
                    { url = "https://github.com/" ++ user.nickname
                    , label =
                        paragraph []
                            [ text <| "Signed in as "
                            , el
                                [ Font.bold
                                , Font.color <| rgb255 0x24 0x29 0x2E
                                ]
                                (text user.nickname)
                            ]
                    }
            , el
                [ width fill
                , paddingEach { bottom = 4, top = 0, left = 0, right = 0 }
                ]
              <|
                el
                    [ width fill
                    , height <| px 1
                    , Border.solid
                    , Border.widthEach { bottom = 1, top = 0, left = 0, right = 0 }
                    , Border.color <| rgb255 0xE1 0xE4 0xE8
                    ]
                    Element.none
            , el
                itemAttr1
              <|
                link
                    (itemAttr2 ++ [])
                    { url = "https://github.com/" ++ user.nickname
                    , label = text "Your profile"
                    }
            , el
                itemAttr1
              <|
                el
                    (itemAttr2 ++ [ Events.onClick Logout ])
                    (text "Sign out")
            ]


signInButton : Element Msg
signInButton =
    Input.button
        [ Font.size 16
        , Font.color <| rgb255 0xFF 0xFF 0xFF
        , mouseOver
            [ Font.color <| rgba255 0xFF 0xFF 0xFF 0.75 ]
        ]
        { onPress = Just Login
        , label = text "Sign in"
        }


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
