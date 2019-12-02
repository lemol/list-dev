module Explorer.Main exposing (main)

import Explorer.Stories.Buttons as Buttons
import Explorer.Stories.Icons as Icons
import Explorer.Stories.SearchBox as SearchBox
import Explorer.Stories.SelectMenu as SelectMenu
import UIExplorer exposing (UIExplorerProgram, explore)



-- MODEL


type alias Model =
    { searchBox : SearchBox.Model
    , icons : Icons.Model
    , buttons : Buttons.Model
    , selectMenu : SelectMenu.Model
    }



-- MESSAGE


type Msg
    = SearchBoxMsg SearchBox.Msg
    | IconsMsg Icons.Msg
    | ButtonsMsg Buttons.Msg
    | SelectMenuMsg SelectMenu.Msg



-- UPDATE


update : Msg -> UIExplorer.Model Model Msg {} -> UIExplorer.Model Model Msg {}
update msg model_ =
    let
        model =
            model_.customModel
    in
    case msg of
        SearchBoxMsg subMsg ->
            updateModel model_ { model | searchBox = SearchBox.update subMsg model.searchBox }

        IconsMsg subMsg ->
            updateModel model_ { model | icons = Icons.update subMsg model.icons }

        ButtonsMsg subMsg ->
            updateModel model_ { model | buttons = Buttons.update subMsg model.buttons }

        SelectMenuMsg subMsg ->
            updateModel model_ { model | selectMenu = SelectMenu.update subMsg model.selectMenu }


initModel : Model
initModel =
    { searchBox = SearchBox.init
    , icons = Icons.init
    , buttons = Buttons.init
    , selectMenu = SelectMenu.init
    }



-- PROGRAM


main : UIExplorerProgram Model Msg {}
main =
    explore
        config
        [ Buttons.stories
            { getModel = .customModel >> .buttons
            , toMsg = ButtonsMsg
            }
        , SelectMenu.stories
            { getModel = .customModel >> .selectMenu
            , toMsg = SelectMenuMsg
            }
        , Icons.stories
            { getModel = .customModel >> .icons
            , toMsg = IconsMsg
            }
        , SearchBox.stories
            { getModel = .customModel >> .searchBox
            , toMsg = SearchBoxMsg
            }
        ]



-- UTILS


updateModel : UIExplorer.Model Model Msg {} -> Model -> UIExplorer.Model Model Msg {}
updateModel model_ model =
    { model_
        | customModel = model
    }


config : UIExplorer.Config Model Msg {}
config =
    { customModel = initModel
    , customHeader = Nothing
    , update = update
    , viewEnhancer = \_ stories -> stories
    , menuViewEnhancer = \_ v -> v
    }
