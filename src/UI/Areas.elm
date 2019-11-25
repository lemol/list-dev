module UI.Areas exposing (boxView, headerView)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Html.Attributes exposing (style)
import UI exposing (responsive)


headerView : { a | title : String, subTitle : Maybe String } -> Element msg
headerView config =
    let
        title =
            el
                [ centerX
                , Font.size 40
                , Font.color <| rgb255 6 41 46
                , htmlAttribute <|
                    style "font-weight" "400"
                ]
                (text config.title)

        makeSubTitle txt =
            paragraph
                [ centerX
                , Font.size 16
                , Font.center
                , Font.color <| rgb255 88 96 105
                ]
                [ text txt ]

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
            , paddingXY 16 40
            , spacing 12
            ]
            [ title
            , subTitle
            ]


boxView : { a | header : Element msg, body : Element msg, device : Device } -> Element msg
boxView config =
    let
        header =
            el
                [ width fill
                , height shrink
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
        , responsive config.device
            { desktop = paddingXY 42 40
            , phone = paddingXY 16 40
            }
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
