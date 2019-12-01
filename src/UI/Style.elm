module UI.Style exposing (percentWidth, transition)

import Element exposing (Attribute, htmlAttribute)
import Html.Attributes exposing (style)


percentWidth : Int -> Attribute msg
percentWidth val =
    style "width" (String.fromInt val ++ "%")
        |> htmlAttribute


transition : { props : List String, duration : Int } -> Attribute msg
transition options =
    options.props
        |> List.map
            (\prop ->
                String.join " "
                    [ prop
                    , String.fromInt options.duration ++ "ms"
                    , "ease-in-out"
                    ]
            )
        |> String.join ", "
        |> style "transition"
        |> Element.htmlAttribute
