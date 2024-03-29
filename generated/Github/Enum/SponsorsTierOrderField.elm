-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Github.Enum.SponsorsTierOrderField exposing (..)

import Json.Decode as Decode exposing (Decoder)


{-| Properties by which Sponsors tiers connections can be ordered.

  - CreatedAt - Order tiers by creation time.
  - MonthlyPriceInCents - Order tiers by their monthly price in cents

-}
type SponsorsTierOrderField
    = CreatedAt
    | MonthlyPriceInCents


list : List SponsorsTierOrderField
list =
    [ CreatedAt, MonthlyPriceInCents ]


decoder : Decoder SponsorsTierOrderField
decoder =
    Decode.string
        |> Decode.andThen
            (\string ->
                case string of
                    "CREATED_AT" ->
                        Decode.succeed CreatedAt

                    "MONTHLY_PRICE_IN_CENTS" ->
                        Decode.succeed MonthlyPriceInCents

                    _ ->
                        Decode.fail ("Invalid SponsorsTierOrderField type, " ++ string ++ " try re-running the @dillonkearns/elm-graphql CLI ")
            )


{-| Convert from the union type representating the Enum to a string that the GraphQL server will recognize.
-}
toString : SponsorsTierOrderField -> String
toString enum =
    case enum of
        CreatedAt ->
            "CREATED_AT"

        MonthlyPriceInCents ->
            "MONTHLY_PRICE_IN_CENTS"


{-| Convert from a String representation to an elm representation enum.
This is the inverse of the Enum `toString` function. So you can call `toString` and then convert back `fromString` safely.

    Swapi.Enum.Episode.NewHope
        |> Swapi.Enum.Episode.toString
        |> Swapi.Enum.Episode.fromString
        == Just NewHope

This can be useful for generating Strings to use for <select> menus to check which item was selected.

-}
fromString : String -> Maybe SponsorsTierOrderField
fromString enumString =
    case enumString of
        "CREATED_AT" ->
            Just CreatedAt

        "MONTHLY_PRICE_IN_CENTS" ->
            Just MonthlyPriceInCents

        _ ->
            Nothing
