module Explorer.Stories.Buttons exposing (Model, Msg(..), StoryOptions, init, stories, update)

import Element exposing (..)
import Explorer.Utils as Utils exposing (storiesOf)
import UI.Button as Button
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
        "Buttons"
        [ ( "Text Button"
          , \_ ->
                Button.githubTextButton "Submit"
          )
        , ( "Link Button"
          , \_ ->
                Button.githubLinkButton "#" "Submit"
          )
        ]
