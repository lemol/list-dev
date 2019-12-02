module Explorer.Utils exposing (StoryOptions, storiesOf)

import Element exposing (Element, fill, layout, width)
import Html exposing (Html)
import UIExplorer exposing (Model, UI)


type alias StoryOptions storyMsg storyModel msg model =
    { getModel : Model model msg {} -> storyModel
    , toMsg : storyMsg -> msg
    }


storiesOf : String -> List ( String, storyModel -> Element storyMsg ) -> StoryOptions storyMsg storyModel msg model -> UI model msg {}
storiesOf uiId stories { getModel, toMsg } =
    UIExplorer.storiesOf
        uiId
        (stories
            |> List.map
                (Tuple.mapSecond (\view -> getModel >> view >> Element.map toMsg >> toHtml))
            |> List.map (\( x, y ) -> ( x, y, {} ))
        )


toHtml : Element msg -> Html msg
toHtml =
    layout [ width fill ]
