module Page.Manifest exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Route
import Helpers.View exposing (logo, break, bold, italic, emphasis)


view =
    [ div [ class "wrapper" ]
        [ a [ class "logo", Route.href Route.Root ]
            [ img [ logo "main" ] []
            ]
        , p [ class "slogan" ]
            [ text "A powerful, digital recipe shelf"
            , break
            , text "built for simplicity."
            ]
        , section []
            [ h1 [] [ text "Stop snapping pictures of recipe books and websites." ]
            , p [] [ text "Grow and store your own shelf of recipes, accessible anywhere, sourced through the community and also, your own additions. " ]
            , p []
                [ emphasis "Cook"
                , text "lets you search with advanced filters to refine reults based on specific diets, cuisines, other cooks, difficulties and the time taken to cook."
                ]
            , break
            , h3 []
                [ text "With "
                , italic "Cook"
                , text "you can also:"
                ]
            , ul []
                [ li [] [ text "Star recipes and group them in collections for your own personal use." ]
                , li [] [ text "Share and like others' recipes to keep them cooking themselves." ]
                , li []
                    [ text "Import recipes from "
                    , bold "other sites"
                    , text "with ease."
                    ]
                , li []
                    [ bold "Time"
                    , text "your recipes as you are following them and "
                    , bold "easily adjust"
                    , text "the serve & ingredients you want to use."
                    ]
                ]
            ]
        , a [ class "btn btn-primary", Route.href Route.SignIn, style "width" "100%", style "marginTop" "2rem" ]
            [ text "Get Started with " ]
        , a [ class "btn btn-outline", Route.href Route.Browse, style "width" "100%" ]
            [ text "Browse community recipes" ]
        ]
    ]
