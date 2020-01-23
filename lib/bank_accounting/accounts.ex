defmodule BankAccounting.Accounts do
  @moduledoc """
  The Accounts context.
  """

  alias Ecto.Multi
  alias BankAccounting.Repo
  alias BankAccounting.Accounts.{Account, Transfers}

  def register_account(attrs \\ %{}) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end

  def get_account!(id) do
    Repo.get!(Account, id)
  end

  def update_account(%Account{} = account, attrs) do
    account
    |> Account.changeset(attrs)
    |> Repo.update()
  end

  @spec transfer_money(
          BankAccounting.Accounts.Account.t(),
          BankAccounting.Accounts.Account.t(),
          Number.t()
        ) :: {:error, :not_transferred} | {:ok, :transferred}
  def transfer_money(%Account{} = origin, %Account{} = destiny, amount) do
    case Decimal.cmp(origin.amount, amount) do
      result when result == :gt or result == :eq ->
        Multi.new()
        |> Multi.run(:debit_origin_account_step, debit_account(origin, amount))
        |> Multi.run(:credit_destiny_account_step, credit_account(destiny, amount))
        |> Multi.run(:save_transfer_step, save_transfer(origin, destiny, amount))
        |> Repo.transaction()

        {:ok, :transferred}

      _ ->
        {:error, :not_transferred}
    end
  end

  defp debit_account(%Account{} = account, amount) do
    fn _repo, _ ->
      new_amount = Decimal.sub(account.amount, amount)

      __MODULE__.update_account(account, %{amount: new_amount})
    end
  end

  defp credit_account(%Account{} = account, amount) do
    fn _repo, %{debit_origin_account_step: %Account{}} ->
      new_amount = Decimal.add(account.amount, amount)

      __MODULE__.update_account(account, %{amount: new_amount})
    end
  end

  defp save_transfer(%Account{} = origin_account, %Account{} = destiny_account, amount) do
    fn _repo, %{credit_destiny_account_step: %Account{}} ->
      Transfers.register_transfer(%{
        origin_account: origin_account,
        destiny_account: destiny_account,
        amount: amount
      })
    end
  end
end
