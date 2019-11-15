module Utils.Base exposing (..)

import Element exposing (Element)


type alias Document msg =
    { title : String
    , body : Element msg
    }


type ViewData data pageMsg
    = ViewData data


type alias UpdaterFn msg model =
    msg -> model -> ( model, Cmd msg )


type alias PageView viewData pageModel =
    pageModel -> viewData


type alias LayoutConfig viewData layoutMsg layoutModel pageModel msg model =
    { view : PageView viewData pageModel -> model -> Document msg
    , update : UpdaterFn layoutMsg layoutModel
    , init : () -> ( layoutModel, Cmd layoutMsg )
    , getModel : model -> Maybe layoutModel
    , setModel : model -> layoutModel -> model
    , toMsg : layoutMsg -> msg
    }


type alias PageConfig viewData layoutMsg layoutModel pageMsg pageModel msg model =
    { layout : LayoutConfig viewData layoutMsg layoutModel pageModel msg model
    , view : PageView viewData pageModel
    , update : UpdaterFn pageMsg pageModel
    , init : () -> ( pageModel, Cmd pageMsg )
    , getModel : model -> Maybe pageModel
    , setModel : model -> pageModel -> model
    , toMsg : pageMsg -> msg
    }


type alias Convert layoutMsg layoutModel pageMsg pageModel msg model =
    { fromPageMsg : pageMsg -> msg
    , fromLayoutMsg : layoutMsg -> msg
    , toPageModel : model -> Maybe pageModel
    , toLayoutModel : model -> Maybe layoutModel
    }


viewPageOrLoading : PageConfig viewData layoutMsg layoutModel pageMsg pageModel msg model -> Convert layoutMsg layoutModel pageMsg pageModel msg model -> model -> Document msg
viewPageOrLoading { view, layout } { toPageModel } model =
    toPageModel model
        |> Maybe.map (always <| layout.view view model)
        |> Maybe.withDefault loading


loading : Document msg
loading =
    { title = "Loading"
    , body = Element.text "Loading..."
    }


mapDocument : (msg1 -> msg2) -> Document msg1 -> Document msg2
mapDocument f x =
    { title = x.title
    , body = Element.map f x.body
    }


initPage : PageConfig viewData layoutMsg layoutModel pageMsg pageModel msg model -> model -> () -> ( model, Cmd msg )
initPage page model flags =
    let
        layoutModel =
            page.layout.getModel model

        pageModel =
            page.getModel model

        ( newPageModel, pageCmd ) =
            page.init flags

        ( newLayoutModel, layoutCmd ) =
            page.layout.init flags

        model1 =
            case pageModel of
                Nothing ->
                    page.setModel model newPageModel

                _ ->
                    model

        model2 =
            case layoutModel of
                Nothing ->
                    page.layout.setModel model1 newLayoutModel

                _ ->
                    model1

        newModel =
            model2
    in
    ( newModel
    , Cmd.batch
        [ Cmd.map page.layout.toMsg layoutCmd
        , Cmd.map page.toMsg pageCmd
        ]
    )



-- UPDATE


updatePage : PageConfig viewData layoutMsg layoutModel pageMsg pageModel msg model -> pageMsg -> model -> ( model, Cmd msg )
updatePage page msg model =
    page.getModel model
        |> Maybe.map (page.update msg)
        |> Maybe.map (Tuple.mapBoth (page.setModel model) (Cmd.map page.toMsg))
        |> Maybe.withDefault ( model, Cmd.none )
