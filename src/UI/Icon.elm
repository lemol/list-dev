module UI.Icon exposing (checkIcon, slashIcon, threeBarsIcon)

import Element
import Html exposing (Html)
import Svg exposing (..)
import Svg.Attributes exposing (..)


checkIcon_ : List (Attribute msg) -> Html msg
checkIcon_ attr =
    svg [ height "16", class "octicon octicon-check select-menu-item-icon", viewBox "0 0 12 16", version "1.1", width "12" ]
        [ Svg.path
            ([ fillRule "evenodd", d "M12 5l-8 8-4-4 1.5-1.5L4 10l6.5-6.5L12 5z", Svg.Attributes.style "fill: currentColor" ] ++ attr)
            []
        ]


threeBarsIcon_ : List (Attribute msg) -> Html msg
threeBarsIcon_ attr =
    svg [ fill "none", height "16", viewBox "0 0 12 16", width "12", Svg.Attributes.style "width: 20px; height: 24px" ]
        [ Svg.path
            ([ clipRule "evenodd", d "M11.41 9H0.59C0 9 0 8.59 0 8C0 7.41 0 7 0.59 7H11.4C11.99 7 11.99 7.41 11.99 8C11.99 8.59 11.99 9 11.4 9H11.41ZM11.41 5H0.59C0 5 0 4.59 0 4C0 3.41 0 3 0.59 3H11.4C11.99 3 11.99 3.41 11.99 4C11.99 4.59 11.99 5 11.4 5H11.41ZM0.59 11H11.4C11.99 11 11.99 11.41 11.99 12C11.99 12.59 11.99 13 11.4 13H0.59C0 13 0 12.59 0 12C0 11.41 0 11 0.59 11Z", Svg.Attributes.style "fill: currentColor", fillRule "evenodd" ] ++ attr)
            []
        ]


slashIcon_ : List (Attribute msg) -> Html msg
slashIcon_ attr =
    svg
        ([ version "1.1", x "0px", y "0px", width "19px", height "20px", viewBox "0 0 19 20", Svg.Attributes.style "enable-background:new 0 0 19 20;" ] ++ attr)
        [ Svg.path
            [ fill "none", Svg.Attributes.style "stroke: currentColor", opacity "0.4", d "M3.5,0.5h12c1.7,0,3,1.3,3,3v13c0,1.7-1.3,3-3,3h-12c-1.7,0-3-1.3-3-3v-13C0.5,1.8,1.8,0.5,3.5,0.5z" ]
            []
        , Svg.path
            [ Svg.Attributes.style "fill: currentColor", d "M11.8,6L8,15.1H7.1L10.8,6L11.8,6z" ]
            []
        ]


checkIcon : List (Attribute msg) -> Element.Element msg
checkIcon =
    checkIcon_ >> Element.html


threeBarsIcon : List (Attribute msg) -> Element.Element msg
threeBarsIcon =
    threeBarsIcon_ >> Element.html


slashIcon : List (Attribute msg) -> Element.Element msg
slashIcon =
    slashIcon_ >> Element.html
