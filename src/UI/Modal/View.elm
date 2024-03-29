module UI.Modal.View exposing (..)

import Element exposing (..)
import Element.Background as Background
import Element.Events as Events
import Global
import Main.Messages exposing (Msg(..))
import Main.Model exposing (Model)
import Page
import Pages.DeveloperList as DevListPage
import UI.Modal as Modal
import UI.Modal.Data exposing (Modal(..))
import UI.SelectMenu as SelectMenu


view : Model -> Element Msg
view model =
    case model.global.modal.active of
        Nothing ->
            Element.none

        Just DevListSort ->
            viewModal (viewDevListSort model) model

        Just DevListLanguage ->
            viewModal (viewDevListLanguage model) model

        Just DevListLocation ->
            viewModal (viewDevListLocation model) model


viewModal : Element Msg -> Model -> Element Msg
viewModal content _ =
    el
        [ width fill
        , height fill
        , centerX
        , behindContent <|
            el
                [ width fill
                , height fill
                , closeOnClick
                , Background.color <| rgba255 0x00 0x00 0x00 0.65
                ]
                Element.none
        ]
        content


viewDevListSort : Model -> Element Msg
viewDevListSort model =
    case model.page.devList of
        Nothing ->
            Element.none

        Just page ->
            SelectMenu.viewPopup
                [ centerX, centerY ]
                (DevListPage.sortMenuPopup model.global page)
                |> Element.map (Page.DevListMsg >> PageMsg)


viewDevListLanguage : Model -> Element Msg
viewDevListLanguage model =
    case model.page.devList of
        Nothing ->
            Element.none

        Just page ->
            SelectMenu.viewPopup
                [ centerX, centerY ]
                (DevListPage.languageMenuPopup model.global page)
                |> Element.map (Page.DevListMsg >> PageMsg)


viewDevListLocation : Model -> Element Msg
viewDevListLocation model =
    case model.page.devList of
        Nothing ->
            Element.none

        Just page ->
            SelectMenu.viewPopup
                [ centerX, centerY ]
                (DevListPage.locationMenuPopup model.global page)
                |> Element.map (Page.DevListMsg >> PageMsg)



-- UTILS


closeOnClick : Attribute Msg
closeOnClick =
    Events.onClick (fromModalMsg Modal.Close)


fromModalMsg : Modal.Msg -> Msg
fromModalMsg =
    Global.ModalMsg >> GlobalMsg
