defmodule BankAccountingWeb.TransferController do
  @moduledoc false

  use BankAccountingWeb, :controller

  alias BankAccounting.Accounts

  def create(conn, %{
        "source_account_id" => origin_account_id,
        "destiny_account_id" => destiny_account_id,
        "amount" => amount
      }) do
    origin_account = Accounts.get_account!(origin_account_id)
    destiny_account = Accounts.get_account!(destiny_account_id)

    case Accounts.transfer_money(origin_account, destiny_account, amount) do
      {:ok, :transferred} ->
        conn
        |> put_status(:created)
        |> json(%{status: "transferred"})

      {:error, :not_transferred} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{status: "not_transferred"})
    end
  end
end
