module Page exposing (ActivePage(..), frame)

import Html exposing (..)
import Html.Attributes exposing (..)
import Route exposing (Route)
import Session exposing (Session)


type ActivePage
    = Other
    | Home
    | Login
    | Register


frame : Bool -> Maybe Session -> ActivePage -> Html msg -> Html msg
frame isLoading session activePage content =
    div []
        [ viewHeader session activePage isLoading
        , content
        ]


viewHeader : Maybe Session -> ActivePage -> Bool -> Html msg
viewHeader session activePage isLoading =
    nav [ class "" ]
        [ a [ class "", Route.href Route.Home, title "Home" ]
            [ text "Cook" ]
        , div [ class "" ] <|
            navbarLink activePage Route.Home [ text "Home" ]
                :: viewNavBar session activePage
        ]


viewNavBar : Maybe Session -> ActivePage -> List (Html msg)
viewNavBar session activePage =
    let
        linkTo =
            navbarLink activePage
    in
        case session of
            Nothing ->
                [ linkTo Route.Login [ text "Login" ]
                , linkTo Route.Register [ text "Register" ]
                ]

            Just session ->
                [ linkTo Route.Logout [ text "Logout" ]
                ]


navbarLink : ActivePage -> Route -> List (Html msg) -> Html msg
navbarLink activePage route linkContent =
    let
        active =
            case isActive activePage route of
                True ->
                    "black"

                False ->
                    "gray"
    in
        a [ Route.href route, class "", class active ] linkContent


isActive : ActivePage -> Route -> Bool
isActive activePage route =
    case ( activePage, route ) of
        ( Home, Route.Home ) ->
            True

        ( Login, Route.Login ) ->
            True

        ( Register, Route.Register ) ->
            True

        _ ->
            False
