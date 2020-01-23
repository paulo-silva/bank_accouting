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
end