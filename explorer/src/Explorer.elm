module Explorer exposing (main)

import Element exposing (Element, layout)
import Html exposing (Html)
import UI.Button as Button
import UIExplorer exposing (UIExplorerProgram, defaultConfig, explore, storiesOf)


main : UIExplorerProgram {} () {}
main =
    explore
        defaultConfig
        [ storiesOf
            "Button"
            [ ( "Text", \_ -> Button.githubTextButton "Submit" |> toHtml, {} )
            , ( "Link", \_ -> Button.githubLinkButton "#" "Submit" |> toHtml, {} )
            ]
        ]


toHtml : Element msg -> Html msg
toHtml =
    layout []
