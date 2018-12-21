module Main exposing (main)

import Browser exposing (UrlRequest)
import Browser.Navigation as Nav exposing (Key)
import Helpers.View as View exposing (content, logo)
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Page.Browse as Browse
import Page.Cooks as Cooks
import Page.Manifest as Manifest
import Page.NotFound as NotFound
import Page.Recipe as Recipe
import Page.Register as Register
import Page.SignIn as SignIn
import Route exposing (Route)
import Session exposing (Session)
import Url exposing (Url)



-- FLAGS


type alias Flags =
    {}



-- MODEL


type alias Model =
    { key : Key
    , route : Route
    , browseModel : Browse.Model
    , cooksModel : Cooks.Model
    , recipeModel : Recipe.Model
    }


init : Flags -> Url -> Key -> ( Model, Cmd Msg )
init flags url key =
    let
        currentRoute =
            Route.parseUrl url
    in
    ( initialModel currentRoute key, Cmd.none )


initialModel : Route -> Key -> Model
initialModel route key =
    { key = key
    , route = route
    , browseModel = Browse.initialModel
    , cooksModel = Cooks.initialModel
    , recipeModel = Recipe.initialModel
    }



-- MESSAGES


type Msg
    = OnUrlChange Url
    | OnUrlRequest UrlRequest
    | BrowseMsg Browse.Msg
    | CooksMsg Cooks.Msg
    | RecipeMsg Recipe.Msg



-- MAIN


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = OnUrlRequest
        , onUrlChange = OnUrlChange
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnUrlRequest urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Nav.pushUrl model.key (Url.toString url)
                    )

                Browser.External url ->
                    ( model
                    , Nav.load url
                    )

        OnUrlChange url ->
            let
                newRoute =
                    Route.parseUrl url
            in
            ( { model | route = newRoute }, Cmd.none )

        BrowseMsg subMsg ->
            let
                ( updatedBrowseModel, browseCmd ) =
                    Browse.update subMsg model.browseModel
            in
            ( { model | browseModel = updatedBrowseModel }, Cmd.map BrowseMsg browseCmd )

        CooksMsg subMsg ->
            let
                ( updatedCooksModel, cooksCmd ) =
                    Cooks.update subMsg model.cooksModel
            in
            ( { model | cooksModel = updatedCooksModel }, Cmd.map CooksMsg cooksCmd )

        RecipeMsg subMsg ->
            let
                ( updatedRecipeModel, recipeCmd ) =
                    Recipe.update subMsg model.recipeModel
            in
            ( { model | recipeModel = updatedRecipeModel }, Cmd.map RecipeMsg recipeCmd )



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title =
        "Cook · "
            ++ (if model.route == Route.Root then
                    "Your Digital Recipe Shelf"

                else
                    Route.routeToString model.route
               )
    , body = page model
    }


page model =
    let
        currentRoute =
            model.route
    in
    let
        viewContent =
            case currentRoute of
                Route.Root ->
                    Manifest.view

                Route.Browse ->
                    [ Html.map BrowseMsg (Browse.view model.browseModel) ]

                Route.SignIn ->
                    SignIn.view

                Route.SignOut ->
                    NotFound.view

                Route.Register ->
                    Register.view

                Route.Cooks ->
                    [ Html.map CooksMsg (Cooks.view model.cooksModel) ]

                Route.NotFound ->
                    NotFound.view

                Route.Recipe slug ->
                    [ Html.map RecipeMsg (Recipe.view model.recipeModel slug) ]
    in
    [ node "container"
        []
        [ viewHeader
        , content [] viewContent
        , viewFooter
        ]
    ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


navigation_links =
    [ { route = Route.SignIn, name = "Sign In" }
    , { route = Route.Cooks, name = "All Cooks" }
    ]


viewHeader =
    header []
        [ nav [ class "navigation" ]
            [ ul [ class "navigation-bar" ] <|
                [ li []
                    [ a [ Route.href Route.Browse, class "logo" ]
                        [ img [ logo "main" ] []
                        ]
                    ]
                ]
                    ++ List.map viewNavTab navigation_links
            ]
        ]


viewNavTab { route, name } =
    a [ class "nav-tab", Route.href route ] [ text name ]


viewFooter =
    footer []
        [ small []
            [ text "© 2018 - Made with ️<3 by "
            , a [ href "https://peter-s.now.sh", target "_blank" ]
                [ b []
                    [ text "Peter S." ]
                ]
            ]
        ]
