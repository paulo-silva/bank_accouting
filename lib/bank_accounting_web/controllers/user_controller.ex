defmodule BankAccountingWeb.UserController do
  @moduledoc false

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

  def delete(conn, %{"id" => user_id}) do
    try do
      user = Users.get_user!(user_id)

      {:ok, _user} = Users.delete_user(user)

      send_resp(conn, 204, "")
    rescue
      Ecto.NoResultsError ->
        send_resp(conn, 404, "")
    end
  end
end
