module Pages.DeveloperList exposing (Model, Msg, init, languageMenuPopup, locationMenuPopup, onSetAuth, sortMenuPopup, update, view)

import Data.Developer exposing (..)
import Data.Developer.Api exposing (..)
import Element exposing (..)
import Element.Border as Border
import Element.Font as Font
import Element.Region as Region
import Global
import Html
import Html.Attributes exposing (src, style, target)
import Layout.Main as MainLayout
import Layout.Trending as Layout
import RemoteData exposing (RemoteData(..))
import UI exposing (Document, responsive)
import UI.Button exposing (githubLinkButton)
import UI.Modal.Data as Modal
import UI.Modal.Messages exposing (closeModal, openModal)
import UI.SelectMenu as SelectMenu



-- DATA


type alias PageConfig msg =
    { toMsg : Msg -> msg
    , layoutToMsg : Layout.Msg -> msg
    , mainLayoutToMsg : MainLayout.Msg -> msg
    }



-- MODEL


type alias Model =
    { --
      -- PAGE MODEL
      sort : Maybe Sort
    , language : Maybe Language

    -- REMOTE DATA
    , developers : DeveloperListWebData
    , languages : LanguageListWebData
    , locations : LocationListWebData

    -- COMPONENTS DATA
    , sortSelectMenu : SelectMenu.State Sort
    , languageSelectMenu : SelectMenu.State Language
    , locationSelectMenu : SelectMenu.State Location
    }


init : Global.Model -> ( Model, Cmd Msg )
init global =
    ( { sort = Nothing
      , language = Nothing
      , developers = NotAsked
      , languages = NotAsked
      , locations = NotAsked
      , sortSelectMenu = SelectMenu.init (Just BestMatch)
      , languageSelectMenu = SelectMenu.init Nothing
      , locationSelectMenu = SelectMenu.init Nothing
      }
    , Cmd.batch
        [ fetchDeveloperList global.auth global.location Nothing Nothing FetchDeveloperListResponse
        , fetchLanguageList FetchLanguageListResponse
        , fetchLocationList FetchLocationListResponse
        ]
    )



-- MESSAGE


type Msg
    = ChangeSort (Maybe Sort)
    | ChangeLanguage (Maybe Language)
    | ChangeLocation (Maybe Location)
    | FetchDeveloperList
    | FetchDeveloperListResponse DeveloperListWebData
    | FetchLanguageListResponse LanguageListWebData
    | FetchLocationListResponse LocationListWebData
    | SortSelectMsg (SelectMenu.Msg Sort)
    | LanguageSelectMsg (SelectMenu.Msg Language)
    | LocationSelectMsg (SelectMenu.Msg Location)



-- UPDATE


update : Msg -> Global.Model -> Model -> ( Model, Cmd Msg, List Global.Msg )
update msg global model =
    case msg of
        ChangeSort newSort ->
            update FetchDeveloperList global { model | sort = newSort }

        ChangeLanguage newLanguage ->
            update FetchDeveloperList global { model | language = newLanguage }

        ChangeLocation newLocation ->
            ( model
            , fetchDeveloperList global.auth newLocation model.sort model.language FetchDeveloperListResponse
            , [ Global.ChangeLocation newLocation ]
            )

        FetchDeveloperList ->
            ( model
              -- Set Loading state??
            , fetchDeveloperList global.auth global.location model.sort model.language FetchDeveloperListResponse
            , []
            )

        FetchDeveloperListResponse response ->
            ( { model | developers = response }
            , Cmd.none
            , []
            )

        FetchLanguageListResponse response ->
            ( { model | languages = response }
            , Cmd.none
            , []
            )

        FetchLocationListResponse response ->
            ( { model | locations = response }
            , Cmd.none
            , []
            )

        SortSelectMsg subMsg ->
            let
                ( newModel1, msgs ) =
                    SelectMenu.updateState
                        { changeSelected = Just ChangeSort
                        , changeFilter = Nothing
                        , getter = .sortSelectMenu
                        , setter = \m s -> { m | sortSelectMenu = s }
                        }
                        subMsg
                        model

                modalOpenMsg =
                    responsive global.device
                        { desktop = []
                        , phone =
                            case subMsg of
                                SelectMenu.SetOpen True ->
                                    [ openSortModal ]

                                SelectMenu.SetSelected _ ->
                                    [ closeModal ]

                                _ ->
                                    []
                        }

                ( newModel, cmd, globalMsg ) =
                    msgs
                        |> List.foldl (foldUpdate global) ( newModel1, Cmd.none, modalOpenMsg )
            in
            ( newModel
            , cmd
            , globalMsg
            )

        LanguageSelectMsg subMsg ->
            let
                ( newModel1, msgs ) =
                    SelectMenu.updateState
                        { changeSelected = Just ChangeLanguage
                        , changeFilter = Nothing
                        , getter = .languageSelectMenu
                        , setter = \m s -> { m | languageSelectMenu = s }
                        }
                        subMsg
                        model

                modalOpenMsg =
                    responsive global.device
                        { desktop = []
                        , phone =
                            case subMsg of
                                SelectMenu.SetOpen True ->
                                    [ openLanguageModal ]

                                SelectMenu.SetSelected _ ->
                                    [ closeModal ]

                                _ ->
                                    []
                        }

                ( newModel, cmd, globalMsg ) =
                    msgs
                        |> List.foldl (foldUpdate global) ( newModel1, Cmd.none, modalOpenMsg )
            in
            ( newModel
            , cmd
            , globalMsg
            )

        LocationSelectMsg subMsg ->
            let
                ( newModel1, msgs ) =
                    SelectMenu.updateState
                        { changeSelected = Just ChangeLocation
                        , changeFilter = Nothing
                        , getter = .locationSelectMenu
                        , setter = \m s -> { m | locationSelectMenu = s }
                        }
                        subMsg
                        model

                modalOpenMsg =
                    responsive global.device
                        { desktop = []
                        , phone =
                            case subMsg of
                                SelectMenu.SetOpen True ->
                                    [ openLocationModal ]

                                SelectMenu.SetSelected _ ->
                                    [ closeModal ]

                                _ ->
                                    []
                        }

                ( newModel, cmd, globalMsg ) =
                    msgs
                        |> List.foldl (foldUpdate global) ( newModel1, Cmd.none, modalOpenMsg )
            in
            ( newModel
            , cmd
            , globalMsg
            )


