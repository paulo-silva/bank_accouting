defmodule BankAccounting.Accounts.Transfer do
  @moduledoc """
  Defines Transfer schema that store transfers between accounts
  """

  use Ecto.Schema
  import Ecto.Changeset
  import BankAccounting.Helpers, only: [number_to_currency: 1]

  alias BankAccounting.Accounts.Account

  schema "transfers" do
    belongs_to :origin_account, Account, foreign_key: :origin_account_id
    belongs_to :destiny_account, Account, foreign_key: :destiny_account_id
    field :amount, :decimal

    timestamps()
  end

  @doc """
  Define Transfer changeset
  """
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:amount, :origin_account_id, :destiny_account_id])
    |> validate_required([:amount])
    |> validate_number(:amount, greater_than_or_equal_to: 0)
    |> assoc_constraint(:origin_account)
    |> assoc_constraint(:destiny_account)
  end

  @doc """
  Parse a Transfer into a struct that can be printed as json

  ## Examples

    iex> BankAccounting.Accounts.Transfer.to_struct(%Transfer{id: 1, origin_account_id: 2, destiny_account_id: 3, amount: 50})
      %{
        id: 1,
        origin_account_id: 2,
        destiny_account_id: 3,
        amount: "R$ 50,00"
      }
  """
  def to_struct(%__MODULE__{} = transfer) do
    %{
      id: transfer.id,
      amount: number_to_currency(transfer.amount),
      origin_account_id: transfer.origin_account_id,
      destiny_account_id: transfer.destiny_account_id
    }
  end
end
