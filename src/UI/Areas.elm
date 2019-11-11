module UI.Areas exposing (boxView, headerView)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Html.Attributes exposing (style)


headerView : { a | title : String, subTitle : Maybe String } -> Element msg
headerView config =
    let
        title =
            el
                [ centerX
                , padding 12
                , Font.size 40
                , Font.color <| rgb255 6 41 46
                , htmlAttribute <|
                    style "font-weight" "300"
                ]
                (text config.title)

        makeSubTitle txt =
            el
                [ centerX
                , Font.size 16
                , Font.color <| rgb255 88 96 105
                ]
                (text txt)

        subTitle =
            config.subTitle
                |> Maybe.map makeSubTitle
                |> Maybe.withDefault none
    in
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
            [ title
            , subTitle
            ]


boxView : { a | header : Element msg, body : Element msg } -> Element msg
boxView config =
    let
        header =
            el
                [ width fill
                , height <| px 64
                , Background.color <| rgb255 246 248 250
                , Border.color <| rgb255 209 213 218
                , Border.widthEach { bottom = 1, top = 0, left = 0, right = 0 }
                ]
            <|
                el
                    [ centerY
                    , width fill
                    , padding 16
                    ]
                    config.header

        body =
            config.body
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
            [ header
            , body
            ]
