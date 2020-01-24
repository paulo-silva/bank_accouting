defmodule BankAccountingWeb.TransferControllerTest do
  use BankAccountingWeb.ConnCase, async: true

  alias BankAccounting.Accounts
  alias BankAccounting.Accounts.Account
  alias BankAccounting.Users

  describe "with a logged-in user" do
    setup %{conn: conn} do
      {:ok, user} = Users.register_user(%{email: "tony.stark@avengers.com", password: "secret"})
      {:ok, auth_token} = Users.sign_in_user(user.email, user.password)

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{auth_token.token}")

      {:ok, conn: conn}
    end

    test "with valid data transfer money", %{conn: conn} do
      {:ok, %Account{id: origin_account_id}} = Accounts.register_account(%{amount: 100})
      {:ok, %Account{id: destiny_account_id}} = Accounts.register_account(%{amount: 0})

      conn =
        post(conn, Routes.transfer_path(conn, :create), %{
          source_account_id: origin_account_id,
          destiny_account_id: destiny_account_id,
          amount: 75
        })

      assert json_response(conn, 201) == %{"status" => "transferred"}

      assert %Account{id: ^origin_account_id, amount: %Decimal{coef: 25}} =
               Accounts.get_account!(origin_account_id)

      assert %Account{id: ^destiny_account_id, amount: %Decimal{coef: 75}} =
               Accounts.get_account!(destiny_account_id)
    end

    test "with not enough money does not transfer", %{conn: conn} do
      {:ok, %Account{id: origin_account_id}} = Accounts.register_account(%{amount: 50})
      {:ok, %Account{id: destiny_account_id}} = Accounts.register_account(%{amount: 0})

      conn =
        post(conn, Routes.transfer_path(conn, :create), %{
          source_account_id: origin_account_id,
          destiny_account_id: destiny_account_id,
          amount: 75
        })

      assert json_response(conn, 422) == %{"status" => "not_transferred"}

      assert %Account{id: ^origin_account_id, amount: %Decimal{coef: 50}} =
               Accounts.get_account!(origin_account_id)

      assert %Account{id: ^destiny_account_id, amount: %Decimal{coef: 0}} =
               Accounts.get_account!(destiny_account_id)
    end
  end

  test "requires user authentication on action", %{conn: conn} do
    conn = post(conn, Routes.transfer_path(conn, :create), %{})

    assert conn.status == 401
    assert conn.halted
  end
end
