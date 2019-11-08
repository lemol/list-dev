module Routing exposing (Route(..), parseUrl, toUrl)

import Url exposing (Url)
import Url.Parser exposing (Parser, map, oneOf, parse, s, top)


type Route
    = NotFoundRoute
    | DevListRoute
    | RepoListRoute


parseUrl : Url -> Route
parseUrl url =
    case parse matchRoute url of
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
    case route of
        NotFoundRoute ->
            "/404"

        DevListRoute ->
            "/developers"

        RepoListRoute ->
            "/repositories"
