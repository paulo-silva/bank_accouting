defmodule BankAccountingWeb.AuthView do
  use BankAccountingWeb, :view

  def render("show.json", %{auth_token: auth_token}) do
    %{data: %{token: auth_token.token}}
  end
end
