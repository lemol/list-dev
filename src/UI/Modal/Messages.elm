module UI.Modal.Messages exposing (..)

import Global
import UI.Modal exposing (Msg(..))
import UI.Modal.Data exposing (Modal)



-- MESSAGES


openModal : Modal -> Global.Msg
openModal modal =
    Global.ModalMsg (Open modal)


closeModal : Global.Msg
closeModal =
    Global.ModalMsg Close
