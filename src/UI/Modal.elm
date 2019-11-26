module UI.Modal exposing (Model, Msg(..), init, update, view)

import Element exposing (..)
import Element.Background as Background
import Element.Events as Events



-- MODEL


type alias Model =
    { active : Bool }



-- MESSAGES


type Msg
    = Open
    | Close



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Open ->
            ( { model | active = True }, Cmd.none )

        Close ->
            ( { model | active = False }, Cmd.none )


init : ( Model, Cmd Msg )
init =
    ( { active = False }
    , Cmd.none
    )



-- VIEW


view : Model -> Element Msg
view model =
    if model.active then
        viewModal model

    else
        Element.none


viewModal : Model -> Element Msg
viewModal _ =
    el
        [ width fill
        , height fill
        , Background.color <| rgba255 0x00 0x00 0x00 0.75
        , Events.onClick Close
        ]
        (text "")
