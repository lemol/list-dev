module UI.Modal exposing (Model, Msg(..), init, update)

import UI.Modal.Data exposing (Modal)



-- MODEL


type alias Model =
    { active : Maybe Modal }



-- MESSAGES


type Msg
    = Open Modal
    | Close
    | Update Modal



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Open modal ->
            ( { model | active = Just modal }, Cmd.none )

        Close ->
            ( { model | active = Nothing }, Cmd.none )

        Update modal ->
            ( { model | active = Just modal }, Cmd.none )


init : ( Model, Cmd Msg )
init =
    ( { active = Nothing }
    , Cmd.none
    )
