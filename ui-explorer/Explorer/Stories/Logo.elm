module Explorer.Stories.Logo exposing (Model, Msg(..), StoryOptions, init, stories, update)

import Element exposing (..)
import Explorer.Utils as Utils exposing (storiesOf)
import UI.Icon as Icon
import UIExplorer exposing (UI)
import Svg.Attributes as Attr



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


default : Int -> Model -> Element Msg
default size _ =
    row
        [ spacing 8
        , width fill
        ]
        [ el [] 
            <|
            Icon.logo
                [ Attr.width (String.fromInt size ++ "px")
                , Attr.height (String.fromInt size ++ "px")
                ]
        ]


stories : StoryOptions msg model -> UI model msg {}
stories =
    storiesOf
        "Logo"
        [ ( "Big"
          , default 128
          )
        , ( "Medium"
          , default 64
          )
        , ( "Small"
          , default 32
          )
        ]
