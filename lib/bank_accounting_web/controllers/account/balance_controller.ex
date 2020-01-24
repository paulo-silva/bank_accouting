defmodule BankAccountingWeb.Account.BalanceController do
  use BankAccountingWeb, :controller

  alias BankAccounting.Accounts

  def show(conn, %{"account_id" => account_id}) do
    try do
      account = Accounts.get_account!(account_id)

      conn
      |> render("show.json", account: account)
    rescue
      Ecto.NoResultsError ->
        conn
        |> put_status(:not_found)
        |> text("Account not exist")
    end
  end
end
