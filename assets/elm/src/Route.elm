module Route exposing (Route(..), href, parseUrl, replaceUrl, routeToString)

import Browser.Navigation as Nav
import Html exposing (Attribute)
import Html.Attributes as Attr
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, oneOf, parse, s, string)



-- ROUTING


type Route
    = Browse
    | Root
    | SignIn
    | SignOut
    | Register
    | Cooks
    | Recipe String
    | NotFound


parser : Parser (Route -> a) a
parser =
    oneOf
        [ Parser.map Root Parser.top
        , Parser.map Browse (s "browse")
        , Parser.map SignIn (s "sign-in")
        , Parser.map SignOut (s "sign-out")
        , Parser.map Register (s "register")
        , Parser.map Cooks (s "cooks")
        , Parser.map Recipe (s "recipe" </> string)
        ]



-- PUBLIC HELPERS


href : Route -> Attribute msg
href targetRoute =
    Attr.href (routeToString targetRoute)


replaceUrl : Nav.Key -> Route -> Cmd msg
replaceUrl key route =
    Nav.replaceUrl key (routeToString route)


parseUrl : Url -> Route
parseUrl url =
    case parse parser url of
        Just route ->
            route

        Nothing ->
            NotFound



-- INTERNAL


routeToString : Route -> String
routeToString page =
    let
        pieces =
            case page of
                Root ->
                    []

                Browse ->
                    [ "browse" ]

                SignIn ->
                    [ "sign-in" ]

                SignOut ->
                    [ "sign-out" ]

                Register ->
                    [ "register" ]

                Cooks ->
                    [ "cooks" ]

                NotFound ->
                    [ "error" ]

                Recipe slug ->
                    [ "recipe", slug ]
    in
    "/" ++ String.join "/" pieces
