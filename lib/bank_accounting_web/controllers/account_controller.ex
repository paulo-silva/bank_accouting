defmodule BankAccountingWeb.AccountController do
  use BankAccountingWeb, :controller

  alias BankAccounting.Accounts

  def index(conn, _params) do
    render(conn, "index.json", accounts: Accounts.list_accounts())
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
