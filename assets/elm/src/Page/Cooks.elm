module Page.Cooks exposing (..)

import Http
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Cook
import Helpers.View exposing (bold, small, break)


type Msg
    = MorePlease
    | GotCook (Result Http.Error Cook.CooksResponse)


type Status
    = Failure
    | Loading
    | Success Cook.CooksResponse


type alias Model =
    { cooks : Status }


initialModel : Model
initialModel =
    Model
        Loading


init : () -> ( Model, Cmd Msg )
init _ =
    ( initialModel, getCooks )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MorePlease ->
            ( { model | cooks = Loading }, getCooks )

        GotCook result ->
            let
                _ =
                    Debug.log "GOT" result
            in
                case result of
                    Ok cooks ->
                        ( { model | cooks = Success cooks }, Cmd.none )

                    Err _ ->
                        ( { model | cooks = Failure }, Cmd.none )


view model =
    case model.cooks of
        Failure ->
            div []
                [ text "I could not load a random cat for some reason. "
                , button [ onClick MorePlease ] [ text "Try Again!" ]
                ]

        Loading ->
            div []
                [ text "Loading..."
                , button [ onClick MorePlease, style "display" "block" ]
                    [ text "More Please!" ]
                ]

        Success cook ->
            let
                { cooks } =
                    cook
            in
                div []
                    [ h1 [] [ text "All Cooks " ]
                    , div [] (List.map viewCook cooks)
                    ]


viewCook : Cook.Cook -> Html msg
viewCook cook =
    div [ style "marginBottom" "2rem", style "display" "block" ]
        [ bold cook.name
        , break
        , small cook.handle
        , text " | "
        , small cook.date_joined
        ]


getCooks : Cmd Msg
getCooks =
    let
        _ =
            Debug.log "GET" "test"
    in
        Http.get
            { url = "/api/users"
            , expect = Http.expectJson GotCook Cook.cooksDecoder
            }
