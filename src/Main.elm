module Main exposing (main)

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import Html.Attributes exposing (src, style)
import Http
import Json.Decode as Decode
import RemoteData exposing (RemoteData(..), WebData)


type alias User =
    { login : String
    , name : String
    , avatar : String
    }


type alias Model =
    { users : WebData (List User)
    }


type Msg
    = FetchUsersResponse (WebData (List User))
    | FetchUsers


userDecoder : Decode.Decoder User
userDecoder =
    Decode.map3 User
        (Decode.field "login" Decode.string)
        (Decode.field "login" Decode.string)
        (Decode.field "avatar_url" Decode.string)


usersDecoder : Decode.Decoder (List User)
usersDecoder =
    Decode.field "items" (Decode.list userDecoder)


fetchUsers : Cmd Msg
fetchUsers =
    Http.get
        { url = "https://api.github.com/search/users?q=location:Angola+location:luanda&per_page=20"
        , expect = Http.expectJson (RemoteData.fromResult >> FetchUsersResponse) usersDecoder
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchUsers ->
            ( model
            , fetchUsers
            )

        FetchUsersResponse response ->
            ( { model | users = response }
            , Cmd.none
            )


init : ( Model, Cmd Msg )
init =
    ( { users = Loading }
    , fetchUsers
    )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


main : Program () Model Msg
main =
    Browser.element
        { init = always init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


view : Model -> Html msg
view model =
    layout
        [ Font.family mainFontFamily
        ]
    <|
        column
            [ height fill
            , width fill
            ]
            [ headerBar
            , headerTitle
            , mainSection model
            ]


headerBar : Element msg
headerBar =
    let
        logo =
            el
                [ Font.bold
                , Font.color <| rgb255 255 255 255
                ]
                (text "AoG")

        leftContent =
            row
                []
                [ logo
                ]

        rightContent =
            row
                [ alignRight ]
                [ text "AVATAR" ]
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


mainFontFamily : List Font.Font
mainFontFamily =
    List.map Font.typeface
        [ "-apple-system"
        , "BlinkMacSystemFont"
        , "Segoe UI"
        , "Helvetica"
        , "Arial"
        , "sans-serif"
        , "Apple Color Emoji"
        , "Segoe UI Emoji"
        ]


headerTitle : Element msg
headerTitle =
    el
        [ width fill
        , height <| px 174
        , Background.color <| rgb255 250 251 252
        , Border.color <| rgb255 225 228 232
        , Border.widthXY 0 1
        ]
    <|
        column
            [ centerX
            , centerY
            ]
            [ el
                [ centerX
                , padding 12
                , Font.size 40
                , Font.color <| rgb255 6 41 46
                , htmlAttribute <|
                    style "font-weight" "300"
                ]
                (text "Angolans Developers")
            , el
                [ centerX
                , Font.size 16
                , Font.family mainFontFamily
                , Font.color <| rgb255 88 96 105
                ]
                (text "These are the Angolans developers building the hot tools on Github.")
            ]



-- users : List User
-- users =
--     [ { login = "lemol"
--       , name = "Leza Lutonda"
--       , avatar = "https://avatars3.githubusercontent.com/u/1035379?s=96&v=4"
--       }
--     , { login = "frida"
--       , name = "Frida Zohounvo"
--       , avatar = "https://avatars3.githubusercontent.com/u/1035379?s=96&v=4"
--       }
--     ]


mainSection : Model -> Element msg
mainSection model =
    let
        top =
            el
                [ width fill
                , height <| px 64
                , Background.color <| rgb255 246 248 250
                , Border.color <| rgb255 209 213 218
                , Border.widthEach { bottom = 1, top = 0, left = 0, right = 0 }
                ]
            <|
                row
                    [ centerY
                    , width fill
                    , padding 16
                    ]
                    [ row
                        [ height <| px 34
                        , Font.size 14
                        , Font.semiBold
                        ]
                        [ link
                            [ centerX
                            , centerY
                            , height fill
                            , width fill
                            , paddingXY 14 6
                            , Font.color <| rgb255 88 96 105
                            , Border.color <| rgb255 225 228 232
                            , Border.widthEach { top = 1, bottom = 1, left = 1, right = 0 }
                            , Border.roundEach { topLeft = 3, bottomLeft = 3, topRight = 0, bottomRight = 0 }
                            ]
                            { url = "#/Repositories", label = el [ centerY ] (text "Repositories") }
                        , link
                            [ centerX
                            , centerY
                            , height fill
                            , width fill
                            , paddingXY 14 6
                            , Font.color <| rgb255 255 255 255
                            , Border.color <| rgb255 225 228 232
                            , Border.widthEach { top = 1, bottom = 1, left = 0, right = 1 }
                            , Border.roundEach { topLeft = 0, bottomLeft = 0, topRight = 3, bottomRight = 3 }
                            , Background.color <| rgb255 3 102 214
                            ]
                            { url = "#/Developers", label = el [ centerY ] (text "Developers") }
                        ]
                    , row
                        [ alignRight ]
                        [ row
                            [ spacing 4
                            , pointer
                            , Font.size 14
                            , Font.color <| rgb255 88 96 105
                            , mouseOver
                                [ Font.color <| rgb255 36 41 46 ]
                            ]
                            [ el
                                []
                                (text "Language:")
                            , el
                                [ Font.semiBold ]
                                (text "Any")
                            , text "▾"
                            ]
                        ]
                    ]

        userListItem count user =
            row
                [ width fill
                , padding 16
                , Border.color <| rgb255 209 213 218
                , Border.widthEach
                    { bottom = 0
                    , top =
                        if count == 0 then
                            0

                        else
                            1
                    , left = 0
                    , right = 0
                    }
                ]
                [ row
                    [ spacing 12
                    , alignTop
                    , width (fill |> minimum 300)
                    ]
                    [ el
                        [ Font.size 32
                        , Font.color <| rgb255 88 96 105
                        ]
                        (text <| String.fromInt (count + 1))
                    , link
                        []
                        { url = "#/Users/" ++ user.login
                        , label =
                            row
                                [ width fill
                                , spacing 12
                                ]
                                [ el [] <|
                                    html <|
                                        Html.img
                                            [ style "width" "48px"
                                            , style "height" "52px"
                                            , style "border-radius" "3px"
                                            , style "border-width" "1px"
                                            , src user.avatar
                                            ]
                                            []
                                , column
                                    [ spacing 4 ]
                                    [ el
                                        [ Font.size 20
                                        , Font.bold
                                        , Font.color <| rgb255 3 102 214
                                        ]
                                        (text user.name)
                                    , el
                                        [ Font.size 16
                                        , Font.color <| rgb255 88 96 105
                                        , mouseOver [ Font.color <| rgb255 3 102 214 ]
                                        ]
                                        (text user.login)
                                    ]
                                ]
                        }
                    ]
                , column
                    [ width (fill |> maximum 300)
                    , spacingXY 0 9
                    ]
                    [ el
                        [ Font.size 16
                        , Font.variant Font.smallCaps
                        , Font.color <| rgb255 88 96 105
                        ]
                        (text "popular repo")
                    , link
                        [ Font.size 16
                        , Font.color <| rgb255 3 102 214
                        , Font.semiBold
                        ]
                        { url = "#", label = text "angolans-on-github-elm" }
                    , paragraph
                        [ Font.size 12
                        , Font.color <| rgb255 88 96 105
                        ]
                        [ text "Github Trending page clone using elm-ui. Almost zero css+javascript+html." ]
                    ]
                , row
                    [ width fill
                    ]
                    [ el [ alignRight ] (githubTextButton "Follow") ]
                ]

        userList =
            case model.users of
                Success users ->
                    users
                        |> List.indexedMap userListItem
                        |> column [ width fill ]

                Failure (Http.BadBody err) ->
                    text err

                _ ->
                    text "Loading..."
    in
    el
        [ width fill
        , paddingXY 42 40
        ]
    <|
        column
            [ centerX
            , width (fill |> maximum 1012)
            , Border.color <| rgb255 209 213 218
            , Border.width 1
            , Border.rounded 3
            ]
            [ top
            , userList
            ]


githubTextButton : String -> Element msg
githubTextButton label =
    Input.button
        [ height <| px 28
        , paddingXY 10 3
        , Font.size 12
        , Font.semiBold
        , Background.color <| rgb255 239 243 246
        , Border.color <| rgba255 27 31 35 0.2
        , Border.width 1
        , Border.rounded 3
        , mouseOver
            [ Background.color <| rgb255 230 235 241
            , Border.color <| rgba255 27 31 35 0.35
            ]
        ]
        { onPress = Nothing
        , label = text label
        }
