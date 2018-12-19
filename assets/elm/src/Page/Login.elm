module Page.Login exposing (ExternalMsg(..), Model, Msg, initialModel, update, view)

import Helpers.Decode exposing (optionalError, optionalFieldError)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode exposing (Decoder, decodeString, field, string)
import Json.Decode.Pipeline exposing (decode)
import Route exposing (Route)
import Session exposing (Session)
import Session.Request exposing (login)
import Validate exposing (Validator, ifBlank, validate)
import ViewHelpers exposing (..)


-- MESSAGES --


type Msg
    = SubmitForm
    | SetEmail String
    | SetPassword String
    | LoginCompleted (Result Http.Error Session)


type ExternalMsg
    = NoOp
    | SetSession Session



-- MODEL --


type alias Model =
    { errors : List Error
    , email : String
    , password : String
    }


initialModel : Model
initialModel =
    { errors = []
    , email = ""
    , password = ""
    }



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "" ]
        [ h1 [] [ text "Sign in" ]
        , div [ class "" ]
            [ viewErrors model.errors
            , viewForm
            ]
        ]


viewErrors : List ( a, String ) -> Html msg
viewErrors errors =
    errors
        |> List.map (\( _, error ) -> li [ class "" ] [ text error ])
        |> ul [ class "" ]


viewForm : Html Msg
viewForm =
    Html.form [ onSubmit SubmitForm ]
        [ inputgroup
            []
            [ label [] [ text "Your Email" ]
            , input [ type_ "email", placeholder "your@email.com" ] []
            ]
        , inputgroup
            []
            [ label [] [ text "Your Password" ]
            , input [ type_ "password", placeholder "********" ] []
            ]
        , button [ class "btn btn-primary" ] [ text "Sign In" ]
        ]



-- UPDATE --


update : Msg -> Model -> ( ( Model, Cmd Msg ), ExternalMsg )
update msg model =
    case msg of
        SubmitForm ->
            case validate modelValidator model of
                [] ->
                    ( { model | errors = [] }
                    , Http.send LoginCompleted (login model)
                    , NoOp
                    )

                errors ->
                    ( { model | errors = errors }
                    , Cmd.none
                    , NoOp
                    )

        SetEmail email ->
            ( { model | email = email }
            , Cmd.none
            , NoOp
            )

        SetPassword password ->
            ( { model | password = password }
            , Cmd.none
            , NoOp
            )

        LoginCompleted (Err error) ->
            let
                errorMessages =
                    case error of
                        Http.BadStatus response ->
                            response.body
                                |> decodeString (field "errors" errorsDecoder)
                                |> Result.withDefault []

                        _ ->
                            [ "unable to perform login" ]
            in
                ( { model | errors = List.map (\errorMessage -> Form => errorMessage) errorMessages }
                , Cmd.none
                , NoOp
                )

        LoginCompleted (Ok session) ->
            ( model
            , Route.modifyUrl Route.Home
            , SetSession session
            )



-- VALIDATION


type Field
    = Form
    | Email
    | Password


type alias Error =
    ( Field, String )


modelValidator : Validator Error Model
modelValidator =
    Validate.all
        [ ifBlank .email (Email => "Sorry, you must enter an email address.")
        , ifBlank .password (Password => "Sorry, you must enter a password.")
        ]



-- DECODERS --


errorsDecoder : Decoder (List String)
errorsDecoder =
    decode (\email password error -> error :: List.concat [ email, password ])
        |> optionalFieldError "email"
        |> optionalFieldError "password"
        |> optionalError "error"
