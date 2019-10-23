module Main exposing (main)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import Html.Attributes exposing (src, style)


main : Html msg
main =
    view


view : Html msg
view =
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
            , mainSection
            ]


headerBar : Element msg
headerBar =
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
            [ row
                []
                [ -- LOGO
                  el
                    [ Font.bold
                    , Font.color <| rgb255 255 255 255
                    ]
                    (text "AoG")
                ]
            , row
                [ alignRight ]
                [ text "AVATAR" ]
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


mainSection : Element msg
mainSection =
    el
        [ height fill
        , centerX
        , width (fill |> maximum 1012)
        , paddingXY 42 40
        ]
    <|
        el
            [ width fill
            , Border.color <| rgb255 209 213 218
            , Border.width 1
            , Border.rounded 3
            ]
        <|
            column [ width fill ]
                [ el
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
                , el
                    [ width fill ]
                  <|
                    row
                        [ width fill
                        , padding 8
                        ]
                        [ el
                            [ Font.size 32
                            , Font.color <| rgb255 88 96 105
                            ]
                            (text "1")
                        , link
                            []
                            { url = "#/Users/" ++ "lemol"
                            , label =
                                row
                                    []
                                    [ Html.img
                                        [ style "width" "48px"
                                        , style "height" "52px"
                                        , style "border-radius" "3px"
                                        , style "border-width" "1px"
                                        , src "https://avatars3.githubusercontent.com/u/1035379?s=96&v=4"
                                        ]
                                        []
                                        |> html
                                    , column
                                        [ width (fill |> minimum 300) ]
                                        [ el
                                            [ Font.size 20
                                            , Font.bold
                                            , Font.color <| rgb255 3 102 214
                                            ]
                                            (text "Leza Lutonda")
                                        , el
                                            [ Font.size 16
                                            , Font.color <| rgb255 88 96 105
                                            , mouseOver [ Font.color <| rgb255 3 102 214 ]
                                            ]
                                            (text "lemol")
                                        ]
                                    ]
                            }
                        , column
                            [ width (fill |> maximum 300)
                            ]
                            [ el
                                [ Font.size 16
                                , Font.variant Font.smallCaps
                                ]
                                (text "popular repo")
                            , link
                                [ Font.size 16
                                , Font.color <| rgb255 3 102 214
                                ]
                                { url = "#", label = text "angolans-on-github-elm" }
                            , paragraph
                                [ Font.size 12
                                , Font.color <| rgb255 88 96 105
                                ]
                                [ text "Clone of some github pages written with elm-ui. Almost zero css, javascript and html." ]
                            ]
                        , row
                            [ width fill
                            ]
                            [ el [ alignRight ] (githubTextButton "View") ]
                        ]
                ]


githubTextButton : String -> Element msg
githubTextButton label =
    Input.button
        [ height <| px 24
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
