defmodule BankAccountingWeb.UserController do
  use BankAccountingWeb, :controller

  alias BankAccounting.Users

  def create(conn, %{"user" => %{"email" => _, "password" => _} = attrs}) do
    case Users.register_user(attrs) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render("create.json", user: user)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(BankAccountingWeb.ErrorView)
        |> render("422.json", changeset: changeset)
    end
  end

end
