-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Github.Enum.EnterpriseEnabledSettingValue exposing (..)

import Json.Decode as Decode exposing (Decoder)


{-| The possible values for an enabled/no policy enterprise setting.

  - Enabled - The setting is enabled for organizations in the enterprise.
  - NoPolicy - There is no policy set for organizations in the enterprise.

-}
type EnterpriseEnabledSettingValue
    = Enabled
    | NoPolicy


list : List EnterpriseEnabledSettingValue
list =
    [ Enabled, NoPolicy ]


decoder : Decoder EnterpriseEnabledSettingValue
decoder =
    Decode.string
        |> Decode.andThen
            (\string ->
                case string of
                    "ENABLED" ->
                        Decode.succeed Enabled

                    "NO_POLICY" ->
                        Decode.succeed NoPolicy

                    _ ->
                        Decode.fail ("Invalid EnterpriseEnabledSettingValue type, " ++ string ++ " try re-running the @dillonkearns/elm-graphql CLI ")
            )


{-| Convert from the union type representating the Enum to a string that the GraphQL server will recognize.
-}
toString : EnterpriseEnabledSettingValue -> String
toString enum =
    case enum of
        Enabled ->
            "ENABLED"

        NoPolicy ->
            "NO_POLICY"


{-| Convert from a String representation to an elm representation enum.
This is the inverse of the Enum `toString` function. So you can call `toString` and then convert back `fromString` safely.

    Swapi.Enum.Episode.NewHope
        |> Swapi.Enum.Episode.toString
        |> Swapi.Enum.Episode.fromString
        == Just NewHope

This can be useful for generating Strings to use for <select> menus to check which item was selected.

-}
fromString : String -> Maybe EnterpriseEnabledSettingValue
fromString enumString =
    case enumString of
        "ENABLED" ->
            Just Enabled

        "NO_POLICY" ->
            Just NoPolicy

        _ ->
            Nothing
