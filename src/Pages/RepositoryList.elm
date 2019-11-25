module Pages.RepositoryList exposing (Model, Msg(..), init, update, view)

import Element exposing (..)
import Element.Font as Font
import Element.Region as Region
import Global
import Layout.Main as MainLayout
import Layout.Trending as Layout
import UI exposing (Document)



-- DATA


type alias PageConfig msg =
    { toMsg : Msg -> msg
    , layoutToMsg : Layout.Msg -> msg
    , mainLayoutToMsg : MainLayout.Msg -> msg
    }



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


update : Msg -> Model -> ( Model, Cmd Msg, Maybe Global.Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none, Nothing )



-- VIEW


view : PageConfig msg -> MainLayout.Model -> Layout.Model -> Global.Model -> Model -> Document msg
view config mainLayoutModel layoutModel global model =
    Layout.view
        { toMsg = config.layoutToMsg
        , mainLayoutToMsg = config.mainLayoutToMsg
        , page =
            { title = "Repositories"
            , subTitle = "See what the GitHub community from Angola is most excited about."
            , page = Layout.Repositories
            , filter = Nothing
            , body = body global model |> Element.map config.toMsg
            }
        }
        mainLayoutModel
        global
        layoutModel


body : Global.Model -> Model -> Element Msg
body _ _ =
    column
        [ centerX
        , centerY
        , padding 32
        , spacing 4
        , Font.color <| rgb255 0x24 0x29 0x2E
        ]
        [ paragraph
            [ Region.heading 3
            , Font.center
            , Font.semiBold
            , Font.size 20
            ]
            [ text "Get to know the Open Source community from Angola" ]
        , paragraph
            [ Font.center
            , Font.size 14
            ]
            [ text "Check the "
            , link
                [ Font.color <| rgb255 3 102 214 ]
                { url = "/developers"
                , label = text "developer list"
                }
            , text " to see what they are building."
            ]
        ]
