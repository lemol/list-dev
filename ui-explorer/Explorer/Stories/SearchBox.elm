module Explorer.Stories.SearchBox exposing (Model, Msg(..), StoryOptions, init, stories, update, view)

import Element exposing (..)
import Element.Background as Background
import Explorer.Utils as Utils exposing (storiesOf)
import UI.SearchBox as SearchBox
import UIExplorer exposing (UI)



-- DATA


type alias StoryOptions msg model =
    Utils.StoryOptions Msg Model msg model



-- MODEL


type alias Model =
    { state : SearchBox.State }



-- MESAGES


type Msg
    = NoOp
    | SearchBoxMsg SearchBox.Msg



-- UPDATE


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model

        SearchBoxMsg subMsg ->
            { model
                | state = SearchBox.update subMsg model.state
            }


init : Model
init =
    { state = SearchBox.init }



--VIEWS


view : Model -> Element Msg
view model =
    SearchBox.view
        [ height <| px 30
        , width <| px 300
        ]
        { placeholder = Just "Search users..."
        , state = model.state
        , toMsg = SearchBoxMsg
        }
        |> el
            [ padding 10
            , width fill
            , Background.color <| rgb255 0x24 0x29 0x2E
            ]


stories : StoryOptions msg model -> UI model msg {}
stories =
    storiesOf
        "SearchBox"
        [ ( "Default"
          , view
          )
        ]
