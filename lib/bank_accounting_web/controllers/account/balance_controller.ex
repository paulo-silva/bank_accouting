defmodule BankAccountingWeb.Account.BalanceController do
  use BankAccountingWeb, :controller

  alias BankAccounting.Accounts

  def show(conn, %{"account_id" => account_id}) do
    account = Accounts.get_account!(account_id)

    conn
    |> render("show.json", account: account)
  end
end
