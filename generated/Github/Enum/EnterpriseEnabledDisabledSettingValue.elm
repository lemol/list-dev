-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Github.Enum.EnterpriseEnabledDisabledSettingValue exposing (..)

import Json.Decode as Decode exposing (Decoder)


{-| The possible values for an enabled/disabled enterprise setting.

  - Disabled - The setting is disabled for organizations in the enterprise.
  - Enabled - The setting is enabled for organizations in the enterprise.
  - NoPolicy - There is no policy set for organizations in the enterprise.

-}
type EnterpriseEnabledDisabledSettingValue
    = Disabled
    | Enabled
    | NoPolicy


list : List EnterpriseEnabledDisabledSettingValue
list =
    [ Disabled, Enabled, NoPolicy ]


decoder : Decoder EnterpriseEnabledDisabledSettingValue
decoder =
    Decode.string
        |> Decode.andThen
            (\string ->
                case string of
                    "DISABLED" ->
                        Decode.succeed Disabled

                    "ENABLED" ->
                        Decode.succeed Enabled

                    "NO_POLICY" ->
                        Decode.succeed NoPolicy

                    _ ->
                        Decode.fail ("Invalid EnterpriseEnabledDisabledSettingValue type, " ++ string ++ " try re-running the @dillonkearns/elm-graphql CLI ")
            )


{-| Convert from the union type representating the Enum to a string that the GraphQL server will recognize.
-}
toString : EnterpriseEnabledDisabledSettingValue -> String
toString enum =
    case enum of
        Disabled ->
            "DISABLED"

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
fromString : String -> Maybe EnterpriseEnabledDisabledSettingValue
fromString enumString =
    case enumString of
        "DISABLED" ->
            Just Disabled

        "ENABLED" ->
            Just Enabled

        "NO_POLICY" ->
            Just NoPolicy

        _ ->
            Nothing
