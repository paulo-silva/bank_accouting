defmodule BankAccounting.AuthToken do
  @moduledoc """
  Defines the AuthToken, used to store authentication tokens of an user
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias BankAccounting.Users.User

  schema "auth_tokens" do
    belongs_to :user, User
    field :revoked, :boolean, default: false
    field :revoked_at, :utc_datetime
    field :token, :string

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = auth_token, attrs) do
    auth_token
    |> cast(attrs, [:token])
    |> validate_required([:token])
    |> unique_constraint(:token)
  end
end
