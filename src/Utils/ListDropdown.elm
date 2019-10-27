module Utils.ListDropdown exposing (DropdownModel, DropdownMsg(..), initListDropdown, listDropdown, updateListDropdown)

import Element exposing (Element, below, column, el, mouseOver, pointer, rgb255, row, spacing, text)
import Element.Events as Events
import Element.Font as Font
import Element.Input as Input
import RemoteData exposing (RemoteData(..))



-- MODEL


type alias DropdownModel =
    { state : DropdownState
    , selected : String
    }


type DropdownState
    = Opened
    | Closed


initListDropdown : DropdownModel
initListDropdown =
    { state = Closed
    , selected = "BestMatch"
    }



-- MESSAGE


type DropdownMsg
    = ChangeState DropdownState
    | ChangeSelected String



-- UPDATE


updateListDropdown : DropdownMsg -> DropdownModel -> DropdownModel
updateListDropdown msg model =
    case msg of
        ChangeState newState ->
            { model | state = newState }

        ChangeSelected newSelected ->
            { model | selected = newSelected, state = Closed }



-- VIEW


listDropdown : String -> List String -> DropdownModel -> (DropdownMsg -> msg) -> Element msg
listDropdown title options model toMsg =
    let
        stateAttrs =
            case model.state of
                Opened ->
                    [ below (listDropdownButtonBody options ChangeSelected) |> Element.mapAttribute toMsg ]

                Closed ->
                    []
    in
    Input.button
        ([ pointer
         , Events.onLoseFocus (toMsg <| ChangeState Closed)
         ]
            ++ stateAttrs
        )
        { onPress = Nothing
        , label =
            row
                [ spacing 4
                , Font.size 14
                , Font.color <| rgb255 88 96 105
                , mouseOver
                    [ Font.color <| rgb255 36 41 46 ]
                , Events.onClick (toMsg <| ChangeState Opened)
                , Events.onFocus (toMsg <| ChangeState Opened)
                ]
                [ el
                    []
                    (text title)
                , el
                    [ Font.semiBold
                    ]
                    (text model.selected)
                , text "▾"
                ]
        }


listDropdownButtonBody : List String -> (String -> DropdownMsg) -> Element DropdownMsg
listDropdownButtonBody items onChange =
    let
        itemButton val =
            el
                [ Events.onClick <| onChange val ]
            <|
                text val
    in
    column []
        (items
            |> List.map itemButton
        )
