defmodule BankAccountingWeb.AuthView do
  @moduledoc false

  use BankAccountingWeb, :view

  def render("show.json", %{auth_token: auth_token}) do
    %{data: %{token: auth_token.token}}
  end
end
