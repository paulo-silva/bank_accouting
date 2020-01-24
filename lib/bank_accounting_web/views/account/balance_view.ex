defmodule BankAccountingWeb.Account.BalanceView do
  @moduledoc false

  use BankAccountingWeb, :view
  import BankAccounting.Helpers, only: [number_to_currency: 1]

  alias BankAccounting.Accounts.{Transfers, Transfer}

  def render("show.json", %{account: account}) do
    transfers =
      Transfers.list_account_transfers(account)
      |> Enum.map(&Transfer.to_struct(&1))

    %{
      account_id: account.id,
      amount: number_to_currency(account.amount),
      transfers: transfers
    }
  end
end
