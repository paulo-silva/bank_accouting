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
end
