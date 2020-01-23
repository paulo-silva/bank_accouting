defmodule BankAccountingWeb.AccountController do
  use BankAccountingWeb, :controller

  alias BankAccounting.Accounts

  def index(conn, _params) do
    render(conn, "index.json", accounts: Accounts.list_accounts())
  end

  def show(conn, %{"id" => account_id}) do
    try do
      account = Accounts.get_account!(account_id)

      render(conn, "show.json", account: account)
    rescue
      Ecto.NoResultsError ->
        send_resp(conn, 404, "")
    end
  end

  def create(conn, %{"account" => %{"amount" => _amount} = attrs}) do
    case Accounts.register_account(attrs) do
      {:ok, account} ->
        conn
        |> put_status(:created)
        |> render("create.json", account: account)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(BankAccountingWeb.ErrorView)
        |> render("422.json", changeset: changeset)
    end
  end

  def update(conn, %{"id" => account_id, "account" => %{"amount" => _amount} = attrs}) do
    try do
      account = Accounts.get_account!(account_id)

      case Accounts.update_account(account, attrs) do
        {:ok, account} ->
          render(conn, "update.json", account: account)

        {:error, changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> put_view(BankAccountingWeb.ErrorView)
          |> render("422.json", changeset: changeset)
      end
    rescue
      Ecto.NoResultsError ->
        send_resp(conn, 404, "")
    end
  end

  def delete(conn, %{"id" => account_id}) do
    try do
      account = Accounts.get_account!(account_id)

      {:ok, _account} = Accounts.delete_account(account)

      send_resp(conn, 204, "")
    rescue
      Ecto.NoResultsError ->
        send_resp(conn, 404, "")
    end
  end
end
