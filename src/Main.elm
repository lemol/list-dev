module Main exposing (main)

import Browser
import DeveloperTrending.Data as DevTrend
import DeveloperTrending.Page as DevTrend
import Element exposing (..)
import Html exposing (Html)
import RemoteData exposing (RemoteData(..))
import Utils.ListDropdown exposing (..)



-- MODEL


type alias Model =
    { developerTrending : DevTrend.Model
    }


init : ( Model, Cmd Msg )
init =
    ( { developerTrending = Tuple.first DevTrend.init
      }
    , Cmd.batch
        [ Cmd.map DevTrendMsg <| Tuple.second DevTrend.init ]
    )



-- MESSAGE


type Msg
    = DevTrendMsg DevTrend.Msg



-- PROGRAM


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


main : Program () Model Msg
main =
    Browser.element
        { init = always init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DevTrendMsg innerMsg ->
            let
                ( newUserModel, cmd ) =
                    DevTrend.update innerMsg model.developerTrending
            in
            ( { model | developerTrending = newUserModel }
            , Cmd.map DevTrendMsg cmd
            )



-- VIEW


view : Model -> Html Msg
view model =
    Html.map DevTrendMsg <| DevTrend.view model.developerTrending
