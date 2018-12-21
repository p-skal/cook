module Recipe exposing (Ingredient, Recipe, RecipesResponse, decoder, encodeIngredients, encodeRecipe, ingredientsDecoder, recipesDecoder)

import Helpers.Encode as Encode
import Json.Decode as Decode exposing (Decoder, maybe)
import Json.Decode.Pipeline exposing (optional, required)
import Json.Encode as Encode exposing (Value)


type alias RecipesResponse =
    { recipes : List Recipe
    }


type alias Recipe =
    { name : String
    , slug : String
    , description : Maybe String
    , created_by : Maybe String
    , collections : List String
    , difficulty : String
    , total_time : String
    , ingredients : List Ingredient
    , method : List String
    , likes : Int
    , views : Int
    }


type alias Ingredient =
    { name : String
    , quantity : String
    , unit : String
    }


recipesDecoder : Decoder RecipesResponse
recipesDecoder =
    Decode.succeed RecipesResponse
        |> required "recipes" (Decode.list decoder)


decoder : Decoder Recipe
decoder =
    Decode.succeed Recipe
        |> required "name" Decode.string
        |> required "slug" Decode.string
        |> required "description" (Decode.maybe Decode.string)
        |> required "created_by" (Decode.maybe Decode.string)
        |> required "collections" (Decode.list Decode.string)
        |> required "difficulty" Decode.string
        |> required "total_time" Decode.string
        |> required "ingredients" (Decode.list ingredientsDecoder)
        |> required "method" (Decode.list Decode.string)
        |> required "likes" Decode.int
        |> required "views" Decode.int


ingredientsDecoder : Decoder Ingredient
ingredientsDecoder =
    Decode.succeed Ingredient
        |> required "name" Decode.string
        |> required "quantity" Decode.string
        |> required "unit" Decode.string


encodeRecipe : Recipe -> Value
encodeRecipe recipe =
    Encode.object
        [ ( "name", Encode.string recipe.name )
        , ( "slug", Encode.string recipe.slug )
        , ( "description", Encode.maybe Encode.string recipe.description )
        , ( "created_by", Encode.maybe Encode.string recipe.created_by )
        , ( "collections", Encode.list Encode.string recipe.collections )
        , ( "difficulty", Encode.string recipe.difficulty )
        , ( "total_time", Encode.string recipe.difficulty )
        , ( "ingredients", Encode.list encodeIngredients recipe.ingredients )
        , ( "method", Encode.list Encode.string recipe.method )
        , ( "likes", Encode.int recipe.likes )
        , ( "views", Encode.int recipe.views )
        ]


encodeIngredients : Ingredient -> Value
encodeIngredients ingredient =
    Encode.object
        [ ( "name", Encode.string ingredient.name )
        , ( "quantity", Encode.string ingredient.quantity )
        , ( "unit", Encode.string ingredient.unit )
        ]
