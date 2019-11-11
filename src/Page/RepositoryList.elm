module Page.RepositoryList exposing (Model, Msg(..), init, update, view)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Region as Region
import Layout
import UI.Areas as Areas



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


view : Model -> Layout.Document Msg
view model =
    Layout.mainView
        { titleSection = Just headerView
        , mainSection = Just <| mainSectionView model
        , title = Nothing
        }


headerView : Element msg
headerView =
    Areas.headerView
        { title = "Repositories"
        , subTitle = Just "See what the GitHub community from Angola is most excited about."
        }


mainSectionView : Model -> Element Msg
mainSectionView _ =
    let
        header =
            row
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

        body =
            emptyListView
    in
    Areas.boxView
        { header = header
        , body = body
        }


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
            [ text "Get to know the Open Source community from Angola" ]
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
