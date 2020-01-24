defmodule BankAccountingWeb.UserControllerTest do
  use BankAccountingWeb.ConnCase, async: true

  alias BankAccounting.Repo
  alias BankAccounting.Users
  alias BankAccounting.Users.User

  test "with valid data create user", %{conn: conn} do
    user_attrs = %{email: "tony.stark@avengers.com", password: "123456"}
    conn = post(conn, Routes.user_path(conn, :create), user: user_attrs)

    assert %{
             "user" => %{"id" => user_id, "email" => "tony.stark@avengers.com"}
           } = json_response(conn, 201)

    assert %User{id: ^user_id, email: "tony.stark@avengers.com"} = Users.get_user!(user_id)
  end

  test "with invalid data does not create user", %{conn: conn} do
    conn = post(conn, Routes.user_path(conn, :create), user: %{email: nil, password: "123456"})

    assert json_response(conn, 422) == %{
             "errors" => %{"email" => ["can't be blank"]}
           }
  end

  test "with email already registered does not create user", %{conn: conn} do
    user_attrs = %{email: "tony.stark@avengers.com", password: "123456"}
    Users.register_user(user_attrs)

    conn = post(conn, Routes.user_path(conn, :create), user: user_attrs)

    assert json_response(conn, 422) == %{
             "errors" => %{"email" => ["has already been taken"]}
           }
  end

end
