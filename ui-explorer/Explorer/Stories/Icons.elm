module Explorer.Stories.Icons exposing (Model, Msg(..), StoryOptions, init, stories, update)

import Element exposing (..)
import Element.Font as Font
import Explorer.Utils as Utils exposing (storiesOf)
import UI.Icon as Icon
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


default : Model -> Element Msg
default _ =
    row
        [ spacing 8
        , width fill
        ]
        [ el [] (Icon.checkIcon [])
        , el [] (Icon.threeBarsIcon [])
        , el [] (Icon.slashIcon [])
        ]


withColor : Model -> Element Msg
withColor _ =
    row
        [ spacing 8
        , width fill
        , Font.color <| rgb255 0xFF 0 0
        ]
        [ el [] (Icon.checkIcon [])
        , el [] (Icon.threeBarsIcon [])
        , el [] (Icon.slashIcon [])
        ]


stories : StoryOptions msg model -> UI model msg {}
stories =
    storiesOf
        "Icons"
        [ ( "Default"
          , default
          )
        , ( "With Color"
          , withColor
          )
        ]
