module Pages.DeveloperList exposing (Model, Msg, init, update, view)

import Data.App exposing (AppData, Document, responsive)
import Data.Developer exposing (..)
import Element exposing (..)
import Element.Border as Border
import Element.Font as Font
import Element.Region as Region
import Html
import Html.Attributes exposing (src, style, target)
import Layout.Main as MainLayout
import Layout.Trending as Layout
import RemoteData exposing (RemoteData(..))
import UI.Button exposing (githubTextLink)
import UI.SelectMenu as SelectMenu



-- DATA


type alias PageConfig msg =
    { toMsg : Msg -> msg }



-- MODEL


type alias Model =
    { --
      -- PAGE MODEL
      sort : Maybe Sort
    , language : Maybe Language

    -- REMOTE DATA
    , developers : DeveloperListWebData
    , languages : LanguageListWebData

    -- COMPONENTS DATA
    , sortSelectMenu : SelectMenu.State Sort
    , languageSelectMenu : SelectMenu.State Language
    }


init : ( Model, Cmd Msg )
init =
    ( { sort = Nothing
      , language = Nothing
      , developers = NotAsked
      , languages = NotAsked
      , sortSelectMenu = SelectMenu.init (Just BestMatch)
      , languageSelectMenu = SelectMenu.init Nothing
      }
    , Cmd.batch
        [ fetchDeveloperList Nothing Nothing FetchDeveloperListResponse
        , fetchLanguageList FetchLanguageListResponse
        ]
    )



-- MESSAGE


type Msg
    = ChangeSort (Maybe Sort)
    | ChangeLanguage (Maybe Language)
    | FetchDeveloperList
    | FetchDeveloperListResponse DeveloperListWebData
    | FetchLanguageListResponse LanguageListWebData
    | SortSelectMsg (SelectMenu.Msg Sort)
    | LanguageSelectMsg (SelectMenu.Msg Language)



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeSort newSort ->
            update FetchDeveloperList { model | sort = newSort }

        ChangeLanguage newLanguage ->
            update FetchDeveloperList { model | language = newLanguage }

        FetchDeveloperList ->
            ( model
              -- Set Loading state??
            , fetchDeveloperList model.sort model.language FetchDeveloperListResponse
            )

        FetchDeveloperListResponse response ->
            ( { model | developers = response }
            , Cmd.none
            )

        FetchLanguageListResponse response ->
            ( { model | languages = response }
            , Cmd.none
            )

        SortSelectMsg subMsg ->
            SelectMenu.updateState
                { changeSelected = Just ChangeSort
                , changeFilter = Nothing
                , getter = .sortSelectMenu
                , setter = \m s -> { m | sortSelectMenu = s }
                , update = update
                }
                subMsg
                model

        LanguageSelectMsg subMsg ->
            SelectMenu.updateState
                { changeSelected = Just ChangeLanguage
                , changeFilter = Nothing
                , getter = .languageSelectMenu
                , setter = \m s -> { m | languageSelectMenu = s }
                , update = update
                }
                subMsg
                model



-- VIEW


view : PageConfig msg -> MainLayout.PageData msg -> Layout.PageData msg -> Model -> Document msg
view { toMsg } mainLayout layout model =
    Layout.view
        { toMsg = layout.toMsg
        , page =
            { title = "Developers"
            , subTitle = "These are the developers based in Angola building the hot tools on Github."
            , page = Layout.Developers
            , filter = filterView mainLayout.app model |> (Element.map toMsg >> Just)
            , body = body mainLayout.app.device model |> Element.map toMsg
            }
        }
        mainLayout
        layout.model


filterView : AppData -> Model -> Element Msg
filterView { device } model =
    let
        container =
            responsive device
                { phone = column
                , desktop = wrappedRow
                }
    in
    container
        [ responsive device
            { phone = alignLeft, desktop = alignRight }
        , spacingXY 32 16
        ]
        [ SelectMenu.view
            []
            { title = "Language:"
            , description = "Select a language"
            , defaultText = "Any"
            , options = languageValues model.languages
            , toString = languageToString
            , showFilter = True
            , model = model.languageSelectMenu
            , toMsg = LanguageSelectMsg
            , device = device
            }
        , SelectMenu.view
            []
            { title = "Sort:"
            , description = "Sort options"
            , defaultText = "Select"
            , options = sortValues
            , toString = sortToString
            , showFilter = False
            , model = model.sortSelectMenu
            , toMsg = SortSelectMsg
            , device = device
            }
        ]


