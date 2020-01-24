defmodule BankAccounting.Users.User do
  @moduledoc """
  Defines the User used to authenticate in BankAccounting
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    has_many :auth_tokens, BankAccounting.AuthToken
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> unique_constraint(:email, downcase: true)
    |> put_pass_hash()
  end

  @doc """
  Encrypts provided password before saving
  """
  @spec put_pass_hash(Changeset.t()) :: Changeset.t()
  def put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(pass))

      _ ->
        changeset
    end
  end

  @doc """
  Parses an User into a struct that can be printed as json

  ## Examples

    iex> BankAccounting.Users.User.to_struct(%User{id: 1, email: "tony.stark@avengers.com", ...})
      %{
        id: 1,
        email: "tony.stark@avengers.com"
      }
  """
  @spec to_struct(__MODULE__.t()) :: %{email: String.t(), id: Integer.t()}
  def to_struct(%__MODULE__{} = user) do
    %{
      id: user.id,
      email: user.email
    }
  end
end
