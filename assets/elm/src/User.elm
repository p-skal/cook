module User exposing (..)

import Json.Decode as Decode exposing (Decoder, maybe)
import Json.Decode.Pipeline exposing (required, optional)
import Json.Encode as Encode exposing (Value)


type alias User =
    { email : String
    , name : String
    , handle : String
    }


decoder : Decoder User
decoder =
    Decode.succeed User
        |> required "email" Decode.string
        |> required "name" (Decode.string)
        |> required "handle" (Decode.string)


encode : User -> Value
encode user =
    Encode.object
        [ ( "email", Encode.string user.email )
        , ( "name", (Encode.string) user.name )
        , ( "handle", (Encode.string) user.handle )
        ]
