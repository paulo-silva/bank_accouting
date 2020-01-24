defmodule BankAccounting.Users do
  @moduledoc """
  The Users context.
  """

  alias BankAccounting.Repo
  alias BankAccounting.AuthToken
  alias BankAccounting.Services.Authenticator
  alias BankAccounting.Users.User

  def register_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def sign_in_user(email, password) do
    case Bcrypt.check_pass(Repo.get_by(User, email: email), password) do
      {:ok, user} ->
        token = Authenticator.generate_token(user)
        Repo.insert(Ecto.build_assoc(user, :auth_tokens, %{token: token}))

      error ->
        error
    end
  end

  def sign_out_user(conn) do
    case Authenticator.get_auth_token(conn) do
      {:ok, token} ->
        case Repo.get_by(AuthToken, %{token: token}) do
          nil -> {:error, :not_found}
          auth_token -> Repo.delete(auth_token)
        end

      error ->
        error
    end
  end
end
