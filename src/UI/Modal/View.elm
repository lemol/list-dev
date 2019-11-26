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


viewModal : Element Msg -> Model -> Element Msg
viewModal content _ =
    column
        [ width fill
        , height fill
        , padding 8
        , Background.color <| rgba255 0x00 0x00 0x00 0.65
        , Events.onClick (fromModalMsg Modal.Close)
        ]
        [ el [ height <| fillPortion 10 ] Element.none
        , el
            [ width fill
            , centerX
            , height <| fillPortion 80
            ]
            content
        , el [ height <| fillPortion 10 ] Element.none
        ]


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



-- UTILS


fromModalMsg : Modal.Msg -> Msg
fromModalMsg =
    Global.ModalMsg >> GlobalMsg
