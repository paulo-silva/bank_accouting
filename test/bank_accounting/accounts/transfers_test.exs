defmodule BankAccounting.Accounts.TransfersTest do
  use BankAccounting.DataCase, async: true

  alias BankAccounting.Accounts
  alias BankAccounting.Accounts.{Transfers, Transfer, Account}

  describe "register_transfer/1" do
    @valid_attrs %{
      amount: 100,
      type: "credit"
    }

    @invalid_attrs %{
      amount: -1,
      type: "invalid_type"
    }

    setup do
      {:ok, origin_account} = Accounts.register_account(%{amount: 0})
      {:ok, destiny_account} = Accounts.register_account(%{amount: 0})

      {:ok, origin_account: origin_account, destiny_account: destiny_account}
    end

    test "with valid data inserts transfer", %{
      origin_account: origin_account,
      destiny_account: destiny_account
    } do
      attrs =
        Map.merge(@valid_attrs, %{
          origin_account: origin_account,
          destiny_account: destiny_account
        })

      origin_account_id = origin_account.id
      destiny_account_id = destiny_account.id

      assert {
               :ok,
               %Transfer{
                 id: transfer_id,
                 origin_account: %Account{id: ^origin_account_id},
                 destiny_account: %Account{id: ^destiny_account_id},
                 amount: %Decimal{coef: 100, exp: 0, sign: 1}
               }
             } = Transfers.register_transfer(attrs)
    end

    test "with invalid data does not insert transfer", %{
      origin_account: origin_account,
      destiny_account: destiny_account
    } do
      attrs =
        Map.merge(@invalid_attrs, %{
          origin_account: origin_account,
          destiny_account: destiny_account
        })

      assert {:error, changeset} = Transfers.register_transfer(attrs)

      assert %{amount: ["must be greater than or equal to 0"]} = errors_on(changeset)
    end
  end

end