body : Device -> Model -> Element Msg
body device model =
    case model.developers of
        Success [] ->
            emptyListView model.language

        Success developers ->
            developerListView device developers

        Failure _ ->
            text "Something is wrong :("

        Loading ->
            text "Loading..."

        NotAsked ->
            none


emptyListView : Maybe Language -> Element msg
emptyListView language =
    let
        lang =
            Maybe.withDefault "Any Language" language
    in
    column
        [ centerX
        , centerY
        , padding 32
        , spacing 4
        , Font.color <| rgb255 0x24 0x29 0x2E
        ]
        [ paragraph
            [ Region.heading 3
            , Font.center
            , Font.semiBold
            , Font.size 20
            ]
            [ text <| "It looks like there is not any developer in Angola for " ++ lang ++ "." ]
        , paragraph
            [ centerX
            , Font.size 14
            , Font.center
            ]
            [ text <| "If you "
            , link
                [ Font.color <| rgb255 3 102 214 ]
                { url = "https://github.com/new"
                , label =
                    text <| "you create an " ++ lang
                }
            , text <| ", you can really own the place."
            ]
        , paragraph
            [ Font.center
            , Font.size 14
            ]
            [ text "We’d even let it slide if you started calling yourself the mayor." ]
        ]


developerListView : Device -> List Developer -> Element Msg
developerListView device =
    List.indexedMap (developerListItemView device) >> column [ width fill ]


developerListItemView : Device -> Int -> Developer -> Element Msg
developerListItemView device count developer =
    wrappedRow
        [ width fill
        , padding 16
        , spacing 8
        , Border.color <| rgb255 209 213 218
        , Border.widthEach
            { bottom = 0
            , top =
                if count == 0 then
                    0

                else
                    1
            , left = 0
            , right = 0
            }
        ]
        [ el
            [ Font.size 32
            , Font.color <| rgb255 88 96 105
            ]
            (text <| String.fromInt (count + 1))
        , link
            [ htmlAttribute <| target "_blank" ]
            { url = developer.htmlUrl
            , label =
                el
                    [ width fill
                    , spacing 12
                    ]
                <|
                    html <|
                        Html.img
                            [ style "width" "48px"
                            , style "height" "52px"
                            , style "border-radius" "3px"
                            , style "border-width" "1px"
                            , src developer.avatar
                            ]
                            []
            }
        , responsive device
            { desktop = wrappedRow, phone = column }
            [ width fill
            , spacing 8
            ]
            [ link
                [ htmlAttribute <| target "_blank" ]
                { url = developer.htmlUrl
                , label =
                    column
                        [ spacing 4 ]
                        [ el
                            [ Font.size 20
                            , Font.bold
                            , Font.color <| rgb255 3 102 214
                            ]
                            (text developer.name)
                        , el
                            [ Font.size 16
                            , Font.color <| rgb255 88 96 105
                            , mouseOver [ Font.color <| rgb255 3 102 214 ]
                            ]
                            (text developer.login)
                        ]
                }
            , popularRepoView developer
            , el [ responsive device { desktop = alignRight, phone = alignLeft } ] (githubTextLink developer.htmlUrl "Profile")
            ]
        ]


popularRepoView : Developer -> Element msg
popularRepoView developer =
    case developer.popularRepo of
        Nothing ->
            Element.none

        Just popularRepo ->
            column
                [ width (fill |> maximum 300)
                , spacingXY 0 9
                ]
                [ el
                    [ Font.size 16
                    , Font.variant Font.smallCaps
                    , Font.color <| rgb255 88 96 105
                    ]
                    (text "popular repo")
                , link
                    [ Font.size 16
                    , Font.color <| rgb255 3 102 214
                    , Font.semiBold
                    ]
                    { url = "#", label = text popularRepo.name }
                , paragraph
                    [ Font.size 12
                    , Font.color <| rgb255 88 96 105
                    ]
                    [ text popularRepo.description ]
                ]
