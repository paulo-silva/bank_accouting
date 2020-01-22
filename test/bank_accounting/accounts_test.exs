defmodule BankAccounting.AccountsTest do
  use BankAccounting.DataCase, async: true

  alias BankAccounting.Accounts
  alias BankAccounting.Accounts.Account

  describe "register_account/1" do
    @valid_attrs %{
      amount: 100
    }

    @invalid_attrs %{
      amount: -1
    }

    test "with valid data inserts account" do
      assert {:ok, %Account{} = account} = Accounts.register_account(@valid_attrs)
      assert account.amount == Decimal.new(100)
    end

    test "with invalid data does not inserts account" do
      assert {:error, changeset} = Accounts.register_account(@invalid_attrs)
      assert %{amount: ["must be greater than or equal to 0"]} = errors_on(changeset)
    end
  end
end
