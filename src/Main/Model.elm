module Main.Model exposing (..)

import Browser.Navigation as Navigation
import Element exposing (..)
import Global
import Page



-- MODEL


type alias Model =
    { page : Page.Model
    , global : Global.Model
    , key : Navigation.Key
    }


type alias Flags =
    Global.Flags
