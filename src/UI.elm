module UI exposing (Document, responsive)

import Element exposing (Device, DeviceClass(..), Element)



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
