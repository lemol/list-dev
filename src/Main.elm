module Main exposing (main)

import Element exposing (fill, height, layout, row, text, width)
import Html exposing (Html)


main : Html msg
main =
    view


view : Html msg
view =
    layout [] <|
        row
            [ height fill
            , width fill
            ]
            [ text "angolans in github" ]