foldUpdate : Global.Model -> Msg -> ( Model, Cmd Msg, List Global.Msg ) -> ( Model, Cmd Msg, List Global.Msg )
foldUpdate modelGlobal msgAct ( modelAcc, cmdAcc, globalMsgAcc ) =
    let
        ( newModelAct, newCmdAct, globalMsgAct ) =
            update msgAct modelGlobal modelAcc
    in
    ( newModelAct
    , Cmd.batch [ cmdAcc, newCmdAct ]
    , globalMsgAcc ++ globalMsgAct
    )


onSetAuth : Global.Model -> Model -> Global.AuthState -> Cmd Msg
onSetAuth { location } { sort, language } auth =
    fetchDeveloperList auth location sort language FetchDeveloperListResponse



-- VIEW


view : PageConfig msg -> MainLayout.Model -> Layout.Model -> Global.Model -> Model -> Document msg
view config mainLayoutModel layoutModel global model =
    Layout.view
        { toMsg = config.layoutToMsg
        , mainLayoutToMsg = config.mainLayoutToMsg
        , page =
            { title = "Developers"
            , subTitle =
                "These are the developers"
                    ++ (global.location
                            |> Maybe.map ((++) " based in ")
                            |> Maybe.withDefault ""
                       )
                    ++ " building the hot tools on Github."
            , page = Layout.Developers
            , filter = filterView global model |> (Element.map config.toMsg >> Just)
            , body = body global model |> Element.map config.toMsg
            }
        }
        mainLayoutModel
        global
        layoutModel


filterView : Global.Model -> Model -> Element Msg
filterView global model =
    let
        container =
            responsive global.device
                { phone = column
                , desktop = wrappedRow
                }
    in
    container
        [ responsive global.device
            { phone = alignLeft, desktop = alignRight }
        , spacingXY 32 16
        ]
        [ SelectMenu.viewButton
            []
            { title = "Location:"
            , defaultText = "Any"
            , popup = locationMenuPopup global model
            }
        , SelectMenu.viewButton
            []
            { title = "Language:"
            , defaultText = "Any"
            , popup = languageMenuPopup global model
            }
        , SelectMenu.viewButton
            []
            { title = "Sort:"
            , defaultText = "Select"
            , popup = sortMenuPopup global model
            }
        ]


body : Global.Model -> Model -> Element Msg
body { device, location } model =
    case model.developers of
        Success [] ->
            emptyListView location model.language

        Success developers ->
            developerListView device developers

        Failure _ ->
            text "Something is wrong :("

        Loading ->
            text "Loading..."

        NotAsked ->
            none


emptyListView : Maybe Location -> Maybe Language -> Element msg
emptyListView location language =
    let
        lang =
            Maybe.withDefault "Any Language" language
        loc =
            location
            |> Maybe.map ((++) " in ")
            |> Maybe.withDefault ""
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
            [ text <| "It looks like there is not any developer" ++ loc ++ " for " ++ lang ++ "." ]
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
                [ htmlAttribute <| target "_blank"
                , responsive device
                    { desktop = width <| px 300
                    , phone = htmlAttribute <| Html.Attributes.classList []
                    }
                ]
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
            , el [ responsive device { desktop = alignRight, phone = alignLeft } ] (githubLinkButton developer.htmlUrl "Profile")
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



-- UTILS


openSortModal : Global.Msg
openSortModal =
    openModal Modal.DevListSort


openLanguageModal : Global.Msg
openLanguageModal =
    openModal Modal.DevListLanguage


openLocationModal : Global.Msg
openLocationModal =
    openModal Modal.DevListLocation



-- POPUPS


sortMenuPopup : Global.Model -> Model -> SelectMenu.SelectMenuPopup Sort Msg
sortMenuPopup global model =
    { title = "Sort options"
    , options = sortValues
    , toString = sortToString
    , showFilter = False
    , model = model.sortSelectMenu
    , toMsg = SortSelectMsg
    , device = global.device
    }


languageMenuPopup : Global.Model -> Model -> SelectMenu.SelectMenuPopup Language Msg
languageMenuPopup global model =
    { title = "Select a language"
    , options = languageValues model.languages
    , toString = languageToString
    , showFilter = True
    , model = model.languageSelectMenu
    , toMsg = LanguageSelectMsg
    , device = global.device
    }


locationMenuPopup : Global.Model -> Model -> SelectMenu.SelectMenuPopup Language Msg
locationMenuPopup global model =
    { title = "Select a location"
    , options = locationValues model.locations
    , toString = locationToString
    , showFilter = True
    , model = model.locationSelectMenu
    , toMsg = LocationSelectMsg
    , device = global.device
    }
