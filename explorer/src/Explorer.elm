module Explorer exposing (main)

import Element exposing (Element, layout)
import Element.Font as Font
import Html exposing (Html)
import UI.Button as Button
import UI.Icon as Icon
import UI.SelectMenu as SelectMenu
import UIExplorer exposing (UIExplorerProgram, defaultConfig, explore, storiesOf)


main : UIExplorerProgram {} () {}
main =
    explore
        defaultConfig
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
        ]


selectMenuPopup : Bool -> Bool -> SelectMenu.SelectMenuPopup String ()
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
    , toMsg = always ()
    , device = Element.classifyDevice { width = 1024, height = 1024 }
    }


toHtml : Element msg -> Html msg
toHtml =
    layout [ Element.width Element.fill ]
