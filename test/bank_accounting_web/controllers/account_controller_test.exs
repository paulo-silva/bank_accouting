defmodule BankAccountingWeb.AccountControllerTest do
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

    test "list accounts on index when they exists", %{conn: conn} do
      {:ok, %Account{id: account_id}} = Accounts.register_account(%{amount: 89.90})

      conn = get(conn, Routes.account_path(conn, :index))

      expected_result = %{
        "accounts" => [
          %{"id" => account_id, "amount" => "R$ 89,90"}
        ]
      }

      assert json_response(conn, 200) == expected_result
    end

    test "list no accounts they does not exist", %{conn: conn} do
      conn = get(conn, Routes.account_path(conn, :index))

      assert json_response(conn, 200) == %{"accounts" => []}
    end

    test "with valid data creates an account", %{conn: conn} do
      conn = post(conn, Routes.account_path(conn, :index), account: %{amount: 90})

      assert %{"account" => %{"id" => account_id, "amount" => "R$ 90,00"}} =
               json_response(conn, 201)

      assert %Account{id: ^account_id, amount: %Decimal{coef: 90}} =
               Accounts.get_account!(account_id)
    end

    test "with invalid data does not create an account", %{conn: conn} do
      conn = post(conn, Routes.account_path(conn, :index), account: %{amount: -1})

      assert json_response(conn, 422) == %{
               "errors" => %{"amount" => ["must be greater than or equal to 0"]}
             }
    end

    test "with valid account id returns account info", %{conn: conn} do
      {:ok, %Account{id: account_id}} = Accounts.register_account(%{amount: 89.90})

      conn = get(conn, Routes.account_path(conn, :show, account_id))

      assert json_response(conn, 200) == %{
               "account" => %{"id" => account_id, "amount" => "R$ 89,90"}
             }
    end

    test "with invalid account id does not return account info", %{conn: conn} do
      conn = get(conn, Routes.account_path(conn, :show, 1))

      assert conn.status == 404
    end

    test "with valid account id and attributes update account", %{conn: conn} do
      {:ok, %Account{id: account_id}} = Accounts.register_account(%{amount: 89.90})

      conn = put(conn, Routes.account_path(conn, :show, account_id), account: %{amount: 55.80})

      assert json_response(conn, 200) == %{
               "account" => %{"id" => account_id, "amount" => "R$ 55,80"}
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

  test "requires user authentication on all actions", %{conn: conn} do
    [
      get(conn, Routes.account_path(conn, :index)),
      get(conn, Routes.account_path(conn, :show, 123)),
      post(conn, Routes.account_path(conn, :create, %{})),
      put(conn, Routes.account_path(conn, :update, 123, %{})),
      delete(conn, Routes.account_path(conn, :delete, 123))
    ]
    |> Enum.each(fn conn ->
      assert conn.status == 401
      assert conn.halted
    end)
  end
end
