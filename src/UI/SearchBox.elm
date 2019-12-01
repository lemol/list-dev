module UI.SearchBox exposing (Msg(..), State, init, update, view)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import RemoteData exposing (RemoteData(..))



-- DATA


type alias State =
    { text : String
    , focused : Bool
    }


type alias SearchBoxOptions msg =
    { placeholder : Maybe String
    , state : State
    , toMsg : Msg -> msg
    }



-- MODEL


type alias Model =
    State



-- MESSAGE


type Msg
    = TextChanged String
    | Focus
    | Blur



-- UPDATE


update : Msg -> Model -> Model
update msg model =
    case msg of
        TextChanged text ->
            { model | text = text }

        Focus ->
            { model | focused = True }

        Blur ->
            { model | focused = False }


init : Model
init =
    { text = ""
    , focused = False
    }



-- VIEW


view : List (Element.Attribute msg) -> SearchBoxOptions msg -> Element msg
view attrs { placeholder, state, toMsg } =
    row
        ([ Background.color <| rgba255 0xFF 0xFF 0xFF 0.125
         , Border.rounded 3
         , Font.size 14
         , paddingXY 4 0
         , Font.color <| rgba255 0xFF 0xFF 0xFF 0.7
         , focused
            [ Background.color <| rgb255 0xFF 0xFF 0xFF
            , Font.color <| rgb255 0x00 0x00 0x00
            ]
         ]
            ++ attrs
        )
        [ Input.search
            [ Background.color <| rgba255 0xFF 0xFF 0xFF 0
            , Border.width 0
            , padding 0
            , focused
                [ Border.color <| rgba255 0xFF 0xFF 0xFF 0 ]
            ]
            { text = state.text
            , label = Input.labelHidden "Search"
            , placeholder =
                placeholder
                    |> Maybe.map (Element.text >> Input.placeholder [])
            , onChange = TextChanged >> toMsg
            }
        , el
            [ Border.width 1
            , Border.rounded 3
            , Border.color <| rgba255 151 154 156 0.4
            , Font.color <| rgba255 151 154 156 0.4
            ]
          <|
            el
                [ paddingXY 8 4 ]
                (Element.text "/")
        ]
