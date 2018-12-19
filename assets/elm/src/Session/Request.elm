module Session.Request exposing (login)

import Session.AuthToken as AuthToken exposing (AuthToken)
import User exposing (User)
import Session exposing (Session)
import Http
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
import Api exposing (apiUrl)


login : { r | email : String, password : String } -> Http.Request Session
login { email, password } =
    let
        user =
            Encode.object
                [ "email" => Encode.string email
                , "password" => Encode.string password
                ]

        body =
            user
                |> Http.jsonBody
    in
        decodeSessionResponse
            |> Http.post (apiUrl "/sessions") body


decodeSessionResponse : Decoder Session
decodeSessionResponse =
    Decode.map2 Session
        (Decode.field "data" User.decoder)
        (Decode.at [ "meta", "token" ] AuthToken.decoder)


register : { r | name : String, email : String, password : String } -> Http.Request Session
register { name, email, password } =
    let
        user =
            Encode.object
                [ "name" => Encode.string name
                , "email" => Encode.string email
                , "password" => Encode.string password
                ]

        body =
            user
                |> Http.jsonBody
    in
        decodeSessionResponse
            |> Http.post (apiUrl "/users") body


logout : Maybe Session -> Http.Request ()
logout session =
    let
        expectNothing =
            Http.expectStringResponse (\_ -> Ok ())
    in
        apiUrl "/sessions"
            |> HttpBuilder.delete
            |> HttpBuilder.withExpect expectNothing
            |> withAuthorization session
