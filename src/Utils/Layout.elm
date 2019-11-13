module Utils.Layout exposing (Document, LayoutConfig, Model, Msg(..), PageConfig, UpdaterFn, mapDocument, update, view)

import Element exposing (Element)


type alias Document msg =
    { title : String
    , body : Element msg
    }


type alias UpdaterFn msg model =
    msg -> model -> ( model, Cmd msg )


type alias LayoutConfig layoutMsg layoutModel pageMsg pageModel viewData =
    { notFound : viewData
    , loading : viewData
    , update : UpdaterFn pageMsg pageModel -> layoutMsg -> layoutModel -> ( layoutModel, Cmd layoutMsg )
    }


type alias PageConfig msg model viewData layoutConfig =
    { layout : layoutConfig
    , update : msg -> model -> ( model, Cmd msg )
    , view : model -> viewData
    }


type Msg globalMsg pageMsg
    = GlobalMsg globalMsg
    | PageMsg pageMsg


type alias Model globalModel pageModel =
    { global : globalModel
    , page : pageModel
    }


update : (globalMsg -> globalModel -> ( globalModel, Cmd globalMsg )) -> (pageMsg -> pageModel -> ( pageModel, Cmd pageMsg )) -> Msg globalMsg pageMsg -> Model globalModel pageModel -> ( Model globalModel pageModel, Cmd (Msg globalMsg pageMsg) )
update updateGlobal updatePage msg model =
    case msg of
        GlobalMsg globalMsg ->
            updateGlobal globalMsg model.global
                |> mapUpdateGlobal model

        PageMsg pageMsg ->
            updatePage pageMsg model.page
                |> mapUpdatePage model


view : (viewData -> Model globalModel pageModel -> Document (Msg globalMsg pageMsg)) -> (pageModel -> viewData) -> Model globalModel pageModel -> Document (Msg globalMsg pageMsg)
view globalView pageView model =
    let
        pageDocument =
            pageView model.page
    in
    globalView pageDocument model



-- UTILS


mapUpdateGlobal : Model globalModel pageModel -> ( globalModel, Cmd globalMsg ) -> ( Model globalModel pageModel, Cmd (Msg globalMsg pageMsg) )
mapUpdateGlobal model =
    Tuple.mapBoth
        (\globalModel -> { model | global = globalModel })
        (Cmd.map GlobalMsg)


mapUpdatePage : Model globalModel pageModel -> ( pageModel, Cmd pageMsg ) -> ( Model globalModel pageModel, Cmd (Msg globalMsg pageMsg) )
mapUpdatePage model =
    Tuple.mapBoth
        (\pageModel -> { model | page = pageModel })
        (Cmd.map PageMsg)


mapDocument : (msg1 -> msg2) -> Document msg1 -> Document msg2
mapDocument f x =
    { title = x.title
    , body = Element.map f x.body
    }
