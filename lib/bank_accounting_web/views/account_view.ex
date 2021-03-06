defmodule BankAccountingWeb.AccountView do
  @moduledoc false

  use BankAccountingWeb, :view
  alias BankAccounting.Accounts.Account

  def render("index.json", %{accounts: accounts}) do
    accounts =
      accounts
      |> Enum.map(fn account -> Account.to_struct(account) end)

    %{accounts: accounts}
  end

  def render("show.json", %{account: account}) do
    %{account: Account.to_struct(account)}
  end

  def render("create.json", %{account: account}) do
    %{account: Account.to_struct(account)}
  end

  def render("update.json", %{account: account}) do
    %{account: Account.to_struct(account)}
  end
end
