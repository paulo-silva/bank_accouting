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
end
