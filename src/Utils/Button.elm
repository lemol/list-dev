module Utils.Button exposing (githubTextButton, githubTextLink)

import Element exposing (Element, centerY, el, focused, height, link, mouseOver, paddingXY, px, rgb255, rgba255, text)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import RemoteData exposing (RemoteData(..))


githubTextButton : String -> Element msg
githubTextButton label =
    Input.button
        [ height <| px 28
        , paddingXY 10 3
        , Font.size 12
        , Font.semiBold
        , Background.color <| rgb255 239 243 246
        , Border.color <| rgba255 27 31 35 0.2
        , Border.width 1
        , Border.rounded 3
        , mouseOver
            [ Background.color <| rgb255 230 235 241
            , Border.color <| rgba255 27 31 35 0.35
            ]
        , focused
            [ Background.color <| rgb255 0xFF 0x00 0x00 ]
        ]
        { onPress = Nothing
        , label = text label
        }


githubTextLink : String -> String -> Element msg
githubTextLink url label =
    link
        [ height <| px 28
        , paddingXY 10 3
        , Font.size 12
        , Font.semiBold
        , Background.color <| rgb255 239 243 246
        , Border.color <| rgba255 27 31 35 0.2
        , Border.width 1
        , Border.rounded 3
        , mouseOver
            [ Background.color <| rgb255 230 235 241
            , Border.color <| rgba255 27 31 35 0.35
            ]
        ]
        { url = url
        , label = el [ centerY ] (text label)
        }
