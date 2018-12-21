module Page.Browse exposing (Model, Msg, Status(..), initialModel, update, view)

import Api
import Helpers.View as View exposing (bold, break, logo, no_drag)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode exposing (Decoder, field, map)
import Recipe exposing (Recipe, RecipesResponse, recipesDecoder)
import Route


type Msg
    = MorePlease
    | GotGif (Result Http.Error RecipesResponse)



-- MODEL


type Status
    = Failure
    | Loading
    | Success RecipesResponse


type alias Model =
    { recipes : Status }


initialModel : Model
initialModel =
    Model
        Loading


init : () -> ( Model, Cmd Msg )
init _ =
    ( initialModel, getRecipes )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MorePlease ->
            ( { model | recipes = Loading }, getRecipes )

        GotGif result ->
            let
                _ =
                    Debug.log "GOT" result
            in
            case result of
                Ok url ->
                    ( { model | recipes = Success url }, Cmd.none )

                Err _ ->
                    ( { model | recipes = Failure }, Cmd.none )


view : Model -> Html Msg
view model =
    div [ class "wrapper" ]
        [ h1 [] [ text "All Recipes" ]
        , viewRecipes model
        ]


viewRecipes : Model -> Html Msg
viewRecipes model =
    case model.recipes of
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

        Success recipe ->
            let
                { recipes } =
                    recipe
            in
            div [] <|
                List.map viewRecipe recipes


viewRecipe : Recipe -> Html msg
viewRecipe recipe =
    div [ style "marginBottom" "2rem", style "display" "block" ]
        [ a [ Route.href <| Route.Recipe recipe.slug ] [ bold recipe.name ]
        , break
        , text <| Maybe.withDefault "" recipe.description
        , break
        , View.small recipe.difficulty
        , text " | "
        , View.small recipe.total_time
        , break
        , View.small <| String.fromInt recipe.likes ++ " Likes"
        , text " | "
        , View.small <| String.fromInt recipe.views ++ " Views"
        ]


getRecipes : Cmd Msg
getRecipes =
    Http.get
        { url = "/api/recipes"
        , expect = Http.expectJson GotGif Recipe.recipesDecoder
        }
