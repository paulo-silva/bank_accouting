defmodule BankAccounting.AccountsTest do
  use BankAccounting.DataCase, async: true

  alias BankAccounting.Accounts
  alias BankAccounting.Accounts.{Account, Transfers, Transfer}

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

  describe "transfer_money/3" do
    test "with valid accounts and needed balance transfers money" do
      {:ok, %Account{id: origin_id} = origin_account} = Accounts.register_account(@valid_attrs)
      {:ok, %Account{id: destiny_id} = destiny_account} = Accounts.register_account(@valid_attrs)

      assert {:ok, :transferred} = Accounts.transfer_money(origin_account, destiny_account, 50)

      assert Accounts.get_account!(origin_id).amount == Decimal.new(50)

      assert Accounts.get_account!(destiny_id).amount == Decimal.new(150)

      assert [
               %Transfer{
                 origin_account_id: origin_id,
                 destiny_account_id: destiny_id,
                 amount: %Decimal{coef: 50}
               }
             ] = Transfers.list_account_transfers(origin_account)
    end

    test "with not enough balance does not transfer money" do
      {:ok, %Account{} = origin_account} = Accounts.register_account(@valid_attrs)
      {:ok, %Account{} = destiny_account} = Accounts.register_account(@valid_attrs)

      assert {:error, :not_transferred} =
               Accounts.transfer_money(origin_account, destiny_account, 300)
    end

    test "with invalid account does not transfer money" do
      {:ok, %Account{} = origin_account} = Accounts.register_account(@valid_attrs)
      destiny_account = %Account{amount: 0}

      assert_raise Ecto.NoPrimaryKeyValueError, ~r/is missing primary key value/, fn ->
        Accounts.transfer_money(origin_account, destiny_account, 50)
      end

      assert origin_account.amount == Decimal.new(100)
    end
  end
end
