defmodule BankAccountingWeb.UserView do
  @moduledoc false

  use BankAccountingWeb, :view
  alias BankAccounting.Users.User

  def render("create.json", %{user: user}) do
    %{user: User.to_struct(user)}
  end
end
