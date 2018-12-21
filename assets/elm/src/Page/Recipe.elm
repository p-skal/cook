module Page.Recipe exposing (Model, Msg(..), Status(..), getRecipe, init, initialModel, update, view, viewRecipe, viewRecipes)

import Api
import Helpers.View as View exposing (bold, break, logo, no_drag)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode exposing (Decoder, field, map)
import Recipe exposing (Recipe, decoder)
import Route


type Msg
    = MorePlease String
    | GotGif (Result Http.Error Recipe)



-- MODEL


type Status
    = Failure
    | Loading
    | Success Recipe


type alias Model =
    { recipe : Status }


initialModel : Model
initialModel =
    Model
        Loading


init : () -> ( Model, Cmd Msg )
init _ =
    ( initialModel, getRecipe "" )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MorePlease slug ->
            ( { model | recipe = Loading }, getRecipe slug )

        GotGif result ->
            let
                _ =
                    Debug.log "GOT" result
            in
            case result of
                Ok recipe ->
                    ( { model | recipe = Success recipe }, Cmd.none )

                Err _ ->
                    ( { model | recipe = Failure }, Cmd.none )


view : Model -> String -> Html Msg
view model slug =
    div [ class "wrapper" ]
        [ viewRecipes model slug
        ]


viewRecipes : Model -> String -> Html Msg
viewRecipes model slug =
    case model.recipe of
        Failure ->
            div []
                [ text "I could not load a random cat for some reason. "
                , button [ onClick <| MorePlease slug ] [ text "Try Again!" ]
                ]

        Loading ->
            div []
                [ text "Loading..."
                , button [ onClick <| MorePlease slug, style "display" "block" ]
                    [ text "More Please!" ]
                ]

        Success recipe ->
            div []
                [ h1 [] [ text recipe.name ]
                , viewRecipeInfo recipe
                , viewRecipe recipe
                ]


viewRecipeInfo recipe =
    div []
        [ p [] [ text <| Maybe.withDefault "" recipe.description ]
        , p [] [ bold <| "By " ++ Maybe.withDefault "Anonymous" recipe.created_by ]
        , View.small recipe.difficulty
        , text " | "
        , View.small recipe.total_time
        , break
        , View.small <| String.fromInt recipe.likes ++ " Likes"
        , text " | "
        , View.small <| String.fromInt recipe.views ++ " Views"
        ]


viewRecipe : Recipe -> Html msg
viewRecipe recipe =
    div []
        [ div []
            [ h3 [] [ text "Ingredients" ]
            , ul [] <| List.map viewIngredient recipe.ingredients
            , h3 [] [ text "Method" ]
            , ol [] <| List.map viewMethod recipe.method
            ]
        ]


viewIngredient { name, quantity, unit } =
    li []
        [ bold name
        , text <| " " ++ quantity ++ " " ++ unit
        ]


viewMethod step =
    li []
        [ text <| step
        ]


getRecipe : String -> Cmd Msg
getRecipe slug =
    let
        _ =
            Debug.log "GET" "test"
    in
    Http.get
        { url = "/api/recipes/" ++ slug
        , expect = Http.expectJson GotGif Recipe.decoder
        }
