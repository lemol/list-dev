module UI.Icon exposing (checkIcon, threeBarsIcon)

import Html exposing (Html)
import Svg exposing (..)
import Svg.Attributes exposing (..)


checkIcon : Html msg
checkIcon =
    svg [ height "16", class "octicon octicon-check select-menu-item-icon", viewBox "0 0 12 16", version "1.1", width "12" ]
        [ Svg.path [ fillRule "evenodd", d "M12 5l-8 8-4-4 1.5-1.5L4 10l6.5-6.5L12 5z" ]
            []
        ]


threeBarsIcon : Html msg
threeBarsIcon =
    svg [ fill "none", height "16", viewBox "0 0 12 16", width "12" ]
        [ Svg.path [ clipRule "evenodd", d "M11.41 9H0.59C0 9 0 8.59 0 8C0 7.41 0 7 0.59 7H11.4C11.99 7 11.99 7.41 11.99 8C11.99 8.59 11.99 9 11.4 9H11.41ZM11.41 5H0.59C0 5 0 4.59 0 4C0 3.41 0 3 0.59 3H11.4C11.99 3 11.99 3.41 11.99 4C11.99 4.59 11.99 5 11.4 5H11.41ZM0.59 11H11.4C11.99 11 11.99 11.41 11.99 12C11.99 12.59 11.99 13 11.4 13H0.59C0 13 0 12.59 0 12C0 11.41 0 11 0.59 11Z", fill "#1B1F23", fillRule "evenodd" ]
            []
        , text ""
        ]
