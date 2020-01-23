defmodule BankAccountingWeb.AccountController do
  use BankAccountingWeb, :controller

  alias BankAccounting.Accounts

  def index(conn, _params) do
    render(conn, "index.json", accounts: Accounts.list_accounts())
  end
end
