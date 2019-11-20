module Layout.Main exposing (Model, Msg, PageConfig, PageData, ViewData, init, update, view)

import Data.App as App exposing (AppData, AuthState(..), Document, User)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Element.Input as Input
import Html
import Html.Attributes exposing (src, style, target)



-- DATA


type alias ViewData msg =
    { title : Maybe String
    , top : Maybe (Element msg)
    , main : Maybe (Element msg)
    }


type alias PageConfig msg =
    { toMsg : Msg -> msg
    , content : ViewData msg
    }


type alias PageData msg =
    { toMsg : Msg -> msg
    , model : Model
    , app : AppData
    }



-- MODEL


type alias Model =
    { userMenuOpen : Bool }



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


init : () -> ( Model, Cmd Msg )
init _ =
    ( { userMenuOpen = False }, Cmd.none )



-- VIEWS


view : PageConfig msg -> AppData -> Model -> Document msg
view { content, toMsg } { auth } model =
    let
        title =
            Maybe.withDefault "GithubAO" content.title

        body =
            column
                [ height fill
                , width fill
                ]
                [ headerView model.userMenuOpen auth
                    |> Element.map toMsg
                , content.top
                    |> Maybe.withDefault Element.none
                , content.main
                    |> Maybe.withDefault Element.none
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
