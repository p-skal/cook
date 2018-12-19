module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Route exposing (Route)
import ViewHelpers exposing (container)
import Page.Login as Login
import Session exposing (Session)
import Page exposing (ActivePage)
import Page.Home as Home
import Page.Register as Register
import Page.NotFound as NotFound


type Msg
    = SetRoute (Maybe Route)
    | SetSession (Maybe Session)
    | LoginMsg Login.Msg
      --    | RegisterMsg Register.Msg
    | LogoutCompleted (Result Http.Error ())


main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }


type Page
    = Blank
    | NotFound
    | Home
    | Login Login.Model
    | Register


type PageState
    = Loaded Page
    | TransitioningFrom Page


type alias Model =
    { session : Maybe Session
    , pageState : PageState
    }


initialModel : Value -> Model
initialModel val =
    { session = Nothing
    , pageState = Loaded Blank
    }


getPage : PageState -> Page
getPage pageState =
    case pageState of
        Loaded page ->
            page

        TransitioningFrom page ->
            page


decodeSessionFromJson : Value -> Maybe Session
decodeSessionFromJson json =
    json
        |> Decode.decodeValue Decode.string
        |> Result.toMaybe
        |> Maybe.andThen (Decode.decodeString Session.decoder >> Result.toMaybe)


init : Value -> Location -> ( Model, Cmd Msg )
init val location =
    updateRoute (Route.fromLocation location) (initialModel val)


updateRoute : Maybe Route -> Model -> ( Model, Cmd Msg )
updateRoute maybeRoute model =
    case maybeRoute of
        Nothing ->
            { model | pageState = Loaded NotFound } => Cmd.none

        Just Route.Home ->
            { model | pageState = Loaded Home } => Cmd.none

        Just Route.Root ->
            model => Route.modifyUrl Route.Home

        Just Route.Login ->
            { model | pageState = Loaded Login } => Cmd.none

        Just Route.Logout ->
            model => Cmd.none

        Just Route.Register ->
            { model | pageState = Loaded Register } => Cmd.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    updatePage (getPage model.pageState) msg model


updatePage : Page -> Msg -> Model -> ( Model, Cmd Msg )
updatePage page msg model =
    case ( msg, page ) of
        ( SetRoute route, _ ) ->
            updateRoute route model


view : Model -> Html Msg
view model =
    case model.pageState of
        Loaded page ->
            viewPage True page

        TransitioningFrom page ->
            viewPage False page


viewPage : Bool -> Page -> Html Msg
viewPage isLoading page =
    let
        frame =
            Page.frame isLoading
    in
        case page of
            NotFound ->
                NotFound.view
                    |> frame Page.Other

            Blank ->
                Html.text "Loading Maya!"

            Home ->
                Home.view
                    |> frame Page.Home

            Login ->
                Login.view
                    |> frame Page.Login

            Register ->
                Register.view
                    |> frame Page.Register


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ pageSubscriptions (getPage model.pageState)
        , Sub.map SetSession sessionChangeSubscription
        ]


pageSubscriptions : Page -> Sub Msg
pageSubscriptions page =
    case page of
        Blank ->
            Sub.none

        NotFound ->
            Sub.none

        Error _ ->
            Sub.none

        Home ->
            Sub.none

        Login _ ->
            Sub.none

        Register _ ->
            Sub.none
