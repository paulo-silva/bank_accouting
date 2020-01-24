defmodule BankAccounting.Users.User do
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

  def put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(pass))

      _ ->
        changeset
    end
  end

  def to_struct(%__MODULE__{} = user) do
    %{
      id: user.id,
      email: user.email
    }
  end
end
