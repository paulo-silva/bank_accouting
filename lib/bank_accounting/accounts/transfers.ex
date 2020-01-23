defmodule BankAccounting.Accounts.Transfers do
  import Ecto.Query
  alias BankAccounting.Repo
  alias BankAccounting.Accounts.{Account, Transfer}

  def calc_account_balance(%Account{} = account) do
    account_credits =
      get_account_credits(account)
      |> Enum.map(& &1.amount)
      |> Enum.reduce(0, fn amount, acc -> Decimal.add(acc, amount) end)

    account_debits =
      get_account_debits(account)
      |> Enum.map(& &1.amount)
      |> Enum.reduce(0, fn amount, acc -> Decimal.add(acc, amount) end)

    {:ok, Decimal.sub(account_credits, account_debits)}
  end

  def list_account_transfers(%Account{id: account_id}) do
    list_transfers_query()
    |> where([t], t.origin_account_id == ^account_id)
    |> or_where([t], t.destiny_account_id == ^account_id)
    |> Repo.all()
  end

  def register_transfer(%{
        origin_account: %Account{} = origin_account,
        destiny_account: %Account{} = destiny_account,
        amount: amount
      }) do
    %Transfer{}
    |> Transfer.changeset(%{amount: amount})
    |> Ecto.Changeset.put_assoc(:origin_account, origin_account)
    |> Ecto.Changeset.put_assoc(:destiny_account, destiny_account)
    |> Repo.insert()
  end

  defp get_account_debits(%Account{id: account_id}) do
    list_transfers_query()
    |> where([t], t.origin_account_id == ^account_id)
    |> Repo.all()
  end

  defp get_account_credits(%Account{id: account_id}) do
    list_transfers_query()
    |> where([t], t.destiny_account_id == ^account_id)
    |> Repo.all()
  end

  defp list_transfers_query() do
    from(t in Transfer, order_by: [asc: t.inserted_at])
  end
end
