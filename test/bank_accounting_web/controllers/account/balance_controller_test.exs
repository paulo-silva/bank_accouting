defmodule BankAccountingWeb.Account.BalanceControllerTest do
  use BankAccountingWeb.ConnCase, async: true

  alias BankAccounting.Accounts
  alias BankAccounting.Accounts.Account
  alias BankAccounting.Users

  describe "with a logged-in user" do
    setup %{conn: conn, login_as: email} do
      {:ok, user} = Users.register_user(%{email: email, password: "secret"})
      {:ok, auth_token} = Users.sign_in_user(user.email, user.password)

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{auth_token.token}")

      {:ok, conn: conn}
    end

    @tag login_as: "tony.stark@avengers.com"
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

    @tag login_as: "tony.stark@avengers.com"
    test "with invalid account returns nothing", %{conn: conn} do
      conn = get(conn, Routes.account_balance_path(conn, :show, 1))

      assert text_response(conn, 404) == "Account not exist"
    end
  end

  test "requires user authentication on action", %{conn: conn} do
    conn = get(conn, Routes.account_balance_path(conn, :show, 1))

    assert conn.status == 401
    assert conn.halted
  end
end
