defmodule BankAccountingWeb.AccountView do
  def render("index.json", %{accounts: accounts}) do
    accounts =
      accounts
      |> Enum.map(fn account -> %{id: account.id, amount: account.amount} end)

    %{accounts: accounts}
  end
end
