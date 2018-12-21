module Cook exposing (..)

import Json.Decode as Decode exposing (Decoder, maybe)
import Json.Decode.Pipeline exposing (required, optional)
import Json.Encode as Encode exposing (Value)
import Helpers.Encode as Encode


type alias CooksResponse =
    { cooks : List Cook
    }


type alias Cook =
    { name : String
    , handle : String
    , date_joined : String
    }


cooksDecoder : Decoder CooksResponse
cooksDecoder =
    Decode.succeed CooksResponse
        |> required "users" (Decode.list cookDecoder)


cookDecoder : Decoder Cook
cookDecoder =
    Decode.succeed Cook
        |> required "name" Decode.string
        |> required "handle" (Decode.string)
        |> required "date_joined" (Decode.string)


encodeCook : Cook -> Value
encodeCook cook =
    Encode.object
        [ ( "name", Encode.string cook.name )
        , ( "handle", (Encode.string) cook.handle )
        ]
