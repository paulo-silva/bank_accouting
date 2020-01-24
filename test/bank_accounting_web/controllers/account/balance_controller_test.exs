defmodule BankAccountingWeb.Account.BalanceControllerTest do
  use BankAccountingWeb.ConnCase, async: true

  alias BankAccounting.Accounts
  alias BankAccounting.Accounts.Account

  describe "GET /accounts/:id/balance" do
    test "with valid account returns account balance and transfers made", %{conn: conn} do
      {:ok, %Account{id: origin_account_id}} = Accounts.register_account(%{amount: 100})
      {:ok, %Account{id: destiny_account_id}} = Accounts.register_account(%{amount: 0})

      [30, 50, 20]
      |> Enum.each(fn amount ->
        origin_account = Accounts.get_account!(origin_account_id)
        destiny_account = Accounts.get_account!(destiny_account_id)

        Accounts.transfer_money(origin_account, destiny_account, amount)
      end)

      conn = get(conn, Routes.account_balance_path(conn, :show, destiny_account_id))

      assert %{
               "account_id" => destiny_account_id,
               "amount" => "R$ 100,00",
               "transfers" => [
                 %{
                   "id" => _,
                   "origin_account_id" => origin_account_id,
                   "destiny_account_id" => destiny_account_id,
                   "amount" => "R$ 30,00"
                 },
                 %{
                   "id" => _,
                   "origin_account_id" => origin_account_id,
                   "destiny_account_id" => destiny_account_id,
                   "amount" => "R$ 50,00"
                 },
                 %{
                   "id" => _,
                   "origin_account_id" => origin_account_id,
                   "destiny_account_id" => destiny_account_id,
                   "amount" => "R$ 20,00"
                 }
               ]
             } = json_response(conn, 200)
    end
  end
end
