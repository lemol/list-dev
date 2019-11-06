module Page.RepositoryList exposing (..)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Region as Region
import Html.Attributes exposing (style)



-- MODEL


type alias Model =
    {}


init : ( Model, Cmd Msg )
init =
    ( {}
    , Cmd.none
    )



-- MESSAGE


type Msg
    = NoOp



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )



-- VIEW


headerTitleView : Element msg
headerTitleView =
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
                (text "Repositories")
            , el
                [ centerX
                , Font.size 16
                , Font.color <| rgb255 88 96 105
                ]
                (text "See what the GitHub community from Angola is most excited about.")
            ]


mainSectionView : Model -> Element Msg
mainSectionView _ =
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
                            , Font.color <| rgb255 255 255 255
                            , Border.color <| rgb255 225 228 232
                            , Border.widthEach { top = 1, bottom = 1, left = 1, right = 0 }
                            , Border.roundEach { topLeft = 3, bottomLeft = 3, topRight = 0, bottomRight = 0 }
                            , Background.color <| rgb255 3 102 214
                            ]
                            { url = "/repositories", label = el [ centerY ] (text "Repositories") }
                        , link
                            [ centerX
                            , centerY
                            , height fill
                            , width fill
                            , paddingXY 14 6
                            , Font.color <| rgb255 88 96 105
                            , Border.color <| rgb255 225 228 232
                            , Border.widthEach { top = 1, bottom = 1, left = 0, right = 1 }
                            , Border.roundEach { topLeft = 0, bottomLeft = 0, topRight = 3, bottomRight = 3 }
                            ]
                            { url = "/developers", label = el [ centerY ] (text "Developers") }
                        ]
                    ]

        body =
            emptyListView
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
            , body
            ]


emptyListView : Element msg
emptyListView =
    textColumn
        [ centerX
        , centerY
        , padding 32
        , height <| px 146
        , spacing 4
        , Font.color <| rgb255 0x24 0x29 0x2E
        ]
        [ paragraph
            [ Region.heading 3
            , Font.center
            , Font.bold
            , Font.size 20
            ]
            [ text "Get to know the open source community from Angola" ]
        , paragraph
            [ Font.center
            , Font.size 14
            ]
            [ row
                []
                [ text <| "Check the "
                , link
                    [ Font.color <| rgb255 3 102 214 ]
                    { url = "/developers"
                    , label = text "developer list"
                    }
                , text <| " to see what they are building."
                ]
            ]
        ]
