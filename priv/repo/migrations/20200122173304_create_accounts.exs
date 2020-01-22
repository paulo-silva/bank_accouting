defmodule BankAccounting.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :amount, :decimal, null: false

      timestamps()
    end
  end
end
