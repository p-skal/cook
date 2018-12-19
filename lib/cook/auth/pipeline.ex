defmodule Cook.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :cook,
    module: Cook.Auth.Guardian,
    error_handler: Cook.Auth.ErrorHandler

  plug(Guardian.Plug.VerifyHeader)
  plug(Guardian.Plug.EnsureAuthenticated)
  plug(Guardian.Plug.LoadResource)
end
