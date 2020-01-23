defmodule BankAccounting.Accounts.Transfers do
  import Ecto.Query
  alias BankAccounting.Repo
  alias BankAccounting.Accounts.{Account, Transfer}

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

  defp list_transfers_query() do
    from(t in Transfer, order_by: [asc: t.inserted_at])
  end
end
