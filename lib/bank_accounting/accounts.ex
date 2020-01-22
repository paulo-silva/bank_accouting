defmodule BankAccounting.Accounts do
  @moduledoc """
  The Accounts context.
  """

  alias BankAccounting.Repo
  alias BankAccounting.Accounts.Account

  def register_account(attrs \\ %{}) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end
end
