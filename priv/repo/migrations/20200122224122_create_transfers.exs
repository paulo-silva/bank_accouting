defmodule BankAccounting.Repo.Migrations.CreateTransfers do
  use Ecto.Migration

  def change do
    create table(:transfers) do
      add :origin_account_id, references(:accounts)
      add :destiny_account_id, references(:accounts)
      add :amount, :decimal, null: false

      timestamps()
    end
  end
end
