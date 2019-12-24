module Routing exposing (Route(..), RoutingType(..), parseUrl, toUrl)

import Url exposing (Url)
import Url.Parser exposing (Parser, map, oneOf, parse, s, top)


type RoutingType
    = HashRouting
    | BrowserRouting


type Route
    = NotFoundRoute
    | DevListRoute
    | RepoListRoute


routingType : RoutingType
routingType =
    BrowserRouting


parseUrl : Url -> Route
parseUrl url =
    let
        newUrl =
            case routingType of
                HashRouting ->
                    { url | path = url.fragment |> Maybe.withDefault "" }

                BrowserRouting ->
                    url
    in
    case parse matchRoute newUrl of
        Just route ->
            route

        Nothing ->
            NotFoundRoute


matchRoute : Parser (Route -> a) a
matchRoute =
    oneOf
        [ map DevListRoute top
        , map DevListRoute (s "developers")
        , map RepoListRoute (s "repositories")
        ]


toUrl : Route -> String
toUrl route =
    let
        prefix =
            case routingType of
                HashRouting ->
                    "#"

                BrowserRouting ->
                    ""

        path =
            case route of
                NotFoundRoute ->
                    "/404"

                DevListRoute ->
                    "/developers"

                RepoListRoute ->
                    "/repositories"
    in
    prefix ++ path
