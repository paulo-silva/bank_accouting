defmodule BankAccountingWeb.UserView do
  use BankAccountingWeb, :view
  alias BankAccounting.Users.User

  def render("create.json", %{user: user}) do
    %{user: User.to_struct(user)}
  end
end
