defmodule BankAccountingWeb.AccountControllerTest do
  use BankAccountingWeb.ConnCase, async: true

  alias BankAccounting.Accounts
  alias BankAccounting.Accounts.Account

  describe "GET /accounts" do
    test "list accounts on index when they exists", %{conn: conn} do
      {:ok, %Account{id: account_id}} = Accounts.register_account(%{amount: 89.90})

      conn = get(conn, Routes.account_path(conn, :index))

      expected_result = %{
        "accounts" => [
          %{"id" => account_id, "amount" => "89.9"}
        ]
      }

      assert json_response(conn, 200) == expected_result
    end

    test "list no accounts they does not exist", %{conn: conn} do
      conn = get(conn, Routes.account_path(conn, :index))

      assert json_response(conn, 200) == %{"accounts" => []}
    end
  end

  describe "POST /accounts" do
    @valid_attrs %{
      amount: 90
    }

    @invalid_attrs %{
      amount: -1
    }

    test "with valid data creates an account", %{conn: conn} do
      conn = post(conn, Routes.account_path(conn, :index), account: @valid_attrs)

      assert %{"account" => %{"id" => account_id, "amount" => "90"}} = json_response(conn, 201)

      assert %Account{id: ^account_id, amount: %Decimal{coef: 90}} =
               Accounts.get_account!(account_id)
    end

    test "with invalid data does not create an account", %{conn: conn} do
      conn = post(conn, Routes.account_path(conn, :index), account: @invalid_attrs)

      assert json_response(conn, 422) == %{
               "errors" => %{"amount" => ["must be greater than or equal to 0"]}
             }
    end
  end

  describe "GET /accounts/:id" do
    test "with valid account id returns account info", %{conn: conn} do
      {:ok, %Account{id: account_id}} = Accounts.register_account(%{amount: 89.90})

      conn = get(conn, Routes.account_path(conn, :show, account_id))

      assert json_response(conn, 200) == %{
               "account" => %{"id" => account_id, "amount" => "89.9"}
             }
    end

    test "with invalid account id does not return account info", %{conn: conn} do
      conn = get(conn, Routes.account_path(conn, :show, 1))

      assert conn.status == 404
    end
  end

  describe "PUT /accounts/id" do
    test "with valid account id and attributes update account", %{conn: conn} do
      {:ok, %Account{id: account_id}} = Accounts.register_account(%{amount: 89.90})

      conn = put(conn, Routes.account_path(conn, :show, account_id), account: %{amount: 55.80})

      assert json_response(conn, 200) == %{
               "account" => %{"id" => account_id, "amount" => "55.8"}
             }
    end

    test "with invalid attributes does not update account", %{conn: conn} do
      {:ok, %Account{id: account_id}} = Accounts.register_account(%{amount: 89.90})

      conn = put(conn, Routes.account_path(conn, :show, account_id), account: %{amount: -1})

      assert json_response(conn, 422) == %{
               "errors" => %{"amount" => ["must be greater than or equal to 0"]}
             }

      assert %Account{amount: %Decimal{coef: 899, exp: -1, sign: 1}} =
               Accounts.get_account!(account_id)
    end

    test "with invalid account id does not update account", %{conn: conn} do
      conn = put(conn, Routes.account_path(conn, :show, 1), account: %{amount: 55.80})

      assert conn.status == 404
    end
  end

  describe "DELETE /accounts/:id" do
    test "with valid account id delete account", %{conn: conn} do
      {:ok, %Account{id: account_id}} = Accounts.register_account(%{amount: 89.90})

      conn = delete(conn, Routes.account_path(conn, :show, account_id))
      conn_status = conn.status

      assert conn_status == 204
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_account!(account_id) end
    end

    test "with invalid account id does not delete any account", %{conn: conn} do
      conn = delete(conn, Routes.account_path(conn, :show, 1))
      conn_status = conn.status

      assert conn_status == 404
    end
  end
end
