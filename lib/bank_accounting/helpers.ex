defmodule BankAccounting.Helpers do
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
