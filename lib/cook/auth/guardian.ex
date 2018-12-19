defmodule Cook.Auth.Guardian do
  use Guardian, otp_app: :cook

  def subject_for_token(resource, _claims) do
    sub = to_string(resource.id)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    case Cook.Accounts.get_user(claims["sub"]) do
      nil -> {:error, "User not found"}
      user -> {:ok, user}
    end
  end
end
