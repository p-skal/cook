module Session exposing (..)

import Session.AuthToken as AuthToken exposing (AuthToken, decoder)
import User exposing (User, decoder)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (required, optional)
import Json.Encode as Encode exposing (Value)


type alias Session =
    { user : User
    , token : AuthToken
    }


decoder : Decoder Session
decoder =
    Decode.succeed Session
        |> required "user" User.decoder
        |> required "token" AuthToken.decoder


encode : Session -> Value
encode session =
    Encode.object
        [ ( "user", User.encode session.user )
        , ( "token", AuthToken.encode session.token )
        ]
