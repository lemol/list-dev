module Utils.ListDropdown exposing (DropdownModel, DropdownMsg(..), initListDropdown, listDropdown, updateListDropdown)

import Element exposing (Element, below, column, el, mouseOver, pointer, rgb255, row, spacing, text)
import Element.Events as Events
import Element.Font as Font
import Element.Input as Input
import RemoteData exposing (RemoteData(..))



-- MODEL


type alias DropdownModel value =
    { state : DropdownState
    , selected : Maybe value
    }


type DropdownState
    = Opened
    | Closed


initListDropdown : Maybe value -> DropdownModel value
initListDropdown maybeValue =
    { state = Closed
    , selected = maybeValue
    }



-- MESSAGE


type DropdownMsg value
    = ChangeState DropdownState
    | ChangeSelected (Maybe value)



-- UPDATE


updateListDropdown : DropdownMsg value -> DropdownModel value -> DropdownModel value
updateListDropdown msg model =
    case msg of
        ChangeState newState ->
            { model | state = newState }

        ChangeSelected newSelected ->
            { model | selected = newSelected, state = Closed }



-- VIEW


listDropdown : String -> List value -> (value -> String) -> DropdownModel value -> (DropdownMsg value -> msg) -> Element msg
listDropdown title options toString model toMsg =
    let
        stateAttrs =
            case model.state of
                Opened ->
                    [ below (listDropdownButtonBody options toString ChangeSelected)
                        |> Element.mapAttribute toMsg
                    ]

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
                    (model.selected
                        |> Maybe.map toString
                        |> Maybe.withDefault "-"
                        |> text
                    )
                , text "▾"
                ]
        }


listDropdownButtonBody : List value -> (value -> String) -> (Maybe value -> DropdownMsg value) -> Element (DropdownMsg value)
listDropdownButtonBody items toString onChange =
    let
        itemButton value =
            el
                [ Events.onClick <| onChange (Just value) ]
            <|
                text (toString value)
    in
    column []
        (items
            |> List.map itemButton
        )
