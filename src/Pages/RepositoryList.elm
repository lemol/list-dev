module Pages.RepositoryList exposing (Model, Msg(..), init, update, view)

import Element exposing (..)
import Element.Font as Font
import Element.Region as Region
import Layout.Main exposing (Document)
import Layout.Trending as Layout



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


view : Model -> Document Msg
view _ =
    Layout.view
        { title = "Repositories"
        , subTitle = "See what the GitHub community from Angola is most excited about."
        , page = Layout.Repositories
        , filter = Nothing
        , body = body
        }


body : Element msg
body =
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
