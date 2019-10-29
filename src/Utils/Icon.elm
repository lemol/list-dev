module Utils.Icon exposing (checkIcon)

import Element exposing (Element)
import Html exposing (Html)
import Svg exposing (..)
import Svg.Attributes exposing (..)


checkIcon : Html msg
checkIcon =
    svg [ height "16", class "octicon octicon-check select-menu-item-icon", viewBox "0 0 12 16", version "1.1", width "12" ]
        [ Svg.path [ fillRule "evenodd", d "M12 5l-8 8-4-4 1.5-1.5L4 10l6.5-6.5L12 5z" ]
            []
        ]
