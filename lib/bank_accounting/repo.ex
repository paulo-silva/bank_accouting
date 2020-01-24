defmodule BankAccounting.Repo do
  @moduledoc false

  use Ecto.Repo,
    otp_app: :bank_accounting,
    adapter: Ecto.Adapters.Postgres
end
