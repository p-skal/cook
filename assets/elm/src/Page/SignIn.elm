module Page.SignIn exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Route
import Helpers.View exposing (logo, no_drag, bold, inputgroup, break)


type alias Model =
    { email : String
    , password : String
    }


view : List (Html msg)
view =
    [ div [ class "wrapper" ]
        [ a [ class "logo", Route.href Route.Root ] [ img [ logo "main" ] [] ]
        , h4 [ class "text-center" ] [ text "Welcome, please sign in below." ]
        , Html.form
            []
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
            , button [ class "btn btn-outline" ] [ text "Register" ]
            ]
        , h4 [ class "slogan" ] [ text "a powerful, digital recipe shelf ", break, text " built for simplicity" ]
        ]
    ]
