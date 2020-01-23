defmodule BankAccounting.Accounts.Transfers do
  alias BankAccounting.Repo
  alias BankAccounting.Accounts.{Account, Transfer}

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
end
