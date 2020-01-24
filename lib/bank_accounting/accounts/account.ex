defmodule BankAccounting.Accounts.Account do
  @moduledoc """
  Defines the Account of BankAccounting
  """

  use Ecto.Schema
  import Ecto.Changeset
  import BankAccounting.Helpers, only: [number_to_currency: 1]

  schema "accounts" do
    field :amount, :decimal

    timestamps()
  end

  @doc """
  Define Account changeset
  """
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:amount])
    |> validate_required([:amount])
    |> validate_number(:amount, greater_than_or_equal_to: 0)
  end

  @doc """
  Parse an Account into a struct that can be printed as json

  ## Examples

    iex> BankAccounting.Accounts.Account.to_struct(%Account{id: 1, amount: 90})
      %{
        id: 1,
        amount: "R$ 90,00"
      }
  """
  @spec to_struct(%__MODULE__{}) :: Map.t()
  def to_struct(%__MODULE__{} = account) do
    %{
      id: account.id,
      amount: number_to_currency(account.amount)
    }
  end
end
