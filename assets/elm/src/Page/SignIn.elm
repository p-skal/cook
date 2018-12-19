module Page.SignIn exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import ViewHelpers exposing (logo, no_drag, bold, inputgroup, break)


view : Html msg
view =
    div [ class "wrapper" ]
        [ a [ class "logo", href "/" ] [ img [ logo "main" ] [] ]
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
