module UI exposing (Document, mainFontFamily, responsive)

import Element exposing (Device, DeviceClass(..), Element)
import Element.Font as Font



-- DATA


type alias Document msg =
    { title : String
    , body : Element msg
    }



-- RESPONSIVE


responsive : Device -> { x | phone : a, desktop : a } -> a
responsive device { phone, desktop } =
    case device.class of
        Phone ->
            phone

        _ ->
            desktop



-- VALUES


mainFontFamily : List Font.Font
mainFontFamily =
    List.map Font.typeface
        [ "-apple-system"
        , "BlinkMacSystemFont"
        , "Segoe UI"
        , "Helvetica"
        , "Arial"
        , "sans-serif"
        , "Apple Color Emoji"
        , "Segoe UI Emoji"
        ]
