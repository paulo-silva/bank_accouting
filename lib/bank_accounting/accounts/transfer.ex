defmodule BankAccounting.Accounts.Transfer do
  use Ecto.Schema
  import Ecto.Changeset

  alias BankAccounting.Accounts.Account

  schema "transfers" do
    belongs_to :origin_account, Account, foreign_key: :origin_account_id
    belongs_to :destiny_account, Account, foreign_key: :destiny_account_id
    field :amount, :decimal

    timestamps()
  end

  def changeset(account, attrs) do
    account
    |> cast(attrs, [:amount, :origin_account_id, :destiny_account_id])
    |> validate_required([:amount])
    |> validate_number(:amount, greater_than_or_equal_to: 0)
    |> assoc_constraint(:origin_account)
    |> assoc_constraint(:destiny_account)
  end
end
