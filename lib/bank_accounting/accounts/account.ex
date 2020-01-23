defmodule BankAccounting.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts" do
    field :amount, :decimal

    timestamps()
  end

  def changeset(account, attrs) do
    account
    |> cast(attrs, [:amount])
    |> validate_required([:amount])
    |> validate_number(:amount, greater_than_or_equal_to: 0)
  end

  def to_struct(%__MODULE__{} = account) do
    %{
      id: account.id,
      amount: account.amount
    }
  end
end
