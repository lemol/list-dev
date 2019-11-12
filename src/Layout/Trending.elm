module Layout.Trending exposing (TrendingPage(..), TrendingPageConfig, view)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Layout.Main as Main
import RemoteData exposing (RemoteData(..))
import Routing exposing (Route(..), toUrl)
import UI.Areas as Areas



-- DATA


type TrendingPage
    = Repositories
    | Developers


type alias TrendingPageConfig msg =
    { title : String
    , subTitle : String
    , page : TrendingPage
    , filter : Maybe (Element msg)
    , body : Element msg
    }



-- VIEWS


view : TrendingPageConfig msg -> Main.Document msg
view config =
    Main.mainView
        { titleSection = Just <| headerView config
        , mainSection = Just <| mainSectionView config
        , title = Just <| "Trending " ++ config.title ++ " from Angola"
        }


headerView : TrendingPageConfig msg -> Element msg
headerView { title, subTitle } =
    Areas.headerView
        { title = title
        , subTitle = Just subTitle
        }


mainSectionView : TrendingPageConfig msg -> Element msg
mainSectionView config =
    let
        header =
            row
                [ centerY, width fill ]
                [ navigationButtons config
                , Maybe.withDefault none config.filter
                ]

        body =
            config.body
    in
    Areas.boxView
        { header = header
        , body = body
        }


navigationButtons : TrendingPageConfig msg -> Element msg
navigationButtons config =
    let
        repoAttrs =
            case config.page of
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
            case config.page of
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
