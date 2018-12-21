defmodule CookWeb.Router do
  use CookWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_auth do
    plug(Cook.Auth.Pipeline)
  end

  scope "/", CookWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/manifesto", PageController, :manifesto

    get "/browse", MainController, :index

    get "/sign-in", SessionController, :new
    get "/sign-out", SessionController, :destroy
  end

  scope "/api", CookWeb do
    pipe_through(:api)

    # TEMP
    get("/recipes", RecipeController, :index)
    get("/recipes/:slug", RecipeController, :show)

    post("/sessions", SessionController, :create)
    get("/users", UserController, :index)
    get("/users/:handle", UserController, :show)
    post("/users", UserController, :create)
  end

  scope "/api", CookWeb do
    pipe_through([:api, :api_auth])

    delete("/sessions", SessionController, :delete)
    post("/sessions/refresh", SessionController, :refresh)
  end

  scope "/", CookWeb do
    pipe_through :browser

    # Important: this must be the last route defined
    get "/*path", MainController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", CookWeb do
  #   pipe_through :api
  # end
end
