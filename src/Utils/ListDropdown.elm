module Utils.ListDropdown exposing (DropdownModel, DropdownMsg(..), initListDropdown, listDropdown, updateListDropdown)

import Element exposing (Element, below, centerY, column, el, fill, focused, height, mouseOver, padding, paddingEach, pointer, px, rgb255, rgba255, row, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
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


listDropdown : String -> String -> List value -> (value -> String) -> DropdownModel value -> (DropdownMsg value -> msg) -> Element msg
listDropdown title description options toString model toMsg =
    let
        stateAttrs =
            case model.state of
                Opened ->
                    [ below (listDropdownBody description options toString ChangeSelected)
                        |> Element.mapAttribute toMsg
                    ]

                Closed ->
                    []
    in
    Input.button
        ([ pointer
         , focused [ Border.color <| rgba255 0 0 0 1 ]
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


listDropdownBody : String -> List value -> (value -> String) -> (Maybe value -> DropdownMsg value) -> Element (DropdownMsg value)
listDropdownBody description items toString onChange =
    let
        listTitle =
            el
                [ width fill
                , height <| px 34
                , padding 8
                , Font.semiBold
                , Background.color <| rgb255 0xF6 0xF8 0xFA
                ]
                (el [ centerY ] <| text description)

        itemButton _ value =
            el
                [ width fill
                , height <| px 34
                , paddingEach { left = 30, right = 8, top = 8, bottom = 8 }
                , pointer
                , Font.color <| rgb255 0x58 0x60 0x69
                , Border.color <| rgb255 0xEA 0xEC 0xEF
                , Border.widthEach
                    { left = 0
                    , right = 0
                    , top = 1
                    , bottom = 0
                    }
                , Events.onClick <| onChange (Just value)
                , mouseOver
                    [ Font.color <| rgb255 0xFF 0xFF 0xFF
                    , Background.color <| rgb255 0x03 0x66 0xD6
                    ]
                ]
                (el [ centerY ] <| text (toString value))
    in
    el
        [ paddingEach { top = 8, bottom = 8, left = 12, right = 0 }
        , Element.alignRight
        ]
    <|
        column
            [ width <| px 300
            , Font.size 12
            , Border.color <| rgba255 27 31 35 0.15
            , Border.width 1
            , Border.rounded 3
            , Border.shadow
                { offset = ( 0, 3 )
                , size = 0
                , blur = 12
                , color = rgba255 27 31 35 0.15
                }
            ]
            [ listTitle
            , column
                [ width fill
                , Background.color <| rgb255 0xFF 0xFF 0xFF
                ]
                (List.indexedMap itemButton items)
            ]
