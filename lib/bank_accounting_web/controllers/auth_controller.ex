defmodule BankAccountingWeb.AuthController do
  use BankAccountingWeb, :controller

  alias BankAccounting.Users

  def create(conn, %{"email" => email, "password" => password}) do
    case Users.sign_in_user(email, password) do
      {:ok, auth_token} ->
        conn
        |> put_status(:ok)
        |> render("show.json", %{auth_token: auth_token})

      {:error, reason} ->
        conn
        |> send_resp(401, reason)
    end
  end

  def delete(conn, _) do
    case Users.sign_out_user(conn) do
      {:error, reason} -> conn |> send_resp(400, reason)
      {:ok, _} -> conn |> send_resp(204, "")
    end
  end
end
