defmodule BankAccounting.Helpers do
  @moduledoc """
    Module that add some function helpers to the application
  """

  @doc """
  Format provided number into R$ currency

  ## Examples

    iex> BankAccounting.Helpers.number_to_currency(90)
      "R$ 90,00"
  """
  @spec number_to_currency(number | Decimal.t()) :: String.t()
  def number_to_currency(number) do
    options = [
      unit: "R$ ",
      separator: ",",
      delimiter: ".",
      precision: 2
    ]

    Number.Currency.number_to_currency(number, options)
  end
end
