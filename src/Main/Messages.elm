module Main.Messages exposing (Msg(..))

import Browser
import Element exposing (..)
import Global
import Page
import Url



-- MESSAGE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | PageMsg Page.Msg
    | GlobalMsg Global.Msg
