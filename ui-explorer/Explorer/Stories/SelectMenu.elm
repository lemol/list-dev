module Explorer.Stories.SelectMenu exposing (Model, Msg(..), StoryOptions, init, stories, update)

import Element exposing (..)
import Explorer.Utils as Utils exposing (storiesOf)
import UI.SelectMenu as SelectMenu
import UIExplorer exposing (UI)



-- DATA


type alias StoryOptions msg model =
    Utils.StoryOptions Msg Model msg model



-- MODEL


type alias Model =
    {}



-- MESAGES


type Msg
    = NoOp



-- UPDATE


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model


init : Model
init =
    {}



--VIEWS


stories : StoryOptions msg model -> UI model msg {}
stories =
    storiesOf
        "SelectMenu"
        [ ( "Closed"
          , \_ ->
                SelectMenu.viewButton [ Element.centerX ]
                    { title = "Sort:"
                    , defaultText = "Select"
                    , popup = selectMenuPopup False False
                    }
          )
        , ( "Open"
          , \_ ->
                SelectMenu.viewButton [ Element.centerX ]
                    { title = "Sort:"
                    , defaultText = "Select"
                    , popup = selectMenuPopup True False
                    }
          )
        , ( "With Filters"
          , \_ ->
                SelectMenu.viewButton [ Element.centerX ]
                    { title = "Sort:"
                    , defaultText = "Select"
                    , popup = selectMenuPopup True True
                    }
          )
        ]



-- UTILS


selectMenuPopup : Bool -> Bool -> SelectMenu.SelectMenuPopup String Msg
selectMenuPopup open showFilter =
    { title = "Sort options"
    , options = Just [ "OK", "OK2", "OK3" ]
    , toString = always "OK"
    , showFilter = showFilter
    , model =
        let
            init2 =
                SelectMenu.init (Just "OK")
        in
        { init2 | open = open }
    , toMsg = always NoOp
    , device = Element.classifyDevice { width = 1024, height = 1024 }
    }
