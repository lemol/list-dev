module Explorer exposing (main)

import Element exposing (Element, layout)
import Element.Background as Background
import Element.Font as Font
import Html exposing (Html)
import UI.Button as Button
import UI.Icon as Icon
import UI.Input as Input
import UI.SelectMenu as SelectMenu
import UIExplorer exposing (UIExplorerProgram, defaultConfig, explore, storiesOf)


type alias Model =
    { searchBoxText : String }


type Msg
    = NoOp
    | SearchBoxChanged String


update : Msg -> UIExplorer.Model Model Msg {} -> UIExplorer.Model Model Msg {}
update msg model =
    case msg of
        NoOp ->
            model

        SearchBoxChanged newText ->
            { model
                | customModel =
                    { searchBoxText = newText
                    }
            }


config : UIExplorer.Config Model Msg {}
config =
    { customModel = { searchBoxText = "" }
    , customHeader = Nothing
    , update = update
    , viewEnhancer = \m stories -> stories
    , menuViewEnhancer = \m v -> v
    }


main : UIExplorerProgram Model Msg {}
main =
    explore
        config
        [ storiesOf
            "TextButton"
            [ ( "Default", \_ -> Button.githubTextButton "Submit" |> toHtml, {} )
            ]
        , storiesOf
            "LinkButton"
            [ ( "Default", \_ -> Button.githubLinkButton "#" "Submit" |> toHtml, {} )
            ]
        , storiesOf
            "SelectMenu"
            [ ( "Closed"
              , \_ ->
                    SelectMenu.viewButton [ Element.centerX ]
                        { title = "Sort:"
                        , defaultText = "Select"
                        , popup = selectMenuPopup False False
                        }
                        |> toHtml
              , {}
              )
            , ( "Open"
              , \_ ->
                    SelectMenu.viewButton [ Element.centerX ]
                        { title = "Sort:"
                        , defaultText = "Select"
                        , popup = selectMenuPopup True False
                        }
                        |> toHtml
              , {}
              )
            , ( "With Filters"
              , \_ ->
                    SelectMenu.viewButton [ Element.centerX ]
                        { title = "Sort:"
                        , defaultText = "Select"
                        , popup = selectMenuPopup True True
                        }
                        |> toHtml
              , {}
              )
            ]
        , storiesOf
            "Icons"
            [ ( "Default"
              , \_ ->
                    Element.row [ Element.spacing 8, Element.width Element.fill ]
                        [ Element.el [] (Icon.checkIcon [])
                        , Element.el [] (Icon.threeBarsIcon [])
                        ]
                        |> toHtml
              , {}
              )
            , ( "Colored"
              , \_ ->
                    Element.row [ Element.spacing 8, Element.width Element.fill ]
                        [ Element.el [ Font.color <| Element.rgb255 0xFF 0 0 ] (Icon.checkIcon [])
                        , Element.el [ Font.color <| Element.rgb255 0xFF 0 0 ] (Icon.threeBarsIcon [])
                        ]
                        |> toHtml
              , {}
              )
            ]
        , storiesOf
            "SearchBox"
            [ ( "Default"
              , \model ->
                    Input.searchBox
                        []
                        { placeholder = Just "Search users..."
                        , onChange = SearchBoxChanged
                        , text = model.customModel.searchBoxText
                        }
                        |> Element.el
                            [ Element.padding 10
                            , Background.color <| Element.rgb255 0x24 0x29 0x2E
                            ]
                        |> toHtml
              , {}
              )
            ]
        ]


selectMenuPopup : Bool -> Bool -> SelectMenu.SelectMenuPopup String Msg
selectMenuPopup open showFilter =
    { title = "Sort options"
    , options = Just [ "OK", "OK2", "OK3" ]
    , toString = always "OK"
    , showFilter = showFilter
    , model =
        let
            init =
                SelectMenu.init (Just "OK")
        in
        { init | open = open }
    , toMsg = always NoOp
    , device = Element.classifyDevice { width = 1024, height = 1024 }
    }


toHtml : Element msg -> Html msg
toHtml =
    layout [ Element.width Element.fill ]
