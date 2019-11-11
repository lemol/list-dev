module Layout exposing (Document, loadingView, mainView, map, notFoundView)

import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Html.Attributes exposing (target)
import RemoteData exposing (RemoteData(..))
import Routing exposing (Route(..))



-- DATA


type alias Document msg =
    { title : String
    , body : Element msg
    }


type alias MainViewContent msg =
    { titleSection : Maybe (Element msg)
    , mainSection : Maybe (Element msg)
    , title : Maybe String
    }



-- VIEWS


mainView : MainViewContent msg -> Document msg
mainView content =
    let
        title =
            Maybe.withDefault "GithubAO" content.title

        body =
            column
                [ height fill
                , width fill
                ]
                [ headerView
                , Maybe.withDefault none content.titleSection
                , Maybe.withDefault none content.mainSection
                ]
    in
    { title = title
    , body = body
    }


notFoundView : Document msg
notFoundView =
    mainView
        { title = Just "404"
        , titleSection = Nothing
        , mainSection = Just (text "Not Found")
        }


loadingView : Document msg
loadingView =
    mainView
        { title = Nothing
        , titleSection = Nothing
        , mainSection = Just (text "Loading...")
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
